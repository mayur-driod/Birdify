import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Structured result from the Gemini bird identification API.
class BirdResult {
  const BirdResult({
    required this.commonName,
    required this.scientificName,
    required this.description,
    required this.habitat,
    required this.funFact,
    required this.conservationStatus,
    this.notBird = false,
  });

  final String commonName;
  final String scientificName;
  final String description;
  final String habitat;
  final String funFact;
  final String conservationStatus;
  final bool notBird;

  static BirdResult noBird() => const BirdResult(
    commonName: 'No bird detected',
    scientificName: '',
    description:
        'No bird was found in this photo. Try again with a clearer image.',
    habitat: '',
    funFact: '',
    conservationStatus: '',
    notBird: true,
  );

  factory BirdResult.fromJson(Map<String, dynamic> json) {
    if (json['notBird'] == true) return BirdResult.noBird();
    return BirdResult(
      commonName: (json['commonName'] as String? ?? 'Unknown').trim(),
      scientificName: (json['scientificName'] as String? ?? '').trim(),
      description: (json['description'] as String? ?? '').trim(),
      habitat: (json['habitat'] as String? ?? '').trim(),
      funFact: (json['funFact'] as String? ?? '').trim(),
      conservationStatus: (json['conservationStatus'] as String? ?? '').trim(),
    );
  }
}

/// Thin wrapper around the Gemini Vision API for bird identification and chat.
class GeminiService {
  static const _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  static const _chatSystemPrompt =
      'You are an expert ornithologist and friendly bird-watching guide named "Birdy". '
      'Help users identify, learn about, and appreciate birds. '
      'Answer questions about bird species, habitats, behaviours, migration, conservation, '
      'and birdwatching tips. Be warm, concise, and accurate. '
      'Keep responses to 2–3 short paragraphs unless more detail is specifically requested.';

  static const _prompt =
      'You are a bird identification expert. Analyze the image.\n\n'
      'If you see a bird, return a JSON object with these exact keys:\n'
      '{\n'
      '  "notBird": false,\n'
      '  "commonName": "Common name of the bird",\n'
      '  "scientificName": "Scientific binomial name",\n'
      '  "description": "2-3 sentence description of the bird",\n'
      '  "habitat": "Where this bird is typically found",\n'
      '  "funFact": "One interesting fun fact about this bird",\n'
      '  "conservationStatus": "IUCN status e.g. Least Concern, Vulnerable"\n'
      '}\n\n'
      'If there is no bird in the image, return:\n'
      '{ "notBird": true }\n\n'
      'Return only valid JSON, nothing else.';

  static String get _key {
    if (!dotenv.isInitialized) {
      throw Exception(
        'Could not load .env — do a full restart (not hot reload).',
      );
    }
    final key = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (key.isEmpty || key == 'your_api_key_here') {
      throw Exception(
        'GEMINI_API_KEY is not set. Open the .env file and add your key.',
      );
    }
    return key;
  }

  static Future<BirdResult> identifyBird(File image) async {
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http
        .post(
          Uri.parse('$_endpoint?key=$_key'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': _prompt},
                  {
                    'inline_data': {
                      'mime_type': 'image/jpeg',
                      'data': base64Image,
                    },
                  },
                ],
              },
            ],
            'generationConfig': {'responseMimeType': 'application/json'},
          }),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini API error (${response.statusCode}):\n${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final raw =
        data['candidates'][0]['content']['parts'][0]['text'] as String;

    // Strip any accidental markdown code fences
    final cleaned = raw
        .replaceAll(RegExp(r'^```json\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
        .trim();

    final json = jsonDecode(cleaned) as Map<String, dynamic>;
    return BirdResult.fromJson(json);
  }

  // ── Chat ──────────────────────────────────────────────────────────────────

  /// Send a user [message] to the Gemini chat model along with [history].
  ///
  /// [history] entries must have keys `"role"` (`"user"` | `"model"`) and
  /// `"text"`.  Returns the model's plain-text reply.
  static Future<String> chatAboutBirds(
    String message,
    List<Map<String, String>> history,
  ) async {
    final contents = <Map<String, dynamic>>[
      for (final msg in history)
        {
          'role': msg['role']!,
          'parts': [
            {'text': msg['text']!},
          ],
        },
      {
        'role': 'user',
        'parts': [
          {'text': message},
        ],
      },
    ];

    final response = await http
        .post(
          Uri.parse('$_endpoint?key=$_key'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'system_instruction': {
              'parts': [
                {'text': _chatSystemPrompt},
              ],
            },
            'contents': contents,
          }),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini API error (${response.statusCode}):\n${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['candidates'][0]['content']['parts'][0]['text'] as String)
        .trim();
  }
}

