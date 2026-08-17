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
import 'chapters_model.dart';
export 'chapters_model.dart';

class ChaptersWidget extends StatefulWidget {
  const ChaptersWidget({
    super.key,
    String? title,
    required this.bibleid,
    required this.bookid,
    required this.bookName,
  }) : title = title ?? 'Books';

  final String title;
  final String? bibleid;
  final String? bookid;
  final String? bookName;

  static String routeName = 'Chapters';
  static String routePath = '/Chapters';

  @override
  State<ChaptersWidget> createState() => _ChaptersWidgetState();
}

class _ChaptersWidgetState extends State<ChaptersWidget>
    with TickerProviderStateMixin, RouteAware {
  late ChaptersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChaptersModel());

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

    _model.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(ChaptersWidget oldWidget) {
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
          title: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
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
                      fontStyle:
                          FlutterFlowTheme.of(context).titleMedium.fontStyle,
                    ),
              ),
              Text(
                valueOrDefault<String>(
                  widget.bookName,
                  'Book Name',
                ),
                style: FlutterFlowTheme.of(context).labelSmall.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).labelSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelSmall.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).labelSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelSmall.fontStyle,
                    ),
              ),
            ],
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
              future: BibleAPIGroup.chapterCall.call(
                bibleID: widget.bibleid,
                bookID: widget.bookid,
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
                final columnChapterResponse = snapshot.data!;
                _model.debugBackendQueries[
                        'BibleAPIGroup.chapterCall_statusCode_Column_uxgmr7gb'] =
                    debugSerializeParam(
                  columnChapterResponse.statusCode,
                  ParamType.int,
                  link:
                      'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Chapters',
                  name: 'int',
                  nullable: false,
                );
                _model.debugBackendQueries[
                        'BibleAPIGroup.chapterCall_responseBody_Column_uxgmr7gb'] =
                    debugSerializeParam(
                  columnChapterResponse.bodyText,
                  ParamType.String,
                  link:
                      'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Chapters',
                  name: 'String',
                  nullable: false,
                );
                debugLogWidgetClass(_model);

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Builder(
                        builder: (context) {
                          final bible = BibleAPIGroup.chapterCall
                                  .data(
                                    columnChapterResponse.jsonBody,
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
                                'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Chapters',
                            name: 'dynamic',
                            nullable: false,
                          );
                          debugLogWidgetClass(_model);

                          return GridView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: bible.length,
                            itemBuilder: (context, bibleIndex) {
                              final bibleItem = bible[bibleIndex];
                              final isDarkTile = Theme.of(context).brightness ==
                                  Brightness.dark;
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

                              return InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(16.0),
                                onTap: () async {
                                  HapticFeedback.lightImpact();

                                  context.pushNamed(
                                    ChapterDataWidget.routeName,
                                    queryParameters: {
                                      'title': serializeParam(
                                        getJsonField(
                                          bibleItem,
                                          r'''$.reference''',
                                        ).toString(),
                                        ParamType.String,
                                      ),
                                      'bibleid': serializeParam(
                                        widget.bibleid,
                                        ParamType.String,
                                      ),
                                      'chapterid': serializeParam(
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
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: isDarkTile
                                          ? Colors.white.withValues(alpha: 0.10)
                                          : tileGoldLight.withValues(
                                              alpha: 0.35),
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
                                              BorderRadius.circular(16.0),
                                        ),
                                      ),
                                      GlassCard(
                                        padding: EdgeInsets.zero,
                                        useOwnLayer: true,
                                        quality: GlassQuality.standard,
                                        shape: const LiquidRoundedRectangle(
                                          borderRadius: 16.0,
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
                                        child: Center(
                                          child: Text(
                                            getJsonField(
                                              bibleItem,
                                              r'''$.number''',
                                            ).toString(),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.interTight(
                                              color: tileTextColor,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).animateOnPageLoad(animationsMap[
                                  'containerOnPageLoadAnimation']!);
                            },
                          );
                        },
                      ),
                    ),
                  ]
                      .divide(const SizedBox(height: 10.0))
                      .around(const SizedBox(height: 10.0)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
