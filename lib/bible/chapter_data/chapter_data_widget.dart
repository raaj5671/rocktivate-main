import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_flip/page_flip.dart';
import 'chapter_data_model.dart';
export 'chapter_data_model.dart';

class _BibleVerse {
  const _BibleVerse(this.number, this.text);
  final String number;
  final String text;
}

// Walks the chapter's HTML and reconstructs it as plain verse text, since
// a WebView can't paginate into flip-able pages the way native text can.
List<_BibleVerse> _parseVerses(String html) {
  final document = html_parser.parse(html);
  final verses = <_BibleVerse>[];
  String? currentNumber;
  final buffer = StringBuffer();

  void flush() {
    final text = buffer.toString().trim();
    if (currentNumber != null && text.isNotEmpty) {
      verses.add(_BibleVerse(currentNumber!, text));
    }
    buffer.clear();
  }

  void walk(dom.Node node) {
    if (node is dom.Element) {
      final classes = node.classes;
      if (classes.contains('v')) {
        flush();
        currentNumber = node.text.trim();
        return;
      }
      if (node.localName == 'h3' ||
          node.localName == 'h4' ||
          classes.contains('label')) {
        return;
      }
      for (final child in node.nodes) {
        walk(child);
      }
      if (node.localName == 'p') {
        buffer.write('\n\n');
      }
    } else if (node is dom.Text) {
      buffer.write(node.text);
    }
  }

  final body = document.body;
  if (body != null) {
    for (final child in body.nodes) {
      walk(child);
    }
  }
  flush();
  return verses;
}

// Groups verses into pages using a character-count heuristic tuned for a
// phone screen at reading font size. Not pixel-perfect, so each page can
// still scroll a little as a safety net if it slightly overflows.
List<List<_BibleVerse>> _paginate(
  List<_BibleVerse> verses, {
  int maxCharsPerPage = 700,
  int maxVersesPerPage = 12,
}) {
  final pages = <List<_BibleVerse>>[];
  var current = <_BibleVerse>[];
  var charCount = 0;
  for (final verse in verses) {
    final verseLength = verse.text.length + 6;
    if (current.isNotEmpty &&
        (charCount + verseLength > maxCharsPerPage ||
            current.length >= maxVersesPerPage)) {
      pages.add(current);
      current = [];
      charCount = 0;
    }
    current.add(verse);
    charCount += verseLength;
  }
  if (current.isNotEmpty) {
    pages.add(current);
  }
  if (pages.isEmpty) {
    pages.add(const []);
  }
  return pages;
}

class ChapterDataWidget extends StatefulWidget {
  const ChapterDataWidget({
    super.key,
    String? title,
    required this.bibleid,
    required this.chapterid,
  }) : title = title ?? 'Books';

  final String title;
  final String? bibleid;
  final String? chapterid;

  static String routeName = 'ChapterData';
  static String routePath = '/Chapter';

  @override
  State<ChapterDataWidget> createState() => _ChapterDataWidgetState();
}

