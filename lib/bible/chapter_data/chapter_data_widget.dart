import '/backend/api_requests/api_calls.dart';
import '/bible/ai_chat/ai_chat_widget.dart';
import '/bible/verse_compare/verse_compare_widget.dart';
import '/bible/verse_search/verse_search_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/main.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chapter_data_model.dart';
export 'chapter_data_model.dart';

const _kContinueReadingPrefsKey = 'bible_continue_reading';
const _kReadingPrefsKey = 'bible_reading_prefs';
const _kVerseHighlightsPrefsKey = 'bible_verse_highlights';
const _kVerseFavoritesPrefsKey = 'bible_verse_favorites_v2';

// Highlighter palette offered in the verse-action sheet, closest in intent
// (not exact colors) to YouVersion's marker set.
const _kHighlightColors = [
  Color(0xFFEF9A9A), // red
  Color(0xFFFFCC80), // orange
  Color(0xFFFFF59D), // yellow
  Color(0xFFA5D6A7), // green
  Color(0xFF90CAF9), // blue
  Color(0xFFCE93D8), // purple
];

class _ReadingTheme {
  const _ReadingTheme(this.key, this.label, this.background, this.text,
      this.numberAccent, this.heading);
  final String key;
  final String label;
  final Color background;
  final Color text;
  final Color numberAccent;
  final Color heading;
}

// 'system' isn't a real swatch — it means "follow the app's light/dark
// setting", which is the default until the reader picks one explicitly.
const _kReadingThemes = [
  _ReadingTheme('white', 'White', Color(0xFFFFFFFF), Color(0xFF1A1A1A),
      Color(0xFFB8823A), Color(0xFF6B6B6B)),
  _ReadingTheme('rose', 'Rose', Color(0xFFF6E9EA), Color(0xFF2B2A28),
      Color(0xFFB8823A), Color(0xFF7A6B6C)),
  _ReadingTheme('gray', 'Gray', Color(0xFFE7E7E7), Color(0xFF2B2A28),
      Color(0xFFB8823A), Color(0xFF6B6B6B)),
  _ReadingTheme('cream', 'Cream', Color(0xFFFBE9D0), Color(0xFF2B2A28),
      Color(0xFFB8823A), Color(0xFF7A6E5C)),
  _ReadingTheme('charcoal', 'Charcoal', Color(0xFF1E2430), Color(0xFFEDEDED),
      Color(0xFFD4AF37), Color(0xFF9AA0AC)),
  _ReadingTheme('navy', 'Navy', Color(0xFF15202B), Color(0xFFEDEDED),
      Color(0xFFD4AF37), Color(0xFF8DA0B3)),
  _ReadingTheme('black', 'Black', Color(0xFF000000), Color(0xFFEDEDED),
      Color(0xFFD4AF37), Color(0xFF9A9A9A)),
];

class _ReadingFont {
  const _ReadingFont(this.key, this.label, this.googleFontFamily);
  final String key;
  final String label;
  // Passed straight to GoogleFonts.getFont; null means the platform default
  // (no google_fonts lookup).
  final String? googleFontFamily;
}

const _kReadingFonts = [
  _ReadingFont('notoSerif', 'Untitled Serif', 'Noto Serif'),
  _ReadingFont('merriweather', 'Merriweather', 'Merriweather'),
  _ReadingFont('lora', 'Lora', 'Lora'),
  _ReadingFont('playfair', 'Playfair Display', 'Playfair Display'),
  _ReadingFont('robotoSlab', 'Roboto Slab', 'Roboto Slab'),
  _ReadingFont('inter', 'Inter', 'Inter'),
  _ReadingFont('openSans', 'Open Sans', 'Open Sans'),
  _ReadingFont('lato', 'Lato', 'Lato'),
];

const _kFontScaleSteps = [0.85, 1.0, 1.15, 1.3, 1.45];
const _kLineHeightSteps = [1.4, 1.6, 1.9];

TextStyle _readingTextStyle(
  String fontKey, {
  required Color color,
  required double fontSize,
  FontWeight? fontWeight,
  double? height,
  FontStyle? fontStyle,
}) {
  final font = _kReadingFonts.firstWhere(
    (f) => f.key == fontKey,
    orElse: () => _kReadingFonts.first,
  );
  return GoogleFonts.getFont(
    font.googleFontFamily ?? 'Noto Serif',
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    fontStyle: fontStyle,
  );
}

// Section headings (e.g. "The Creation") kept as standalone lines above the
// verses they introduce, rather than folded into verse 1's text.
const _kHeadingClasses = {
  's', 's1', 's2', 's3', 's4', //
  'ms', 'ms1', 'ms2', 'ms3',
  'mt', 'mt1', 'mt2', 'mt3',
};

// Chapter/cross-reference/description markup that isn't part of the verse
// text itself (chapter's big number, references, etc).
const _kSkipClasses = {
  'c',
  'cl',
  'ca',
  'cd',
  'r',
  'rq',
  'sp',
  'qs',
  'sr',
  'mr',
};

class _BibleVerse {
  const _BibleVerse(this.number, this.text);
  final String number;
  final String text;
}

