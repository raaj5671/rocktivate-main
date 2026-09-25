import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class _ChatMessage {
  const _ChatMessage({required this.role, required this.text});
  final String role; // 'user' or 'assistant'
  final String text;
}

/// A real back-and-forth chat with Claude, seeded with an initial question
/// (a verse's "Ask"/"Compare" prompt, or a typed search query) and then open
/// for follow-ups — unlike the single-shot `AIResponseWidget` used elsewhere
/// in the app (e.g. from Home), which this intentionally doesn't touch.
/// Presented as content inside the Bible feature's floating bottom sheet
/// (see `_FloatingSheet` in chapter_data_widget.dart), matching
/// `VerseSearchWidget`/`VerseCompareWidget`'s pattern of not owning its own
/// sheet chrome.
class AIChatWidget extends StatefulWidget {
  const AIChatWidget({super.key, required this.initialQuestion});

  final String initialQuestion;

  @override
  State<AIChatWidget> createState() => _AIChatWidgetState();
}

class _AIChatWidgetState extends State<AIChatWidget> {
  final List<_ChatMessage> _messages = [];
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _sendMessage(widget.initialQuestion);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _loading) return;
    setState(() {
      _messages.add(_ChatMessage(role: 'user', text: trimmed));
      _loading = true;
    });
    _inputController.clear();
    _scrollToBottom();
    try {
      final history =
          _messages.map((m) => {'role': m.role, 'content': m.text}).toList();
      final response = await ChatGPTCall.call(history: history);
      final reply = response.succeeded
          ? (ChatGPTCall.aIResponse(response.jsonBody) ??
              'No response received.')
          : 'There was an error getting a response. Please try again.';
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(role: 'assistant', text: reply));
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add(const _ChatMessage(
          role: 'assistant',
          text: 'Something went wrong. Please try again.',
        ));
        _loading = false;
      });
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? Colors.white : FlutterFlowTheme.of(context).primaryText;
    final secondaryTextColor = isDark
        ? const Color(0xFF9A9AA2)
        : FlutterFlowTheme.of(context).secondaryText;
    final primary = FlutterFlowTheme.of(context).primary;
    final assistantBubbleBg =
        isDark ? const Color(0xFF262629) : const Color(0xFFECECEC);
    final inputFieldBg = isDark
        ? const Color(0xFF1A1A1E)
        : FlutterFlowTheme.of(context).alternate;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome_rounded, color: primary, size: 20.0),
            const SizedBox(width: 8.0),
            Text(
              'Ask AI',
              style: GoogleFonts.interTight(
                color: textColor,
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 8.0),
            itemCount: _messages.length + (_loading ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 10.0),
            itemBuilder: (context, index) {
              if (index >= _messages.length) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: assistantBubbleBg,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SizedBox(
                      width: 16.0,
                      height: 16.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(secondaryTextColor),
                      ),
                    ),
                  ),
                );
              }
              final message = _messages[index];
              final isUser = message.role == 'user';
              return Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.78,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isUser ? primary : assistantBubbleBg,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: isUser
                      ? Text(
                          message.text,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14.5,
                            height: 1.35,
                          ),
                        )
                      : MarkdownBody(
                          data: message.text,
                          selectable: true,
                          styleSheet:
                              MarkdownStyleSheet.fromTheme(Theme.of(context))
                                  .copyWith(
                            p: GoogleFonts.inter(
                              color: textColor,
                              fontSize: 14.5,
                              height: 1.35,
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: _sendMessage,
                style: GoogleFonts.inter(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Ask a follow-up…',
                  hintStyle: GoogleFonts.inter(color: secondaryTextColor),
                  filled: true,
                  fillColor: inputFieldBg,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            GlassButton(
              icon: const Icon(Icons.arrow_upward_rounded),
              onTap: () => _sendMessage(_inputController.text),
              width: 44.0,
              height: 44.0,
              iconColor: Colors.white,
              style: GlassButtonStyle.prominent,
              useOwnLayer: true,
              quality: GlassQuality.standard,
              settings: LiquidGlassSettings(
                glassColor: primary.withValues(alpha: 0.7),
                thickness: 30,
                blur: 12.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