class _ChapterDataWidgetState extends State<ChapterDataWidget> with RouteAware {
  late ChapterDataModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageFlipKey = GlobalKey<PageFlipWidgetState>();
  final _tts = FlutterTts();
  int _currentPage = 0;
  int _pageCount = 1;
  List<List<_BibleVerse>> _pages = const [];
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChapterDataModel());
    _tts.setCompletionHandler(_onSpeechComplete);
    _configureVoice();
  }

  // Tunes the on-device TTS for a calmer, less robotic reading pace, and
  // picks the highest-quality voice available on this device (iOS reports
  // an Enhanced/Premium tier for voices the user has downloaded).
  Future<void> _configureVoice() async {
    try {
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);

      final voices = await _tts.getVoices;
      if (voices is! List) return;
      Map<String, String>? best;
      var bestIsEnhanced = false;
      for (final entry in voices) {
        if (entry is! Map) continue;
        final voice = entry.map((k, v) => MapEntry(k.toString(), v));
        final locale = (voice['locale'] ?? '').toString().toLowerCase();
        if (!locale.startsWith('en')) continue;
        final quality = (voice['quality'] ?? '').toString().toLowerCase();
        final isEnhanced =
            quality.contains('enhanced') || quality.contains('premium');
        if (best == null || (isEnhanced && !bestIsEnhanced)) {
          best = voice.map((k, v) => MapEntry(k, v.toString()));
          bestIsEnhanced = isEnhanced;
        }
      }
      if (best != null) {
        await _tts.setVoice(best);
      }
    } catch (_) {
      // TTS voice configuration is best-effort; fall back to platform
      // defaults if anything here isn't supported.
    }
  }

  String _pageText(List<_BibleVerse> page) =>
      page.map((verse) => verse.text).join(' ');

  Future<void> _togglePlay() async {
    if (_isSpeaking) {
      await _tts.stop();
      if (mounted) setState(() => _isSpeaking = false);
      return;
    }
    if (_pages.isEmpty || _currentPage >= _pages.length) return;
    setState(() => _isSpeaking = true);
    await _tts.speak(_pageText(_pages[_currentPage]));
  }

  void _handlePageFlipped(int page) {
    if (mounted) {
      setState(() => _currentPage = page);
    }
    if (_isSpeaking) {
      _tts.stop().then((_) {
        if (mounted && _isSpeaking && page < _pages.length) {
          _tts.speak(_pageText(_pages[page]));
        }
      });
    }
  }

  Future<void> _onSpeechComplete() async {
    if (!mounted || !_isSpeaking) return;
    final next = _currentPage + 1;
    if (next >= _pages.length) {
      setState(() => _isSpeaking = false);
      return;
    }
    // Triggers onPageFlipped -> _handlePageFlipped, which speaks the new page.
    await _pageFlipKey.currentState?.nextPage();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _tts.stop();

    _model.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(ChapterDataWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _model.widget = widget;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = DebugModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
    debugLogGlobalProperty(context);
  }

  @override
  void didPopNext() {
    if (mounted && DebugFlutterFlowModelContext.maybeOf(context) == null) {
      setState(() => _model.isRouteVisible = true);
      debugLogWidgetClass(_model);
    }
  }

  @override
  void didPush() {
    if (mounted && DebugFlutterFlowModelContext.maybeOf(context) == null) {
      setState(() => _model.isRouteVisible = true);
      debugLogWidgetClass(_model);
    }
  }

  @override
  void didPop() {
    _model.isRouteVisible = false;
  }

  @override
  void didPushNext() {
    _model.isRouteVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    DebugFlutterFlowModelContext.maybeOf(context)
        ?.parentModelCallback
        ?.call(_model);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBg = isDark ? const Color(0xFF181C24) : const Color(0xFFFAF3E6);
    final textColor =
        isDark ? const Color(0xFFEDEDED) : const Color(0xFF2B2A28);
    final numberColor =
        isDark ? const Color(0xFFD4AF37) : const Color(0xFFB8823A);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).secondaryText),
          automaticallyImplyLeading: true,
          title: Text(
            widget.title,
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: FutureBuilder<ApiCallResponse>(
            future: BibleAPIGroup.chapterDataCall.call(
              bibleID: widget.bibleid,
              chapterID: widget.chapterid,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                );
              }
              final columnChapterDataResponse = snapshot.data!;
              _model.debugBackendQueries[
                      'BibleAPIGroup.chapterDataCall_statusCode_Column_8357j9aq'] =
                  debugSerializeParam(
                columnChapterDataResponse.statusCode,
                ParamType.int,
                link:
                    'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=ChapterData',
                name: 'int',
                nullable: false,
              );
              _model.debugBackendQueries[
                      'BibleAPIGroup.chapterDataCall_responseBody_Column_8357j9aq'] =
                  debugSerializeParam(
                columnChapterDataResponse.bodyText,
                ParamType.String,
                link:
                    'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=ChapterData',
                name: 'String',
                nullable: false,
              );
              debugLogWidgetClass(_model);

              final content = BibleAPIGroup.chapterDataCall.content(
                columnChapterDataResponse.jsonBody,
              );
              final verses = _parseVerses(content ?? '');
              final pages = _paginate(verses);
              if (_pageCount != pages.length) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    _tts.stop();
                    setState(() {
                      _pageCount = pages.length;
                      _currentPage = 0;
                      _pages = pages;
                      _isSpeaking = false;
                    });
                  }
                });
              }

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: PageFlipWidget(
                      key: _pageFlipKey,
                      backgroundColor: pageBg,
                      onPageFlipped: _handlePageFlipped,
                      children: [
                        for (final page in pages)
                          _ChapterPage(
                            verses: page,
                            backgroundColor: pageBg,
                            textColor: textColor,
                            numberColor: numberColor,
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ListenButton(
                          isSpeaking: _isSpeaking,
                          onPressed: _togglePlay,
                        ),
                        const SizedBox(width: 12.0),
                        Text(
                          _isSpeaking
                              ? 'Reading page ${_currentPage + 1} of $_pageCount'
                              : 'Page ${_currentPage + 1} of $_pageCount · swipe to flip',
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChapterPage extends StatelessWidget {
  const _ChapterPage({
    required this.verses,
    required this.backgroundColor,
    required this.textColor,
    required this.numberColor,
  });

  final List<_BibleVerse> verses;
  final Color backgroundColor;
  final Color textColor;
  final Color numberColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: SingleChildScrollView(
        child: RichText(
          text: TextSpan(
            children: [
              for (final verse in verses) ...[
                TextSpan(
                  text: '${verse.number} ',
                  style: GoogleFonts.notoSerif(
                    color: numberColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: '${verse.text} ',
                  style: GoogleFonts.notoSerif(
                    color: textColor,
                    fontSize: 17.0,
                    height: 1.65,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ListenButton extends StatelessWidget {
  const _ListenButton({
    required this.isSpeaking,
    required this.onPressed,
  });

  final bool isSpeaking;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFB87A3D);
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accent.withValues(alpha: isSpeaking ? 0.22 : 0.14),
            border: Border.all(
              color: accent.withValues(alpha: isSpeaking ? 0.55 : 0.35),
              width: 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: Icon(
              isSpeaking ? Icons.pause_rounded : Icons.volume_up_rounded,
              key: ValueKey(isSpeaking),
              color: accent,
              size: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