/// Turns the chapter's raw scripture HTML into a flat list of
/// [_BibleVerse]s (with the occasional `String` section heading), so the
/// UI can lay verses out one-per-line with their number instead of as one
/// continuous paragraph.
List<Object> _parseChapterContent(String htmlContent) {
  final document = html_parser.parse(htmlContent.replaceAll(r'\', ''));
  final root = document.body ?? document.documentElement;
  final items = <Object>[];
  String? currentNumber;
  final buffer = StringBuffer();

  void flush() {
    if (currentNumber != null) {
      final text = buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
      if (text.isNotEmpty) {
        items.add(_BibleVerse(currentNumber!, text));
      }
    }
    buffer.clear();
  }

  void visit(dom.Node node) {
    if (node is dom.Element) {
      final classes = node.classes;
      if (classes.contains('v') || classes.contains('vp')) {
        flush();
        currentNumber = node.text.trim();
        return;
      }
      if (classes.any(_kHeadingClasses.contains)) {
        flush();
        currentNumber = null;
        final headingText = node.text.replaceAll(RegExp(r'\s+'), ' ').trim();
        if (headingText.isNotEmpty) items.add(headingText);
        return;
      }
      if (classes.any(_kSkipClasses.contains)) {
        return;
      }
      for (final child in node.nodes) {
        visit(child);
      }
    } else if (node is dom.Text) {
      if (currentNumber != null) {
        buffer
          ..write(node.text)
          ..write(' ');
      }
    }
  }

  if (root != null) {
    for (final node in root.nodes) {
      visit(node);
    }
  }
  flush();
  return items;
}

/// One chapter's worth of verse content. Fetches its own data exactly once
/// (in [initState]) so that swiping back and forth between pages a
/// [PageView] has already built doesn't re-hit the network.
class _ChapterPage extends StatefulWidget {
  const _ChapterPage({
    required this.bibleId,
    required this.chapterId,
    required this.reference,
    required this.fontKey,
    required this.fontSizeScale,
    required this.lineHeight,
    required this.numberColor,
    required this.textColor,
    required this.headingColor,
    this.onContentReady,
    this.onVerseTap,
    this.highlightColorFor,
  });

  final String? bibleId;
  final String? chapterId;
  final String reference;
  final String fontKey;
  final double fontSizeScale;
  final double lineHeight;
  final Color numberColor;
  final Color textColor;
  final Color headingColor;
  final void Function(String chapterId, String plainText)? onContentReady;
  final void Function(_BibleVerse verse, String reference, String chapterId)?
      onVerseTap;
  final Color? Function(String verseNumber)? highlightColorFor;

  @override
  State<_ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<_ChapterPage> {
  late final Future<ApiCallResponse> _future;
  bool _notifiedContentReady = false;

  @override
  void initState() {
    super.initState();
    _future = BibleAPIGroup.chapterDataCall.call(
      bibleID: widget.bibleId,
      chapterID: widget.chapterId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiCallResponse>(
      future: _future,
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
        final response = snapshot.data!;
        final rawContent =
            BibleAPIGroup.chapterDataCall.content(response.jsonBody) ?? '';
        final items = _parseChapterContent(rawContent);

        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                rawContent.isEmpty
                    ? 'Couldn\'t load this chapter (empty response, status '
                        '${response.statusCode}). Pull to retry or pick '
                        'another chapter.'
                    : 'Couldn\'t parse this chapter\'s verses.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: widget.headingColor),
              ),
            ),
          );
        }

        if (!_notifiedContentReady) {
          _notifiedContentReady = true;
          final plainText =
              items.whereType<_BibleVerse>().map((v) => v.text).join(' ');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onContentReady?.call(widget.chapterId ?? '', plainText);
          });
        }

        return ListView.builder(
          // The floating chevron/play row (and, once scrolled to the end,
          // the app-wide tab bar beneath it) are overlays on top of this
          // full-screen content (see extendBody on the Scaffold), not
          // something that reserves layout space — so without enough
          // bottom padding here the last few verses stay hidden behind
          // them even at full scroll, the same issue Home's card grid had.
          padding: const EdgeInsets.only(top: 16.0, bottom: 140.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            if (item is String) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
                child: Text(
                  item,
                  textAlign: TextAlign.center,
                  style: _readingTextStyle(
                    widget.fontKey,
                    color: widget.headingColor,
                    fontSize: 15.0 * widget.fontSizeScale,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }
            final verse = item as _BibleVerse;
            final highlightColor = widget.highlightColorFor?.call(verse.number);
            // A highlighted verse keeps its own dark text regardless of the
            // active reading theme, since the marker colors are pastel and
            // assume dark-on-light text (matching how a real highlighter
            // pen reads).
            final verseTextColor = highlightColor != null
                ? const Color(0xFF1A1A1A)
                : widget.textColor;
            final numberTextColor = highlightColor != null
                ? const Color(0xFF1A1A1A)
                : widget.numberColor;
            return InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => widget.onVerseTap
                  ?.call(verse, widget.reference, widget.chapterId ?? ''),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  width: double.infinity,
                  padding: highlightColor != null
                      ? const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 2.0)
                      : EdgeInsets.zero,
                  decoration: highlightColor != null
                      ? BoxDecoration(
                          color: highlightColor,
                          borderRadius: BorderRadius.circular(4.0),
                        )
                      : null,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${verse.number}  ',
                          style: GoogleFonts.inter(
                            color: numberTextColor,
                            fontSize: 13.0 * widget.fontSizeScale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: verse.text,
                          style: _readingTextStyle(
                            widget.fontKey,
                            color: verseTextColor,
                            fontSize: 17.0 * widget.fontSizeScale,
                            height: widget.lineHeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChapterDataWidget extends StatefulWidget {
  const ChapterDataWidget({
    super.key,
    String? title,
    required this.bibleid,
    required this.chapterid,
    this.version,
  }) : title = title ?? 'Books';

  final String title;
  final String? bibleid;
  final String? chapterid;
  final String? version;

  static String routeName = 'ChapterData';
  static String routePath = '/Chapter';

  @override
  State<ChapterDataWidget> createState() => _ChapterDataWidgetState();
}

class _ChapterDataWidgetState extends State<ChapterDataWidget> with RouteAware {
  late ChapterDataModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Swipe-to-navigate state. The ordered chapter list for the current book
  // (fetched once) is what a PageView pages through, so a horizontal drag
  // follows the reader's finger exactly like a native Bible app instead of
  // jumping on a velocity threshold.
  late String _currentTitle;
  late String _currentChapterId;
  int _currentPageIndex = 0;
  List<dynamic>? _bookChapters;
  PageController? _pageController;

  // Read-aloud. Keyed by chapter id so switching pages doesn't require
  // re-parsing content just to know what to speak.
  final FlutterTts _tts = FlutterTts();
  final Map<String, String> _chapterPlainText = {};
  bool _isSpeaking = false;

  // Reading appearance. 'system' theme means "follow the app's light/dark
  // setting" (the pre-existing look) until the reader picks a swatch.
  String _fontKey = _kReadingFonts.first.key;
  double _fontSizeScale = 1.0;
  double _lineHeight = _kLineHeightSteps[1];
  String _themeKey = 'system';

  // Verse highlighting + favorites, keyed by "<chapterId>:<verseNumber>"
  // (e.g. "JHN.3:16") so marks survive across app restarts and don't clash
  // between chapters.
  Map<String, int> _verseHighlights = {};
  // Keyed by "<chapterId>:<verseNumber>". Stores enough to render the Home
  // screen's Saved Verses list without re-fetching (bibleId/version so a
  // "Go to verse" action can jump back to the right translation, plus the
  // verse text itself so the list has something to show immediately).
  Map<String, Map<String, dynamic>> _verseFavorites = {};

  // The app-wide Home/Search/Feed/Messages/Profile tab bar, rendered here
  // too (this screen is a full-screen route pushed on top of NavBarPage,
  // so that bar otherwise wouldn't exist on this screen at all). Hidden by
  // default — only appears once the reader has scrolled to the very end of
  // the chapter's verses.
  bool _tabBarVisible = false;

  static const _kTabBarNames = [
    'Home',
    'Search',
    'PublicFeed',
    'MyMessages',
    'Profile',
  ];

  bool _handleTabBarScrollNotification(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis != Axis.vertical) return false;

    final atBottom = metrics.pixels >= metrics.maxScrollExtent - 4.0;
    if (atBottom != _tabBarVisible) {
      setState(() => _tabBarVisible = atBottom);
    }
    return false;
  }

  void _selectAppTab(int index) {
    NavBarPage.requestedTab.value = _kTabBarNames[index];
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  bool get _canGoPrev => _currentPageIndex > 0;
  bool get _canGoNext =>
      _bookChapters != null && _currentPageIndex < _bookChapters!.length - 1;

  Future<void> _loadReadingPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kReadingPrefsKey);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        _fontKey = decoded['fontKey']?.toString() ?? _fontKey;
        _fontSizeScale =
            (decoded['fontSizeScale'] as num?)?.toDouble() ?? _fontSizeScale;
        _lineHeight =
            (decoded['lineHeight'] as num?)?.toDouble() ?? _lineHeight;
        _themeKey = decoded['themeKey']?.toString() ?? _themeKey;
      });
    } catch (_) {
      // Ignore a corrupted entry and keep defaults.
    }
  }

  Future<void> _saveReadingPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kReadingPrefsKey,
      jsonEncode({
        'fontKey': _fontKey,
        'fontSizeScale': _fontSizeScale,
        'lineHeight': _lineHeight,
        'themeKey': _themeKey,
      }),
    );
  }

  Future<void> _loadVerseMarks() async {
    final prefs = await SharedPreferences.getInstance();
    final highlightsRaw = prefs.getString(_kVerseHighlightsPrefsKey);
    final favoritesRaw = prefs.getString(_kVerseFavoritesPrefsKey);
    if (highlightsRaw == null && favoritesRaw == null) return;
    try {
      if (!mounted) return;
      setState(() {
        if (highlightsRaw != null) {
          final decoded = jsonDecode(highlightsRaw) as Map<String, dynamic>;
          _verseHighlights = decoded.map(
            (key, value) => MapEntry(key, (value as num).toInt()),
          );
        }
        if (favoritesRaw != null) {
          final decoded = jsonDecode(favoritesRaw) as Map<String, dynamic>;
          _verseFavorites = decoded.map(
            (key, value) => MapEntry(key, value as Map<String, dynamic>),
          );
        }
      });
    } catch (_) {
      // Ignore a corrupted entry and keep defaults.
    }
  }

  Future<void> _saveVerseHighlights() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kVerseHighlightsPrefsKey,
      jsonEncode(_verseHighlights),
    );
  }

  Future<void> _saveVerseFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kVerseFavoritesPrefsKey,
      jsonEncode(_verseFavorites),
    );
  }

  Color? _highlightColorFor(String chapterId, String verseNumber) {
    final value = _verseHighlights['$chapterId:$verseNumber'];
    return value == null ? null : Color(value);
  }

  void _setHighlight(String verseKey, Color? color) {
    setState(() {
      final current = _verseHighlights[verseKey];
      // Tapping the already-active color again clears the highlight,
      // matching how a real highlighter toggles off on a second tap.
      if (color != null && current == color.value) {
        _verseHighlights.remove(verseKey);
      } else if (color == null) {
        _verseHighlights.remove(verseKey);
      } else {
        _verseHighlights[verseKey] = color.value;
      }
    });
    _saveVerseHighlights();
  }

  bool _isFavorite(String verseKey) => _verseFavorites.containsKey(verseKey);

  void _toggleFavorite(
      String verseKey, _BibleVerse verse, String reference, String chapterId) {
    setState(() {
      if (_verseFavorites.containsKey(verseKey)) {
        _verseFavorites.remove(verseKey);
      } else {
        _verseFavorites[verseKey] = {
          'bibleId': widget.bibleid,
          'version': widget.version,
          'chapterId': chapterId,
          'verseNumber': verse.number,
          'reference': reference,
          'text': verse.text,
          'savedAt': DateTime.now().millisecondsSinceEpoch,
        };
      }
    });
    _saveVerseFavorites();
  }

  _ReadingTheme? get _selectedTheme {
    if (_themeKey == 'system') return null;
    for (final theme in _kReadingThemes) {
      if (theme.key == _themeKey) return theme;
    }
    return null;
  }

  Future<void> _togglePlayback() async {
    if (_isSpeaking) {
      await _tts.stop();
      if (mounted) setState(() => _isSpeaking = false);
      return;
    }
    final text = _chapterPlainText[_currentChapterId];
    if (text == null || text.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() => _isSpeaking = true);
    await _tts.speak(text);
  }

  void _goToPreviousChapter() {
    _pageController?.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextChapter() {
    _pageController?.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _changeVersion() {
    context.pushNamed(BiblesWidget.routeName);
  }

  void _openBooksAtCurrent() {
    final parts = _currentChapterId.split('.');
    final bookId = parts.isNotEmpty ? parts.first : '';
    final chapterNumber = parts.length > 1 ? parts.sublist(1).join('.') : '';
    context.pushNamed(
      BooksWidget.routeName,
      queryParameters: {
        'bibleid': serializeParam(widget.bibleid, ParamType.String),
        'version': serializeParam(widget.version, ParamType.String),
        'initialBookId': serializeParam(bookId, ParamType.String),
        'initialChapterNumber': serializeParam(
          chapterNumber,
          ParamType.String,
        ),
      }.withoutNulls,
    );
  }

  void _openCompareSheet(
      _BibleVerse verse, String reference, String chapterId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: MediaQuery.viewInsetsOf(sheetContext),
        child: SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.75,
          child: _FloatingSheet(
            expand: true,
            child: VerseCompareWidget(
              chapterId: chapterId,
              verseNumber: verse.number,
              reference: reference,
              currentBibleId: widget.bibleid,
              currentVersionAbbrev: widget.version,
            ),
          ),
        ),
      ),
    );
  }

  void _askAIGenericAboutVerse(_BibleVerse verse, String reference) {
    _openAIResponseSheet(
      'Explain the meaning and context of $reference:${verse.number} '
      '("${verse.text}").',
    );
  }

  void _askAIAboutSearchQuery(String query) {
    _openAIResponseSheet(
      '$query — explain from a biblical perspective, referencing '
      'relevant verses.',
    );
  }

  void _openAIResponseSheet(String question) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // AIChatWidget (unlike the shared, single-shot AIResponseWidget used
      // elsewhere in the app, e.g. Home) supports real follow-up chat, so it
      // gets the same floating-sheet chrome as Search/Compare.
      builder: (sheetContext) => Padding(
        padding: MediaQuery.viewInsetsOf(sheetContext),
        child: SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.85,
          child: _FloatingSheet(
            expand: true,
            child: AIChatWidget(initialQuestion: question),
          ),
        ),
      ),
    );
  }

  void _copyVerse(_BibleVerse verse, String reference) {
    Clipboard.setData(
      ClipboardData(text: '$reference:${verse.number} — ${verse.text}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verse copied')),
    );
  }

  void _shareVerse(_BibleVerse verse, String reference, [Rect? origin]) {
    // iOS's UIActivityViewController (which share_plus drives) needs an
    // anchor rect to position the popover from — without one it throws a
    // PlatformException instead of presenting the sheet. Fall back to a
    // point near the bottom-center of the screen if no anchor was captured.
    final sharePositionOrigin = origin ??
        (Offset(
              MediaQuery.sizeOf(context).width / 2,
              MediaQuery.sizeOf(context).height,
            ) &
            const Size(1, 1));
    Share.share(
      '$reference:${verse.number} — ${verse.text}',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  void _showVerseActions(
      _BibleVerse verse, String reference, String chapterId) {
    HapticFeedback.lightImpact();
    final verseKey = '$chapterId:${verse.number}';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
            final textColor = isDark
                ? Colors.white
                : FlutterFlowTheme.of(sheetContext).primaryText;
            final secondaryTextColor = isDark
                ? const Color(0xFF9A9AA2)
                : FlutterFlowTheme.of(sheetContext).secondaryText;
            final currentHighlight = _verseHighlights[verseKey];
            final isFavorite = _isFavorite(verseKey);
            final shareButtonKey = GlobalKey();

            return _FloatingSheet(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$reference:${verse.number}',
                    style: GoogleFonts.interTight(
                      color: textColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  SizedBox(
                    height: 40.0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _VerseHighlightSwatch(
                            color: null,
                            isSelected: currentHighlight == null,
                            onTap: () {
                              _setHighlight(verseKey, null);
                              setSheetState(() {});
                            },
                          ),
                          const SizedBox(width: 10.0),
                          for (final color in _kHighlightColors) ...[
                            _VerseHighlightSwatch(
                              color: color,
                              isSelected: currentHighlight == color.value,
                              onTap: () {
                                _setHighlight(verseKey, color);
                                setSheetState(() {});
                              },
                            ),
                            const SizedBox(width: 10.0),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _VerseActionButton(
                        icon: isFavorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        iconColor:
                            isFavorite ? const Color(0xFFD4AF37) : textColor,
                        label: 'Favorites',
                        labelColor: secondaryTextColor,
                        onTap: () {
                          _toggleFavorite(
                              verseKey, verse, reference, chapterId);
                          setSheetState(() {});
                        },
                      ),
                      _VerseActionButton(
                        icon: Icons.copy_rounded,
                        iconColor: textColor,
                        label: 'Copy',
                        labelColor: secondaryTextColor,
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _copyVerse(verse, reference);
                        },
                      ),
                      _VerseActionButton(
                        key: shareButtonKey,
                        icon: Icons.ios_share_rounded,
                        iconColor: textColor,
                        label: 'Share',
                        labelColor: secondaryTextColor,
                        onTap: () {
                          // Capture the button's on-screen rect *before*
                          // popping the sheet — the render tree it lives in
                          // is torn down once the sheet starts closing.
                          Rect? origin;
                          final renderObject =
                              shareButtonKey.currentContext?.findRenderObject();
                          if (renderObject is RenderBox &&
                              renderObject.hasSize) {
                            origin = renderObject.localToGlobal(Offset.zero) &
                                renderObject.size;
                          }
                          Navigator.pop(sheetContext);
                          _shareVerse(verse, reference, origin);
                        },
                      ),
                      _VerseActionButton(
                        icon: Icons.compare_arrows_rounded,
                        iconColor: textColor,
                        label: 'Compare',
                        labelColor: secondaryTextColor,
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _openCompareSheet(verse, reference, chapterId);
                        },
                      ),
                      _VerseActionButton(
                        icon: Icons.auto_awesome_rounded,
                        iconColor: textColor,
                        label: 'Ask',
                        labelColor: secondaryTextColor,
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _askAIGenericAboutVerse(verse, reference);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: MediaQuery.viewInsetsOf(sheetContext),
        child: SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.85,
          child: _FloatingSheet(
            expand: true,
            child: VerseSearchWidget(
              bibleId: widget.bibleid,
              version: widget.version,
              onAskAi: _askAIAboutSearchQuery,
            ),
          ),
        ),
      ),
    );
  }

  void _openFontsAndSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _FontsAndSettingsSheet(
        fontKey: _fontKey,
        fontSizeScale: _fontSizeScale,
        lineHeight: _lineHeight,
        themeKey: _themeKey,
        onChanged: ({fontKey, fontSizeScale, lineHeight, themeKey}) {
          setState(() {
            if (fontKey != null) _fontKey = fontKey;
            if (fontSizeScale != null) _fontSizeScale = fontSizeScale;
            if (lineHeight != null) _lineHeight = lineHeight;
            if (themeKey != null) _themeKey = themeKey;
          });
          _saveReadingPrefs();
        },
      ),
    );
  }

  Future<void> _loadBookChapters() async {
    final chapterId = widget.chapterid ?? '';
    final bookId = chapterId.contains('.') ? chapterId.split('.').first : '';
    if (bookId.isEmpty) return;
    final response = await BibleAPIGroup.chapterCall.call(
      bibleID: widget.bibleid,
      bookID: bookId,
    );
    final chapters = BibleAPIGroup.chapterCall.data(response.jsonBody) ?? [];
    if (!mounted) return;
    final index = chapters.indexWhere(
      (c) => getJsonField(c, r'''$.id''').toString() == chapterId,
    );
    setState(() {
      _bookChapters = chapters;
      if (index != -1) {
        _currentPageIndex = index;
        _pageController = PageController(initialPage: index);
      }
    });
  }

  Future<void> _saveContinueReading({
    required String chapterId,
    required String reference,
  }) async {
    final parts = chapterId.split('.');
    final bookId = parts.isNotEmpty ? parts.first : '';
    final chapterNumber = parts.length > 1 ? parts.sublist(1).join('.') : '';
    if (bookId.isEmpty || chapterNumber == 'intro') return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kContinueReadingPrefsKey,
      jsonEncode({
        'bibleId': widget.bibleid,
        'chapterId': chapterId,
        'bookId': bookId,
        'chapterNumber': chapterNumber,
        'reference': reference,
        'version': widget.version,
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChapterDataModel());
    _currentTitle = widget.title;
    _currentChapterId = widget.chapterid ?? '';
    _saveContinueReading(
      chapterId: widget.chapterid ?? '',
      reference: widget.title,
    );
    _loadBookChapters();
    _loadReadingPrefs();
    _loadVerseMarks();

    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
    _tts.setCancelHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
    _tts.setErrorHandler((msg) {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _tts.stop();
    _pageController?.dispose();
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

    final chapters = _bookChapters;
    final pageController = _pageController;
    final isDarkHeader = Theme.of(context).brightness == Brightness.dark;

    final selectedTheme = _selectedTheme;
    final bodyBg = selectedTheme?.background ??
        FlutterFlowTheme.of(context).primaryBackground;
    final numberColor = selectedTheme?.numberAccent ??
        (isDarkHeader ? const Color(0xFFD4AF37) : const Color(0xFFB8823A));
    final textColor = selectedTheme?.text ??
        (isDarkHeader
            ? const Color(0xFFEDEDED)
            : FlutterFlowTheme.of(context).primaryText);
    final headingColor =
        selectedTheme?.heading ?? FlutterFlowTheme.of(context).secondaryText;
    // The header pill/icon colors follow the selected reading theme too, so
    // the whole screen (not just the verse paragraphs) recolors together.
    final pillTextColor = selectedTheme?.text ??
        (isDarkHeader
            ? Colors.white
            : FlutterFlowTheme.of(context).primaryText);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: bodyBg,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: bodyBg,
          iconTheme: IconThemeData(color: headingColor),
          automaticallyImplyLeading: true,
          titleSpacing: 0.0,
          centerTitle: false,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlassButton.custom(
                onTap: _openBooksAtCurrent,
                useOwnLayer: true,
                height: 40.0,
                shape: const LiquidRoundedRectangle(borderRadius: 20.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Text(
                    _currentTitle,
                    style: GoogleFonts.interTight(
                      color: pillTextColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6.0),
              GlassButton.custom(
                onTap: _changeVersion,
                useOwnLayer: true,
                height: 40.0,
                shape: const LiquidRoundedRectangle(borderRadius: 20.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Text(
                    (widget.version ?? '').isNotEmpty
                        ? widget.version!
                        : 'Version',
                    style: GoogleFonts.interTight(
                      color: pillTextColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              // AppBar's actions Row can stretch a bare action widget taller
              // than the height it declares for itself — GlassPullDownButton
              // avoids this because GlassMenu wraps its trigger in a Stack,
              // which only ever sizes to its child's natural size. Center
              // gives the same guarantee here: it always hands out loose
              // constraints downward, so GlassButton's own 40x40 SizedBox
              // wins instead of being force-stretched into an oval.
              child: Center(
                child: GlassButton(
                  icon: const Icon(Icons.search_rounded),
                  onTap: _openSearch,
                  label: 'Search',
                  width: 40.0,
                  height: 40.0,
                  iconSize: 20.0,
                  shape: const LiquidOval(),
                  quality: GlassQuality.premium,
                  useOwnLayer: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              // Same reasoning as the search button above: force loose
              // constraints down to the button so it can't be stretched or
              // shifted differently than its sibling action by the AppBar's
              // actions Row.
              child: Center(
                child: GlassPullDownButton(
                  buttonWidth: 40.0,
                  buttonHeight: 40.0,
                  quality: GlassQuality.premium,
                  semanticLabel: 'More options',
                  items: [
                    GlassMenuItem(
                      title: 'Fonts & Settings',
                      icon: const Icon(Icons.format_size_rounded),
                      onTap: _openFontsAndSettingsSheet,
                      titleStyle: GoogleFonts.inter(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          elevation: 0.0,
        ),
        body: Container(
          color: bodyBg,
          child: Stack(
            children: [
              SafeArea(
                top: true,
                bottom: false,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 0.0, 20.0, 0.0),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _handleTabBarScrollNotification,
                    child: chapters == null
                        ? Center(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          )
                        : pageController == null
                            // Couldn't locate this chapter in its own book's list
                            // (unexpected id format) — show it without paging rather
                            // than getting stuck.
                            ? _ChapterPage(
                                bibleId: widget.bibleid,
                                chapterId: widget.chapterid,
                                reference: widget.title,
                                fontKey: _fontKey,
                                fontSizeScale: _fontSizeScale,
                                lineHeight: _lineHeight,
                                numberColor: numberColor,
                                textColor: textColor,
                                headingColor: headingColor,
                                onContentReady: (chapterId, text) {
                                  _chapterPlainText[chapterId] = text;
                                },
                                onVerseTap: _showVerseActions,
                                highlightColorFor: (verseNumber) =>
                                    _highlightColorFor(
                                  widget.chapterid ?? '',
                                  verseNumber,
                                ),
                              )
                            : PageView.builder(
                                controller: pageController,
                                itemCount: chapters.length,
                                onPageChanged: (index) {
                                  final item = chapters[index];
                                  final id = getJsonField(item, r'''$.id''')
                                      .toString();
                                  final reference =
                                      getJsonField(item, r'''$.reference''')
                                          .toString();
                                  HapticFeedback.mediumImpact();
                                  _tts.stop();
                                  setState(() {
                                    _currentTitle = reference;
                                    _currentChapterId = id;
                                    _currentPageIndex = index;
                                    _isSpeaking = false;
                                  });
                                  _saveContinueReading(
                                      chapterId: id, reference: reference);
                                },
                                itemBuilder: (context, index) {
                                  final item = chapters[index];
                                  final id = getJsonField(item, r'''$.id''')
                                      .toString();
                                  final reference =
                                      getJsonField(item, r'''$.reference''')
                                          .toString();
                                  return _ChapterPage(
                                    bibleId: widget.bibleid,
                                    chapterId: id,
                                    reference: reference,
                                    fontKey: _fontKey,
                                    fontSizeScale: _fontSizeScale,
                                    lineHeight: _lineHeight,
                                    numberColor: numberColor,
                                    textColor: textColor,
                                    headingColor: headingColor,
                                    onContentReady: (chapterId, text) {
                                      _chapterPlainText[chapterId] = text;
                                    },
                                    onVerseTap: _showVerseActions,
                                    highlightColorFor: (verseNumber) =>
                                        _highlightColorFor(id, verseNumber),
                                  );
                                },
                              ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  // Matches GlassScaffold's own bottom-bar SafeArea exactly
                  // (see NavBarPage) — on iOS the glass tab bar already
                  // accounts for the home-indicator inset itself, so adding
                  // it again here would push it up out of position relative
                  // to how it sits on Home.
                  bottom: defaultTargetPlatform == TargetPlatform.android,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GlassIconButton(
                              icon: const Icon(Icons.chevron_left_rounded),
                              onPressed:
                                  _canGoPrev ? _goToPreviousChapter : null,
                              size: 48.0,
                              useOwnLayer: true,
                              semanticLabel: 'Previous chapter',
                            ),
                            const SizedBox(width: 20.0),
                            GlassButton(
                              icon: Icon(
                                _isSpeaking
                                    ? Icons.stop_rounded
                                    : Icons.play_arrow_rounded,
                              ),
                              onTap: _togglePlayback,
                              width: 60.0,
                              height: 60.0,
                              useOwnLayer: true,
                              style: GlassButtonStyle.prominent,
                              iconColor: Colors.white,
                              settings: LiquidGlassSettings(
                                glassColor: FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.6),
                                thickness: 40,
                                blur: 16.0,
                                lightIntensity: 0.6,
                                refractiveIndex: 1.3,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            GlassIconButton(
                              icon: const Icon(Icons.chevron_right_rounded),
                              onPressed: _canGoNext ? _goToNextChapter : null,
                              size: 48.0,
                              useOwnLayer: true,
                              semanticLabel: 'Next chapter',
                            ),
                          ],
                        ),
                      ),
                      ClipRect(
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          alignment: Alignment.topCenter,
                          child: !_tabBarVisible
                              ? const SizedBox(width: double.infinity)
                              : Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: GlassTabBar.bottom(
                                    selectedIndex: 0,
                                    onTabSelected: _selectAppTab,
                                    tabs: const [
                                      GlassTab(
                                        icon: FaIcon(FontAwesomeIcons.home,
                                            size: 24.0),
                                        semanticLabel: 'Home',
                                      ),
                                      GlassTab(
                                        icon: FaIcon(FontAwesomeIcons.search,
                                            size: 24.0),
                                        semanticLabel: 'Search',
                                      ),
                                      GlassTab(
                                        icon: FaIcon(FontAwesomeIcons.stream,
                                            size: 24.0),
                                        semanticLabel: 'Feed',
                                      ),
                                      GlassTab(
                                        icon: FaIcon(FontAwesomeIcons.comment,
                                            size: 24.0),
                                        semanticLabel: 'Messages',
                                      ),
                                      GlassTab(
                                        icon: Icon(Icons.person_rounded,
                                            size: 28.0),
                                        semanticLabel: 'Profile',
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The "Fonts & Settings" bottom sheet: font size, line spacing, font
/// family, and a reading-theme (background color) picker. Each control
/// reports its change up immediately via [onChanged] so the chapter behind
/// it updates live while the sheet is open.
class _FontsAndSettingsSheet extends StatefulWidget {
  const _FontsAndSettingsSheet({
    required this.fontKey,
    required this.fontSizeScale,
    required this.lineHeight,
    required this.themeKey,
    required this.onChanged,
  });

  final String fontKey;
  final double fontSizeScale;
  final double lineHeight;
  final String themeKey;
  final void Function({
    String? fontKey,
    double? fontSizeScale,
    double? lineHeight,
    String? themeKey,
  }) onChanged;

  @override
  State<_FontsAndSettingsSheet> createState() => _FontsAndSettingsSheetState();
}

class _FontsAndSettingsSheetState extends State<_FontsAndSettingsSheet> {
  late String _fontKey = widget.fontKey;
  late double _fontSizeScale = widget.fontSizeScale;
  late double _lineHeight = widget.lineHeight;
  late String _themeKey = widget.themeKey;

  void _bumpFontSize(int delta) {
    const steps = _kFontScaleSteps;
    final current = steps.indexWhere((s) => (s - _fontSizeScale).abs() < 0.01);
    final next =
        ((current == -1 ? 1 : current) + delta).clamp(0, steps.length - 1);
    setState(() => _fontSizeScale = steps[next]);
    widget.onChanged(fontSizeScale: _fontSizeScale);
  }

  void _cycleLineHeight() {
    const steps = _kLineHeightSteps;
    final current = steps.indexWhere((s) => (s - _lineHeight).abs() < 0.01);
    final next = ((current == -1 ? 0 : current) + 1) % steps.length;
    setState(() => _lineHeight = steps[next]);
    widget.onChanged(lineHeight: _lineHeight);
  }

  void _selectTheme(String key) {
    setState(() => _themeKey = key);
    widget.onChanged(themeKey: key);
  }

  Future<void> _pickFont() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FontPickerSheet(selectedKey: _fontKey),
    );
    if (selected != null) {
      setState(() => _fontKey = selected);
      widget.onChanged(fontKey: selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1C1C1F) : Colors.white;
    final textColor =
        isDark ? Colors.white : FlutterFlowTheme.of(context).primaryText;
    final secondaryTextColor = isDark
        ? const Color(0xFF9A9AA2)
        : FlutterFlowTheme.of(context).secondaryText;
    final tileBg = isDark ? const Color(0xFF29292E) : const Color(0xFFF0F0F0);
    final selectedFont = _kReadingFonts.firstWhere(
      (f) => f.key == _fontKey,
      orElse: () => _kReadingFonts.first,
    );

    Widget toggleBox({required Widget child, required VoidCallback onTap}) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            height: 52.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tileBg,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: child,
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.0,
                height: 4.0,
                margin: const EdgeInsets.only(bottom: 18.0),
                decoration: BoxDecoration(
                  color: secondaryTextColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            Row(
              children: [
                toggleBox(
                  onTap: () => _bumpFontSize(-1),
                  child: Text('A',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: textColor,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 10.0),
                toggleBox(
                  onTap: () => _bumpFontSize(1),
                  child: Text('A',
                      style: TextStyle(
                          fontSize: 26.0,
                          color: textColor,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 10.0),
                toggleBox(
                  onTap: _cycleLineHeight,
                  child:
                      Icon(Icons.format_line_spacing_rounded, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 14.0),
            InkWell(
              onTap: _pickFont,
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: secondaryTextColor.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Font',
                              style: GoogleFonts.inter(
                                  fontSize: 12.0, color: secondaryTextColor)),
                          const SizedBox(height: 2.0),
                          Text(
                            selectedFont.label,
                            style: GoogleFonts.getFont(
                              selectedFont.googleFontFamily ?? 'Noto Serif',
                              fontSize: 17.0,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        color: secondaryTextColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 84.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _kReadingThemes.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 10.0),
                itemBuilder: (context, index) {
                  final isSystem = index == 0;
                  final theme = isSystem ? null : _kReadingThemes[index - 1];
                  final key = isSystem ? 'system' : theme!.key;
                  final isSelected = _themeKey == key;
                  final swatchBg = theme?.background ??
                      FlutterFlowTheme.of(context).primaryBackground;
                  final swatchLine =
                      theme?.text ?? FlutterFlowTheme.of(context).primaryText;
                  final swatchAccent = theme?.numberAccent ??
                      FlutterFlowTheme.of(context).primary;

                  return InkWell(
                    onTap: () => _selectTheme(key),
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      width: 58.0,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: swatchBg,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: isSelected
                              ? FlutterFlowTheme.of(context).primary
                              : Colors.black12,
                          width: isSelected ? 2.0 : 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSystem)
                            Expanded(
                              child: Icon(Icons.brightness_6_rounded,
                                  color: swatchLine, size: 20.0),
                            )
                          else
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var i = 0; i < 3; i++)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Container(
                                        height: 3.0,
                                        width: double.infinity,
                                        color:
                                            swatchLine.withValues(alpha: 0.75),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 6.0),
                          Container(
                            width: 12.0,
                            height: 12.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? swatchAccent
                                  : Colors.transparent,
                              border: Border.all(
                                  color: swatchLine.withValues(alpha: 0.5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The "Bible Reading Fonts" full list, pushed from the Font row above.
/// Pops with the chosen font's key, or null if dismissed.
class _FontPickerSheet extends StatelessWidget {
  const _FontPickerSheet({required this.selectedKey});

  final String selectedKey;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1C1C1F) : Colors.white;
    final textColor =
        isDark ? Colors.white : FlutterFlowTheme.of(context).primaryText;
    final secondaryTextColor = isDark
        ? const Color(0xFF9A9AA2)
        : FlutterFlowTheme.of(context).secondaryText;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.75,
        ),
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 12.0, 16.0, 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        size: 18.0, color: textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Bible Reading Fonts',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.interTight(
                        color: textColor,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40.0),
                ],
              ),
            ),
            Divider(
                height: 1.0, color: secondaryTextColor.withValues(alpha: 0.2)),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: _kReadingFonts.length,
                itemBuilder: (context, index) {
                  final font = _kReadingFonts[index];
                  final isSelected = font.key == selectedKey;
                  return InkWell(
                    onTap: () => Navigator.pop(context, font.key),
                    child: Container(
                      color: isSelected
                          ? (isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.05))
                          : Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 14.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              font.label,
                              style: GoogleFonts.getFont(
                                font.googleFontFamily ?? 'Noto Serif',
                                fontSize: 18.0,
                                color: textColor,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_rounded, color: textColor),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One tappable color circle in the verse-action sheet's highlighter row,
/// rendered as a real liquid-glass surface (tinted by [color]) to match the
/// rest of the Bible feature's glass chrome. `color == null` renders the "no
/// highlight" (clear) option. Uses [GlassQuality.standard] rather than
/// premium — a sheet full of these plus the header/bottom-bar glass already
/// mounted behind it is enough surfaces to trip the package's raster-budget
/// warning at premium quality.
class _VerseHighlightSwatch extends StatelessWidget {
  const _VerseHighlightSwatch({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ringColor =
        isDark ? Colors.white : FlutterFlowTheme.of(context).primaryText;

    return Container(
      width: 40.0,
      height: 40.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : Colors.transparent,
          width: 2.5,
        ),
      ),
      child: GlassButton.custom(
        onTap: onTap,
        width: 32.0,
        height: 32.0,
        useOwnLayer: true,
        quality: GlassQuality.standard,
        shape: const LiquidOval(),
        settings: LiquidGlassSettings(
          glassColor: (color ?? ringColor).withValues(
            alpha: color != null ? 0.85 : 0.12,
          ),
          thickness: 20,
          blur: 8.0,
          lightIntensity: 0.5,
          refractiveIndex: 1.2,
        ),
        child: color == null
            ? Icon(Icons.not_interested_rounded,
                size: 14.0, color: ringColor.withValues(alpha: 0.7))
            : const SizedBox.shrink(),
      ),
    );
  }
}

/// One icon+label action in the verse-action sheet (Favorites, Copy, Share,
/// Compare, Ask) — a glass tile matching the header pills / floating
/// prev-next-play buttons elsewhere in the Bible feature.
class _VerseActionButton extends StatelessWidget {
  const _VerseActionButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.labelColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassButton(
          icon: Icon(icon),
          onTap: onTap,
          width: 52.0,
          height: 52.0,
          iconSize: 22.0,
          iconColor: iconColor,
          shape: const LiquidRoundedRectangle(borderRadius: 16.0),
          quality: GlassQuality.standard,
          useOwnLayer: true,
        ),
        const SizedBox(height: 6.0),
        Text(
          label,
          style: GoogleFonts.inter(
            color: labelColor,
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Shared chrome for every Bible-feature bottom sheet: a floating,
/// all-corners-rounded panel with a drag handle, matching the Fonts &
/// Settings sheet's look rather than Flutter's default edge-to-edge sheet.
class _FloatingSheet extends StatelessWidget {
  const _FloatingSheet({
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.expand = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  // When true, the sheet fills whatever bounded height its parent gives it
  // (e.g. a fixed-height SizedBox) instead of shrink-wrapping its content —
  // needed when the child itself contains a scrollable list.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1C1C1F) : Colors.white;
    final handleColor = isDark
        ? const Color(0xFF9A9AA2)
        : FlutterFlowTheme.of(context).secondaryText;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40.0,
                  height: 4.0,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: handleColor.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              expand ? Expanded(child: child) : child,
            ],
          ),
        ),
      ),
    );
  }
}
