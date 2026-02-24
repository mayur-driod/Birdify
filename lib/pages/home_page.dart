import 'dart:io';

import 'package:birdify/main.dart';
import 'package:birdify/repos/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  bool _isLoading = false;
  final _picker = ImagePicker();

  Future<void> _pick(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  void _clear() => setState(() => _image = null);

  Future<void> _identifyBird() async {
    if (_image == null || _isLoading) return;
    setState(() => _isLoading = true);
    try {
      final result = await GeminiService.identifyBird(_image!);
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _ResultSheet(result: result),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 24,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.flutter_dash, color: cs.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'Birdify',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.3,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              tooltip: isDark ? 'Light mode' : 'Dark mode',
              style: IconButton.styleFrom(
                backgroundColor: cs.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                size: 18,
                color: cs.onSurface,
              ),
              onPressed: () {
                themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                _image == null ? 'Identify a bird' : 'Ready to identify',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _isLoading
                    ? 'Analyzing your image…'
                    : _image == null
                    ? 'Take or upload a photo to get started'
                    : 'Tap identify to find out what bird this is',
                style: TextStyle(
                  fontSize: 14,
                  color: cs.onSurface.withValues(alpha: 0.5),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _image == null
                      ? _Placeholder(cs: cs, key: const ValueKey('placeholder'))
                      : _ImagePreview(
                          image: _image!,
                          cs: cs,
                          key: const ValueKey('preview'),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              _Actions(
                hasImage: _image != null,
                isLoading: _isLoading,
                cs: cs,
                onCamera: () => _pick(ImageSource.camera),
                onGallery: () => _pick(ImageSource.gallery),
                onIdentify: _identifyBird,
                onClear: _clear,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Placeholder ──────────────────────────────────────────────────────────────

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.cs, super.key});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.25),
          width: 1.5,
        ),
        gradient: LinearGradient(
          colors: [
            cs.primary.withValues(alpha: 0.07),
            cs.primary.withValues(alpha: 0.03),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primary.withValues(alpha: 0.12),
            ),
            child: Icon(Icons.flutter_dash, size: 72, color: cs.primary),
          ),
          const SizedBox(height: 24),
          Text(
            'No bird captured yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Use your camera or gallery\nto snap a bird photo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: cs.onSurface.withValues(alpha: 0.45),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Image Preview ─────────────────────────────────────────────────────────────

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.image, required this.cs, super.key});

  final File image;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Image.file(
        image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

// ── Actions ───────────────────────────────────────────────────────────────────

class _Actions extends StatelessWidget {
  const _Actions({
    required this.hasImage,
    required this.isLoading,
    required this.cs,
    required this.onCamera,
    required this.onGallery,
    required this.onIdentify,
    required this.onClear,
  });

  final bool hasImage;
  final bool isLoading;
  final ColorScheme cs;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onIdentify;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (hasImage) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: isLoading ? null : onIdentify,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isLoading
                    ? SizedBox(
                        key: const ValueKey('spinner'),
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: cs.onPrimary,
                        ),
                      )
                    : Row(
                        key: const ValueKey('label'),
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.saved_search_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Identify Bird',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton.icon(
              onPressed: isLoading ? null : onClear,
              icon: Icon(
                Icons.refresh_rounded,
                size: 18,
                color: cs.onSurface.withValues(alpha: 0.55),
              ),
              label: Text(
                'Choose a different image',
                style: TextStyle(
                  fontSize: 14,
                  color: cs.onSurface.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: onCamera,
              icon: const Icon(Icons.camera_alt_outlined, size: 20),
              label: const Text(
                'Camera',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: onGallery,
              icon: const Icon(Icons.photo_library_outlined, size: 20),
              label: const Text(
                'Gallery',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: cs.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Result Bottom Sheet ───────────────────────────────────────────────────────

class _ResultSheet extends StatelessWidget {
  const _ResultSheet({required this.result});

  final BirdResult result;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Name + close button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.commonName,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: cs.onSurface,
                          height: 1.1,
                        ),
                      ),
                      if (result.scientificName.isNotEmpty) ...([
                        const SizedBox(height: 4),
                        Text(
                          result.scientificName,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: cs.onSurface.withValues(alpha: 0.45),
                            letterSpacing: 0.1,
                          ),
                        ),
                      ]),
                      if (result.conservationStatus.isNotEmpty) ...([
                        const SizedBox(height: 12),
                        _ConservationBadge(
                          status: result.conservationStatus,
                          cs: cs,
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    color: cs.onSurface.withValues(alpha: 0.5),
                    size: 18,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: cs.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Divider(height: 1, color: cs.onSurface.withValues(alpha: 0.08)),

          // Info cards
          Flexible(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              shrinkWrap: true,
              children: [
                if (result.description.isNotEmpty)
                  _InfoCard(
                    icon: Icons.subject_rounded,
                    label: 'ABOUT',
                    content: result.description,
                    cs: cs,
                  ),
                if (result.habitat.isNotEmpty) ...([
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.forest_outlined,
                    label: 'HABITAT',
                    content: result.habitat,
                    cs: cs,
                  ),
                ]),
                if (result.funFact.isNotEmpty) ...([
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.bolt_rounded,
                    label: 'FUN FACT',
                    content: result.funFact,
                    cs: cs,
                    accent: true,
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Card ─────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.content,
    required this.cs,
    this.accent = false,
  });

  final IconData icon;
  final String label;
  final String content;
  final ColorScheme cs;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final bgColor = accent
        ? cs.primary.withValues(alpha: 0.08)
        : cs.surfaceContainerHighest.withValues(alpha: 0.6);
    final iconColor =
        accent ? cs.primary : cs.onSurface.withValues(alpha: 0.45);
    final labelColor =
        accent ? cs.primary : cs.onSurface.withValues(alpha: 0.45);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: iconColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: labelColor,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 15, height: 1.65, color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}

// ── Conservation Badge ────────────────────────────────────────────────────────

class _ConservationBadge extends StatelessWidget {
  const _ConservationBadge({required this.status, required this.cs});

  final String status;
  final ColorScheme cs;

  Color _resolveColor() {
    final l = status.toLowerCase();
    if (l.contains('extinct')) return Colors.grey;
    if (l.contains('critical')) return Colors.red;
    if (l.contains('endangered')) return Colors.deepOrange;
    if (l.contains('vulnerable')) return Colors.orange;
    if (l.contains('near threatened')) return Colors.amber;
    return cs.primary; // Least Concern or unknown
  }

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
