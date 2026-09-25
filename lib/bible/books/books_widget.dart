import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'books_model.dart';
export 'books_model.dart';

const _kContinueReadingPrefsKey = 'bible_continue_reading';
const _kGoldAccent = Color(0xFFBFA46A);

class BooksWidget extends StatefulWidget {
  const BooksWidget({
    super.key,
    String? title,
    required this.bibleid,
    this.version,
    this.initialBookId,
    this.initialChapterNumber,
  }) : title = title ?? 'Books';

  final String title;
  final String? bibleid;
  final String? version;
  final String? initialBookId;
  final String? initialChapterNumber;

  static String routeName = 'Books';
  static String routePath = '/books';

  @override
  State<BooksWidget> createState() => _BooksWidgetState();
}

class _BooksWidgetState extends State<BooksWidget>
    with TickerProviderStateMixin, RouteAware {
  late BooksModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};
  final _searchController = TextEditingController();
  final _booksScrollController = ScrollController();
  String _searchQuery = '';
  String? _expandedBookId;
  Map<String, dynamic>? _continueEntry;
  final Map<String, GlobalKey> _bookRowKeys = {};
  bool _scrolledToInitial = false;

  // Collapsed book row: ~16px container padding top+bottom, ~24px of
  // Noto Serif 20 text, plus the 12px gap below each row. Close enough to
  // jump the list near the target book so its row actually gets built by
  // ListView.builder, which we then fine-tune with ensureVisible.
  static const _kEstimatedRowHeight = 76.0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BooksModel());
    _expandedBookId = widget.initialBookId;
    _loadContinueEntry();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 80.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  Future<void> _loadContinueEntry() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kContinueReadingPrefsKey);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      if (mounted) setState(() => _continueEntry = decoded);
    } catch (_) {
      // Ignore a corrupted/old-format entry.
    }
  }

  void _openChapter({
    required String? bibleid,
    required String chapterId,
    required String title,
    String? version,
  }) {
    HapticFeedback.lightImpact();
    context.pushNamed(
      ChapterDataWidget.routeName,
      queryParameters: {
        'title': serializeParam(title, ParamType.String),
        'bibleid': serializeParam(bibleid, ParamType.String),
        'chapterid': serializeParam(chapterId, ParamType.String),
        'version': serializeParam(
          version ?? widget.version,
          ParamType.String,
        ),
      }.withoutNulls,
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _searchController.dispose();
    _booksScrollController.dispose();

    _model.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(BooksWidget oldWidget) {
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
    // The reader may have updated "where you left off" while we were away.
    _loadContinueEntry();
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
    final scaffoldBg = isDark
        ? const Color(0xFF07070A)
        : FlutterFlowTheme.of(context).primaryBackground;
    final primaryTextColor =
        isDark ? Colors.white : FlutterFlowTheme.of(context).primaryText;
    final secondaryTextColor = isDark
        ? const Color(0xFF9A9AA2)
        : FlutterFlowTheme.of(context).secondaryText;
    final searchFieldBg = isDark
        ? const Color(0xFF1A1A1E)
        : FlutterFlowTheme.of(context).alternate;
    final circleBg = isDark
        ? const Color(0xFF1A1A1E)
        : FlutterFlowTheme.of(context).alternate;
    final tileBg = isDark ? const Color(0xFF1E1E22) : const Color(0xFFECECEC);
    final continueBg =
        isDark ? const Color(0xFF17140C) : const Color(0xFFFBF6EA);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          backgroundColor: scaffoldBg,
          iconTheme: IconThemeData(color: primaryTextColor),
          automaticallyImplyLeading: false,
          leadingWidth: 64.0,
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(start: 16.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              customBorder: const CircleBorder(),
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: circleBg),
                child: Icon(Icons.close_rounded,
                    color: primaryTextColor, size: 20.0),
              ),
            ),
          ),
          title: Text(
            'Books',
            style: GoogleFonts.interTight(
              color: primaryTextColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 20.0, 0.0),
            child: FutureBuilder<ApiCallResponse>(
              future: BibleAPIGroup.booksCall.call(
                bibleID: widget.bibleid,
              ),
              builder: (context, snapshot) {
                // Customize what your widget looks like when it's loading.
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
                final columnBooksResponse = snapshot.data!;
                _model.debugBackendQueries[
                        'BibleAPIGroup.booksCall_statusCode_Column_nzjmd96k'] =
                    debugSerializeParam(
                  columnBooksResponse.statusCode,
                  ParamType.int,
                  link:
                      'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Books',
                  name: 'int',
                  nullable: false,
                );
                _model.debugBackendQueries[
                        'BibleAPIGroup.booksCall_responseBody_Column_nzjmd96k'] =
                    debugSerializeParam(
                  columnBooksResponse.bodyText,
                  ParamType.String,
                  link:
                      'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Books',
                  name: 'String',
                  nullable: false,
                );
                debugLogWidgetClass(_model);

                final allBooks = BibleAPIGroup.booksCall
                        .data(
                          columnBooksResponse.jsonBody,
                        )
                        ?.toList() ??
                    [];
                _model.debugGeneratorVariables[
                        'bible${allBooks.length > 100 ? ' (first 100)' : ''}'] =
                    debugSerializeParam(
                  allBooks.take(100),
                  ParamType.JSON,
                  isList: true,
                  link:
                      'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Books',
                  name: 'dynamic',
                  nullable: false,
                );
                debugLogWidgetClass(_model);

                final filteredBooks = _searchQuery.isEmpty
                    ? allBooks
                    : allBooks.where((bookItem) {
                        final name = getJsonField(bookItem, r'''$.name''')
                            .toString()
                            .toLowerCase();
                        final nameLong =
                            getJsonField(bookItem, r'''$.nameLong''')
                                .toString()
                                .toLowerCase();
                        return name.contains(_searchQuery) ||
                            nameLong.contains(_searchQuery);
                      }).toList();

                Widget buildChapterGrid(
                  String bookId,
                  String bookName,
                  List<Map> chapters,
                ) {
                  final continueChapterNumber = widget.initialBookId == bookId
                      ? widget.initialChapterNumber
                      : (_continueEntry != null &&
                              _continueEntry!['bookId'] == bookId)
                          ? _continueEntry!['chapterNumber']?.toString()
                          : null;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: chapters.length,
                    itemBuilder: (context, chapterIndex) {
                      final chapter = chapters[chapterIndex];
                      final number = chapter['number'].toString();
                      final chapterId = chapter['id'].toString();
                      final isCurrent = continueChapterNumber == number;

                      return GlassButton.custom(
                        onTap: () => _openChapter(
                          bibleid: widget.bibleid,
                          chapterId: chapterId,
                          title: '$bookName $number',
                        ),
                        useOwnLayer: true,
                        width: double.infinity,
                        height: double.infinity,
                        style: isCurrent
                            ? GlassButtonStyle.prominent
                            : GlassButtonStyle.filled,
                        shape: const LiquidRoundedRectangle(
                            borderRadius: 10.0),
                        settings: isCurrent
                            ? LiquidGlassSettings(
                                glassColor: FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.5),
                                thickness: 40,
                                blur: 16.0,
                                lightIntensity: 0.6,
                                refractiveIndex: 1.3,
                              )
                            : null,
                        child: Text(
                          number,
                          style: GoogleFonts.inter(
                            color: isCurrent ? Colors.white : primaryTextColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  );
                }

                Widget buildBookRow(dynamic bookItem) {
                  final bookId = getJsonField(bookItem, r'''$.id''').toString();
                  final bookName =
                      getJsonField(bookItem, r'''$.name''').toString();
                  final chaptersRaw =
                      getJsonField(bookItem, r'''$.chapters''') as List? ?? [];
                  final chapters = chaptersRaw
                      .whereType<Map>()
                      .where((c) => c['number'] != 'intro')
                      .toList()
                    ..sort((a, b) => ((a['position'] as num?) ?? 0)
                        .compareTo((b['position'] as num?) ?? 0));
                  final isExpanded = _expandedBookId == bookId;
                  final rowKey =
                      _bookRowKeys.putIfAbsent(bookId, () => GlobalKey());

                  return Padding(
                    key: rowKey,
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GlassButton.custom(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() =>
                                _expandedBookId = isExpanded ? null : bookId);
                          },
                          useOwnLayer: true,
                          width: double.infinity,
                          style: isExpanded
                              ? GlassButtonStyle.prominent
                              : GlassButtonStyle.filled,
                          shape: const LiquidRoundedRectangle(
                              borderRadius: 16.0),
                          settings: isExpanded
                              ? LiquidGlassSettings(
                                  glassColor:
                                      _kGoldAccent.withValues(alpha: 0.35),
                                  thickness: 40,
                                  blur: 16.0,
                                  lightIntensity: 0.6,
                                  refractiveIndex: 1.3,
                                )
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    bookName,
                                    style: GoogleFonts.notoSerif(
                                      color: primaryTextColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: circleBg,
                                  ),
                                  child: Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_down_rounded
                                        : Icons.chevron_right_rounded,
                                    color: primaryTextColor,
                                    size: 22.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded) ...[
                          const SizedBox(height: 16.0),
                          buildChapterGrid(bookId, bookName, chapters),
                        ],
                      ],
                    ),
                  );
                }

                if (!_scrolledToInitial && widget.initialBookId != null) {
                  final targetIndex = filteredBooks.indexWhere((b) =>
                      getJsonField(b, r'''$.id''').toString() ==
                      widget.initialBookId);
                  if (targetIndex > 0) {
                    _scrolledToInitial = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!_booksScrollController.hasClients) return;
                      // Jump straight to an estimated offset first so
                      // ListView.builder actually builds the target row —
                      // ensureVisible can't scroll to a row that was never
                      // built because it was still off-screen.
                      final maxScroll =
                          _booksScrollController.position.maxScrollExtent;
                      final estimatedOffset =
                          (targetIndex * _kEstimatedRowHeight)
                              .clamp(0.0, maxScroll);
                      _booksScrollController.jumpTo(estimatedOffset);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final rowContext =
                            _bookRowKeys[widget.initialBookId]?.currentContext;
                        if (rowContext != null) {
                          Scrollable.ensureVisible(
                            rowContext,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            alignment: 0.05,
                          );
                        }
                      });
                    });
                  }
                }

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(
                        () => _searchQuery = value.trim().toLowerCase(),
                      ),
                      style: GoogleFonts.inter(color: primaryTextColor),
                      decoration: InputDecoration(
                        hintText: 'Search books or chapters',
                        hintStyle: GoogleFonts.inter(color: secondaryTextColor),
                        prefixIcon: Icon(Icons.search_rounded,
                            color: secondaryTextColor),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.close_rounded,
                                    color: secondaryTextColor),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: searchFieldBg,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (_continueEntry != null) ...[
                      const SizedBox(height: 20.0),
                      Text(
                        'CONTINUE',
                        style: GoogleFonts.inter(
                          color: secondaryTextColor,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () => _openChapter(
                          bibleid: _continueEntry!['bibleId']?.toString(),
                          chapterId:
                              _continueEntry!['chapterId']?.toString() ?? '',
                          title: _continueEntry!['reference']?.toString() ??
                              'Continue',
                          version: _continueEntry!['version']?.toString(),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: continueBg,
                            border: Border.all(
                              color: _kGoldAccent.withValues(alpha: 0.55),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _continueEntry!['reference']
                                              ?.toString() ??
                                          '',
                                      style: GoogleFonts.notoSerif(
                                        color: primaryTextColor,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Where you left off',
                                      style: GoogleFonts.inter(
                                        color: secondaryTextColor,
                                        fontSize: 13.0,
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
                    ],
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: filteredBooks.isEmpty
                          ? Center(
                              child: Text(
                                'No books match "$_searchQuery"',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: secondaryTextColor,
                                  fontSize: 14.0,
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: _booksScrollController,
                              padding: const EdgeInsets.only(bottom: 20.0),
                              itemCount: filteredBooks.length,
                              itemBuilder: (context, bookIndex) =>
                                  buildBookRow(filteredBooks[bookIndex])
                                      .animateOnPageLoad(animationsMap[
                                          'containerOnPageLoadAnimation']!),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
