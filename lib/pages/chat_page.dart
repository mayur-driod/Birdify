import 'dart:math';

import 'package:birdify/bloc/chatbloc_bloc.dart';
import 'package:birdify/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  // ── Voice input ──
  final _speech = SpeechToText();
  bool _isListening = false;
  bool _speechEnabled = false;

  static const _suggestions = [
    'Which birds live near lakes?',
    'What do woodpeckers eat?',
    'How do birds navigate during migration?',
    'Tell me about Indian birds.',
    'What is the rarest bird in the world?',
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onError: (_) => setState(() => _isListening = false),
      onStatus: (status) {
        if (status == SpeechToText.notListeningStatus ||
            status == 'done') {
          setState(() => _isListening = false);
        }
      },
    );
  }

  Future<void> _toggleMic() async {
    if (!_speechEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition is not available on this device'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      _controller.clear();
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          setState(() => _controller.text = result.recognizedWords);
          if (result.finalResult) {
            setState(() => _isListening = false);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
      );
    }
  }

  void _send([String? override]) {
    final text = (override ?? _controller.text).trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<ChatblocBloc>().add(SendMessageEvent(text));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _speech.stop();
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
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
              child: Icon(Icons.smart_toy_outlined, color: cs.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bird Expert',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    letterSpacing: -0.3,
                    color: cs.onSurface,
                    height: 1.1,
                  ),
                ),
                Text(
                  'Powered by Gemini AI',
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: 0.45),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: BlocBuilder<ChatblocBloc, ChatblocState>(
              builder: (context, state) {
                final hasMessages = state is! ChatblocInitial;
                return IconButton(
                  tooltip: 'Clear chat',
                  style: IconButton.styleFrom(
                    backgroundColor: hasMessages
                        ? cs.error.withValues(alpha: 0.1)
                        : cs.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: hasMessages
                        ? cs.error
                        : cs.onSurface.withValues(alpha: 0.4),
                  ),
                  onPressed: hasMessages
                      ? () => context
                          .read<ChatblocBloc>()
                          .add(ClearChatEvent())
                      : null,
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatblocBloc, ChatblocState>(
              listener: (context, state) {
                if (state is ChatLoading || state is ChatLoaded) {
                  _scrollToBottom();
                }
                if (state is ChatError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: cs.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ChatblocInitial) {
                  return _WelcomeView(
                    cs: cs,
                    isDark: isDark,
                    suggestions: _suggestions,
                    onSuggestion: _send,
                  );
                }

                final messages = switch (state) {
                  ChatLoading(:final messages) => messages,
                  ChatLoaded(:final messages) => messages,
                  ChatError(:final messages) => messages,
                  _ => <ChatMessage>[],
                };
                final isLoading = state is ChatLoading;

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: messages.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      return _TypingIndicator(cs: cs);
                    }
                    return _MessageBubble(
                      message: messages[index],
                      cs: cs,
                    );
                  },
                );
              },
            ),
          ),
          _InputBar(
            controller: _controller,
            focusNode: _focusNode,
            cs: cs,
            onSend: _send,
            onMic: _toggleMic,
            isListening: _isListening,
          ),
        ],
      ),
    );
  }
}

// ── Welcome View ─────────────────────────────────────────────────────────────

class _WelcomeView extends StatelessWidget {
  const _WelcomeView({
    required this.cs,
    required this.isDark,
    required this.suggestions,
    required this.onSuggestion,
  });

  final ColorScheme cs;
  final bool isDark;
  final List<String> suggestions;
  final void Function(String) onSuggestion;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero welcome card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  cs.primary.withValues(alpha: 0.12),
                  cs.primary.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: cs.primary.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.primary.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    Icons.smart_toy_outlined,
                    color: cs.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, I'm Birdy!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your personal bird expert. Ask me anything — species, habitats, migration, birdwatching tips, and more.',
                        style: TextStyle(
                          fontSize: 14,
                          color: cs.onSurface.withValues(alpha: 0.6),
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'SUGGESTED QUESTIONS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 12),
          ...suggestions.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _SuggestionTile(
                text: s,
                cs: cs,
                onTap: () => onSuggestion(s),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.text,
    required this.cs,
    required this.onTap,
  });

