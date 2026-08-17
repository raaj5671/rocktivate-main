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

  // Curated so first-time users see the most recognizable English
  // translations pinned above the full alphabetical catalog, rather than
  // being dropped into 30+ undifferentiated options.
  static const _popularAbbreviations = ['KJV', 'ASV', 'WEB'];

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
            'Bibles',
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
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
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

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(
                          () => _searchQuery = value.trim().toLowerCase(),
                        ),
                        style: GoogleFonts.inter(
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search by name or abbreviation',
                          hintStyle: GoogleFonts.inter(
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Builder(
                        builder: (context) {
                          final bible = BibleAPIGroup.biblesCall
                                  .data(
                                    columnBiblesResponse.jsonBody,
                                  )
                                  ?.toList() ??
                              [];
                          _model.debugGeneratorVariables[
                                  'bible${bible.length > 100 ? ' (first 100)' : ''}'] =
                              debugSerializeParam(
                            bible.take(100),
                            ParamType.JSON,
                            isList: true,
                            link:
                                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Bibles',
                            name: 'dynamic',
                            nullable: false,
                          );
                          debugLogWidgetClass(_model);

                          final filtered = _searchQuery.isEmpty
                              ? bible
                              : bible.where((item) {
                                  final name = getJsonField(item, r'''$.name''')
                                      .toString()
                                      .toLowerCase();
                                  final abbr =
                                      getJsonField(item, r'''$.abbreviation''')
                                          .toString()
                                          .toLowerCase();
                                  final abbrLocal = getJsonField(
                                          item, r'''$.abbreviationLocal''')
                                      .toString()
                                      .toLowerCase();
                                  return name.contains(_searchQuery) ||
                                      abbr.contains(_searchQuery) ||
                                      abbrLocal.contains(_searchQuery);
                                }).toList();

                          final popular = <dynamic>[];
                          if (_searchQuery.isEmpty) {
                            final seen = <String>{};
                            for (final abbr in _popularAbbreviations) {
                              for (final item in bible) {
                                final abbrLocal = getJsonField(
                                        item, r'''$.abbreviationLocal''')
                                    .toString()
                                    .toUpperCase();
                                if (abbrLocal == abbr && !seen.contains(abbr)) {
                                  popular.add(item);
                                  seen.add(abbr);
                                  break;
                                }
                              }
                            }
                          }

                          Widget buildTile(dynamic bibleItem) {
                            final isDarkTile =
                                Theme.of(context).brightness == Brightness.dark;
                            const tileTintDark = Color(0xFF12161F);
                            const tileGoldDark = Color(0xFFD4AF37);
                            const tileWhiteLight = Color(0xFFFFFFFF);
                            const tileGoldLight = Color(0xFFB8823A);
                            final tileBg =
                                isDarkTile ? tileTintDark : tileWhiteLight;
                            final tileBgAlpha = isDarkTile ? 0.65 : 0.85;
                            final tileTextColor = isDarkTile
                                ? FlutterFlowTheme.of(context).info
                                : FlutterFlowTheme.of(context).primaryText;
                            final tileSubTextColor = isDarkTile
                                ? FlutterFlowTheme.of(context)
                                    .info
                                    .withValues(alpha: 0.75)
                                : FlutterFlowTheme.of(context).secondaryText;

                            final name = getJsonField(bibleItem, r'''$.name''')
                                .toString();
                            final abbrLocal = getJsonField(
                                    bibleItem, r'''$.abbreviationLocal''')
                                .toString();
                            final description = getJsonField(
                                    bibleItem, r'''$.descriptionLocal''')
                                .toString();
                            final hasUsefulDescription =
                                description.isNotEmpty &&
                                    description.toLowerCase() != 'common';
                            final subtitle = hasUsefulDescription
                                ? '$abbrLocal · $description'
                                : abbrLocal;

                            return InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0),
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
                                  }.withoutNulls,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    color: isDarkTile
                                        ? Colors.white.withValues(alpha: 0.10)
                                        : tileGoldLight.withValues(alpha: 0.35),
                                    width: 1.0,
                                  ),
                                  boxShadow: isDarkTile
                                      ? [
                                          BoxShadow(
                                            color: tileGoldDark.withValues(
                                                alpha: 0.32),
                                            blurRadius: 10.0,
                                            spreadRadius: -2.0,
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.10),
                                            blurRadius: 10.0,
                                            offset: const Offset(0.0, 3.0),
                                          ),
                                        ],
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Opaque backing so nothing behind
                                    // this tile bleeds through the glass
                                    // layer's translucency.
                                    Container(
                                      decoration: BoxDecoration(
                                        color: tileBg,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    GlassCard(
                                      padding: EdgeInsets.zero,
                                      useOwnLayer: true,
                                      quality: GlassQuality.standard,
                                      shape: const LiquidRoundedRectangle(
                                        borderRadius: 20.0,
                                      ),
                                      settings: LiquidGlassSettings(
                                        glassColor: tileBg.withValues(
                                            alpha: tileBgAlpha),
                                        standardOpacityMultiplier: 1.0,
                                        thickness: 40,
                                        blur: 16.0,
                                        whitenStrength: 0.0,
                                        glowIntensity: 0.0,
                                        fresnelStrength: 0.2,
                                        ambientRim: 0.05,
                                        lightIntensity: 0.6,
                                        refractiveIndex: 1.3,
                                        shadowElevation: 0.0,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              name,
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.interTight(
                                                color: tileTextColor,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                                height: 1.15,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              subtitle,
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                color: tileSubTextColor,
                                                fontSize: 9.0,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animateOnPageLoad(
                                animationsMap['containerOnPageLoadAnimation']!);
                          }

                          return CustomScrollView(
                            slivers: [
                              if (popular.isNotEmpty) ...[
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            2.0, 0.0, 2.0, 8.0),
                                    child: Text(
                                      'Popular',
                                      style: GoogleFonts.interTight(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 108.0,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: popular.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(width: 12.0),
                                      itemBuilder: (context, i) => SizedBox(
                                        width: 108.0,
                                        child: buildTile(popular[i]),
                                      ),
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            2.0, 18.0, 2.0, 8.0),
                                    child: Text(
                                      'All Versions',
                                      style: GoogleFonts.interTight(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              if (filtered.isEmpty)
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Center(
                                    child: Text(
                                      'No Bible versions match "$_searchQuery"',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 12.0,
                                    mainAxisSpacing: 12.0,
                                    childAspectRatio: 1.0,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) =>
                                        buildTile(filtered[index]),
                                    childCount: filtered.length,
                                  ),
                                ),
                              const SliverToBoxAdapter(
                                  child: SizedBox(height: 10.0)),
                            ],
                          );
                        },
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
