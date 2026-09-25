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
import 'bibles_model.dart';
export 'bibles_model.dart';

class BiblesWidget extends StatefulWidget {
  const BiblesWidget({super.key});

  static String routeName = 'Bibles';
  static String routePath = '/bible';

  @override
  State<BiblesWidget> createState() => _BiblesWidgetState();
}

class _BiblesWidgetState extends State<BiblesWidget>
    with TickerProviderStateMixin, RouteAware {
  late BiblesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _audioOnly = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BiblesModel());

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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _searchController.dispose();

    _model.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(BiblesWidget oldWidget) {
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
    final badgeBg = isDark ? const Color(0xFF1E1E22) : const Color(0xFFECECEC);
    final pillSelectedBg =
        isDark ? Colors.white : FlutterFlowTheme.of(context).primaryText;
    final pillSelectedText =
        isDark ? Colors.black : FlutterFlowTheme.of(context).primaryBackground;
    final pillUnselectedBg = isDark
        ? const Color(0xFF1A1A1E)
        : FlutterFlowTheme.of(context).alternate;

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
          automaticallyImplyLeading: true,
          title: const SizedBox.shrink(),
          actions: const [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
            child: FutureBuilder<ApiCallResponse>(
              future: BibleAPIGroup.biblesCall.call(),
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
                final columnBiblesResponse = snapshot.data!;
                _model.debugBackendQueries[
                        'BibleAPIGroup.biblesCall_statusCode_Column_tejnssbv'] =
                    debugSerializeParam(
                  columnBiblesResponse.statusCode,
                  ParamType.int,
                  link:
                      'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Bibles',
                  name: 'int',
                  nullable: false,
                );
                _model.debugBackendQueries[
                        'BibleAPIGroup.biblesCall_responseBody_Column_tejnssbv'] =
                    debugSerializeParam(
                  columnBiblesResponse.bodyText,
                  ParamType.String,
                  link:
                      'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Bibles',
                  name: 'String',
                  nullable: false,
                );
                debugLogWidgetClass(_model);

                return Builder(
                  builder: (context) {
                    final allBibles = BibleAPIGroup.biblesCall
                            .data(
                              columnBiblesResponse.jsonBody,
                            )
                            ?.toList() ??
                        [];
                    _model.debugGeneratorVariables[
                            'bible${allBibles.length > 100 ? ' (first 100)' : ''}'] =
                        debugSerializeParam(
                      allBibles.take(100),
                      ParamType.JSON,
                      isList: true,
                      link:
                          'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Bibles',
                      name: 'dynamic',
                      nullable: false,
                    );
                    debugLogWidgetClass(_model);

                    bool hasAudio(dynamic bibleItem) {
                      final audioBibles = getJsonField(
                        bibleItem,
                        r'''$.audioBibles''',
                        true,
                      ) as List?;
                      return audioBibles != null && audioBibles.isNotEmpty;
                    }

                    final filtered = allBibles.where((bibleItem) {
                      if (_audioOnly && !hasAudio(bibleItem)) return false;
                      if (_searchQuery.isEmpty) return true;
                      final name = getJsonField(bibleItem, r'''$.name''')
                          .toString()
                          .toLowerCase();
                      final abbreviation =
                          getJsonField(bibleItem, r'''$.abbreviationLocal''')
                              .toString()
                              .toLowerCase();
                      return name.contains(_searchQuery) ||
                          abbreviation.contains(_searchQuery);
                    }).toList();

                    Widget buildPill({
                      required String label,
                      required bool selected,
                      required VoidCallback onTap,
                    }) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(24.0),
                        onTap: onTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: selected ? pillSelectedBg : pillUnselectedBg,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Text(
                            label,
                            style: GoogleFonts.inter(
                              color: selected
                                  ? pillSelectedText
                                  : primaryTextColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12.0),
                        Text(
                          '${allBibles.length} versions in English',
                          style: GoogleFonts.interTight(
                            color: primaryTextColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(
                            () => _searchQuery = value.trim().toLowerCase(),
                          ),
                          style: GoogleFonts.inter(color: primaryTextColor),
                          decoration: InputDecoration(
                            hintText: 'Search Versions',
                            hintStyle:
                                GoogleFonts.inter(color: secondaryTextColor),
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
                        const SizedBox(height: 14.0),
                        Row(
                          children: [
                            buildPill(
                              label: 'All',
                              selected: !_audioOnly,
                              onTap: () => setState(() => _audioOnly = false),
                            ),
                            const SizedBox(width: 10.0),
                            buildPill(
                              label: 'Audio available',
                              selected: _audioOnly,
                              onTap: () => setState(() => _audioOnly = true),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            Icon(Icons.language_rounded,
                                color: primaryTextColor, size: 20.0),
                            const SizedBox(width: 10.0),
                            Text(
                              'English',
                              style: GoogleFonts.interTight(
                                color: primaryTextColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              decoration: BoxDecoration(
                                color: pillUnselectedBg,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                '${allBibles.length}',
                                style: GoogleFonts.inter(
                                  color: secondaryTextColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Expanded(
                          child: filtered.isEmpty
                              ? Center(
                                  child: Text(
                                    'No versions match "$_searchQuery"',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      color: secondaryTextColor,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  itemCount: filtered.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 4.0),
                                  itemBuilder: (context, bibleIndex) {
                                    final bibleItem = filtered[bibleIndex];
                                    final abbreviationLocal = getJsonField(
                                      bibleItem,
                                      r'''$.abbreviationLocal''',
                                    ).toString();
                                    final name = getJsonField(
                                      bibleItem,
                                      r'''$.name''',
                                    ).toString();
                                    final showAudio = hasAudio(bibleItem);

                                    return GlassButton.custom(
                                      onTap: () async {
                                        HapticFeedback.lightImpact();

                                        context.pushNamed(
                                          BooksWidget.routeName,
                                          queryParameters: {
                                            'title': serializeParam(
                                              name,
                                              ParamType.String,
                                            ),
                                            'bibleid': serializeParam(
                                              getJsonField(
                                                bibleItem,
                                                r'''$.id''',
                                              ).toString(),
                                              ParamType.String,
                                            ),
                                            'version': serializeParam(
                                              abbreviationLocal,
                                              ParamType.String,
                                            ),
                                          }.withoutNulls,
                                        );
                                      },
                                      useOwnLayer: true,
                                      width: double.infinity,
                                      shape: const LiquidRoundedRectangle(
                                          borderRadius: 14.0),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 52.0,
                                              height: 52.0,
                                              decoration: BoxDecoration(
                                                color: badgeBg,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                abbreviationLocal.toUpperCase(),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  color: secondaryTextColor,
                                                  fontSize: 9.0,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 14.0),
                                            Expanded(
                                              child: Text(
                                                name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.interTight(
                                                  color: primaryTextColor,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            if (showAudio) ...[
                                              Icon(
                                                Icons.volume_up_rounded,
                                                color: secondaryTextColor,
                                                size: 18.0,
                                              ),
                                              const SizedBox(width: 8.0),
                                            ],
                                            Icon(
                                              Icons.chevron_right_rounded,
                                              color: secondaryTextColor,
                                              size: 22.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).animateOnPageLoad(animationsMap[
                                        'containerOnPageLoadAnimation']!);
                                  },
                                ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