  final String text;
  final ColorScheme cs;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
          ),
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 16,
                color: cs.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurface.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: cs.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Message Bubble ────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.cs});

  final ChatMessage message;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final hour = message.timestamp.hour.toString().padLeft(2, '0');
    final min = message.timestamp.minute.toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.primary.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    Icons.smart_toy_outlined,
                    size: 15,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? cs.primary
                        : cs.surfaceContainerHighest.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: isUser
                          ? const Radius.circular(20)
                          : const Radius.circular(4),
                      bottomRight: isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(20),
                    ),
                  ),
                  child: isUser
                      ? Text(
                          message.text,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.55,
                            color: cs.onPrimary,
                          ),
                        )
                      : MarkdownBody(
                          data: message.text,
                          shrinkWrap: true,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              fontSize: 15,
                              height: 1.55,
                              color: cs.onSurface,
                            ),
                            pPadding: const EdgeInsets.only(bottom: 6),
                            strong: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                            em: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: cs.onSurface,
                            ),
                            code: TextStyle(
                              fontSize: 13,
                              fontFamily: 'monospace',
                              color: cs.primary,
                              backgroundColor:
                                  cs.primary.withValues(alpha: 0.08),
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            blockquote: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: cs.onSurface.withValues(alpha: 0.65),
                              height: 1.5,
                            ),
                            blockquoteDecoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: cs.primary.withValues(alpha: 0.5),
                                  width: 3,
                                ),
                              ),
                            ),
                            listBullet: TextStyle(
                              fontSize: 15,
                              color: cs.primary,
                            ),
                            h1: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                              letterSpacing: -0.3,
                            ),
                            h2: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                            h3: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                            h1Padding:
                                const EdgeInsets.only(top: 4, bottom: 6),
                            h2Padding:
                                const EdgeInsets.only(top: 4, bottom: 6),
                            h3Padding:
                                const EdgeInsets.only(top: 2, bottom: 4),
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Padding(
            padding: EdgeInsets.only(
              left: isUser ? 0 : 38,
              right: isUser ? 0 : 0,
            ),
            child: Text(
              '$hour:$min',
              style: TextStyle(
                fontSize: 10,
                color: cs.onSurface.withValues(alpha: 0.3),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Typing Indicator ──────────────────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator({required this.cs});
  final ColorScheme cs;

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = widget.cs;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primary.withValues(alpha: 0.15),
            ),
            child: Icon(Icons.smart_toy_outlined, size: 15, color: cs.primary),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final phase = (_ctrl.value - i * 0.18).clamp(0.0, 1.0);
                    final y = sin(phase * 2 * pi) * 4;
                    return Transform.translate(
                      offset: Offset(0, -y),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.primary.withValues(alpha: 0.55),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Input Bar ─────────────────────────────────────────────────────────────────

class _InputBar extends StatefulWidget {
  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.cs,
    required this.onSend,
    required this.onMic,
    required this.isListening,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ColorScheme cs;
  final VoidCallback onSend;
  final VoidCallback onMic;
  final bool isListening;

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.isListening) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_InputBar old) {
    super.didUpdateWidget(old);
    if (widget.isListening != old.isListening) {
      if (widget.isListening) {
        _pulse.repeat(reverse: true);
      } else {
        _pulse.stop();
        _pulse.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = widget.cs;
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: cs.onSurface.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => widget.onSend(),
              decoration: InputDecoration(
                hintText: widget.isListening ? 'Listening…' : 'Ask about birds…',
                hintStyle: TextStyle(
                  color: widget.isListening
                      ? cs.error.withValues(alpha: 0.55)
                      : cs.onSurface.withValues(alpha: 0.35),
                  fontSize: 15,
                ),
                filled: true,
                fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: widget.isListening
                        ? cs.error.withValues(alpha: 0.4)
                        : cs.onSurface.withValues(alpha: 0.08),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: cs.primary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Adaptive mic / send button
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller,
            builder: (context, value, _) {
              final hasText = value.text.trim().isNotEmpty;
              return SizedBox(
                width: 48,
                height: 48,
                child: widget.isListening
                    ? AnimatedBuilder(
                        animation: _pulse,
                        builder: (context, child) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: cs.error.withValues(
                                  alpha: 0.25 + _pulse.value * 0.3,
                                ),
                                blurRadius: 6 + _pulse.value * 14,
                                spreadRadius: _pulse.value * 4,
                              ),
                            ],
                          ),
                          child: child,
                        ),
                        child: FilledButton(
                          onPressed: widget.onMic,
                          style: FilledButton.styleFrom(
                            backgroundColor: cs.error,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Icon(Icons.stop_rounded, size: 20),
                        ),
                      )
                    : FilledButton(
                        onPressed: hasText ? widget.onSend : widget.onMic,
                        style: FilledButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, anim) => ScaleTransition(
                            scale: anim,
                            child: child,
                          ),
                          child: hasText
                              ? const Icon(
                                  Icons.arrow_upward_rounded,
                                  size: 20,
                                  key: ValueKey('send'),
                                )
                              : const Icon(
                                  Icons.mic_rounded,
                                  size: 20,
                                  key: ValueKey('mic'),
                                ),
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
