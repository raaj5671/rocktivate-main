import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'mood_wheel.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = 'Home';
  static String routePath = '/Home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with RouteAware {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    _model.textFieldAIQuestionTextController ??= TextEditingController()
      ..addListener(() {
        debugLogWidgetClass(_model);
      });
    _model.textFieldAIQuestionFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);

    _model.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(HomeWidget oldWidget) {
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

    final loggedInUserFirstName =
        FFAppState().LoggedInUserFullName.trim().split(' ').first;
    final greetingName =
        loggedInUserFirstName.isNotEmpty && loggedInUserFirstName != 'null'
            ? loggedInUserFirstName
            : 'there';

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).primaryBackground,
                FlutterFlowTheme.of(context).secondaryBackground,
              ],
              stops: const [0.0, 1.0],
              begin: const AlignmentDirectional(0.0, -1.0),
              end: const AlignmentDirectional(0, 1.0),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 16.0, 24.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome $greetingName,',
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 22.0,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontStyle,
                              ),
                        ),
                        const SizedBox(height: 28.0),
                        Text(
                          'How do you\nfeel today?',
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 44.0,
                                letterSpacing: 0.0,
                                lineHeight: 1.1,
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontStyle,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 1),
                      MoodWheel(
                        onMoodChanged: (mood) {
                          safeSetState(() => _model.selectedMood = mood);
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10.0, 0.0, 10.0, 0.0),
                        child: FutureBuilder<List<MenuItemsRow>>(
                          future: MenuItemsTable().queryRows(
                            queryFn: (q) =>
                                q.order('OrderIndex', ascending: true),
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
                            List<MenuItemsRow> listViewMenuItemsRowList =
                                snapshot.data!;

                            _model.debugBackendQueries[
                                    'listViewMenuItemsRowList_ListView_91ghl6jj${listViewMenuItemsRowList.length > 100 ? ' (first 100)' : ''}'] =
                                debugSerializeParam(
                              listViewMenuItemsRowList.take(100),
                              ParamType.SupabaseRow,
                              isList: true,
                              link:
                                  'https://app.flutterflow.io/project/rocktivate-supabase-qbw8kn?tab=uiBuilder&page=Home',
                              name: 'MenuItems',
                              nullable: false,
                            );
                            debugLogWidgetClass(_model);

                            Widget buildMenuCardContent(
                                MenuItemsRow listViewMenuItemsRow) {
                              return InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (listViewMenuItemsRow.title == 'Bible') {
                                      context.pushNamed(BiblesWidget.routeName);
                                    } else if (listViewMenuItemsRow.title ==
                                        'Accommodation') {
                                      context.pushNamed(
                                          AccomodationWidget.routeName);
                                    } else if (listViewMenuItemsRow.title ==
                                        'Community Groups') {
                                      context
                                          .pushNamed(CommunityWidget.routeName);
                                    } else if (listViewMenuItemsRow.title ==
                                        'Free Stuff') {
                                      context
                                          .pushNamed(FreeStuffWidget.routeName);
                                    } else if (listViewMenuItemsRow.title ==
                                        'Needs & Crisis Response') {
                                      context.pushNamed(NeedsWidget.routeName);
                                    } else if (listViewMenuItemsRow.title ==
                                        'Kingdom Directory') {}
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      -1.0, 0.0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      valueOrDefault<String>(
                                                        listViewMenuItemsRow
                                                            .title,
                                                        'Title',
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleLarge
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                                fontSize: 20.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleLarge
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleLarge
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                    AutoSizeText(
                                                      valueOrDefault<String>(
                                                        listViewMenuItemsRow
                                                            .subtitle,
                                                        'Subtitle',
                                                      ),
                                                      minFontSize: 9.0,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (listViewMenuItemsRow.image !=
                                                    null &&
                                                listViewMenuItemsRow.image !=
                                                    '')
                                              Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        1.0, 0.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.network(
                                                    valueOrDefault<String>(
                                                      listViewMenuItemsRow
                                                          .image,
                                                      'https://picsum.photos/seed/234/600',
                                                    ),
                                                    width: 90.0,
                                                    height: 90.0,
                                                    fit: BoxFit.contain,
                                                    alignment: const Alignment(
                                                        1.0, 0.0),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ));
                            }

                            final enabledMenuItems = listViewMenuItemsRowList
                                .where((row) => row.enabled == true)
                                .toList();

                            if (defaultTargetPlatform == TargetPlatform.iOS) {
                              if (enabledMenuItems.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return SizedBox(
                                height: 150.0,
                                child: CardSwiper(
                                  cardsCount: enabledMenuItems.length,
                                  isLoop: true,
                                  numberOfCardsDisplayed:
                                      enabledMenuItems.length < 3
                                          ? enabledMenuItems.length
                                          : 3,
                                  backCardOffset: const Offset(0, 10),
                                  padding: EdgeInsets.zero,
                                  allowedSwipeDirection:
                                      const AllowedSwipeDirection.only(
                                    down: true,
                                  ),
                                  cardBuilder: (
                                    context,
                                    listViewIndex,
                                    horizontalOffsetPercentage,
                                    verticalOffsetPercentage,
                                  ) {
                                    final listViewMenuItemsRow =
                                        enabledMenuItems[listViewIndex];
                                    const cardTint = Color(0xFF12161F);
                                    const cardGold = Color(0xFFD4AF37);
                                    return Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          1.0,
                                      height: 130.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.10),
                                          width: 1.0,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: cardGold.withValues(
                                                alpha: 0.28),
                                            blurRadius: 36.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          // Opaque backing so the next card
                                          // stacked behind this one in the
                                          // CardSwiper can't bleed through
                                          // the glass layer's translucency.
                                          Container(
                                            decoration: BoxDecoration(
                                              color: cardTint,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          GlassCard(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1.0,
                                            height: 130.0,
                                            padding: EdgeInsets.zero,
                                            useOwnLayer: true,
                                            quality: GlassQuality.standard,
                                            shape: const LiquidRoundedRectangle(
                                              borderRadius: 20.0,
                                            ),
                                            settings: LiquidGlassSettings(
                                              glassColor: cardTint.withValues(
                                                  alpha: 0.65),
                                              standardOpacityMultiplier: 1.0,
                                              thickness: 40,
                                              blur: 16.0,
                                              whitenStrength: 0.0,
                                              glowIntensity: 0.0,
                                              fresnelStrength: 0.2,
                                              ambientRim: 0.05,
                                              lightIntensity: 0.6,
                                              refractiveIndex: 1.3,
                                              shadowElevation: 2.0,
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: buildMenuCardContent(
                                                  listViewMenuItemsRow),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            }

                            return ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listViewMenuItemsRowList.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8.0),
                              itemBuilder: (context, listViewIndex) {
                                final listViewMenuItemsRow =
                                    listViewMenuItemsRowList[listViewIndex];
                                return Visibility(
                                  visible: listViewMenuItemsRow.enabled == true,
                                  child: Material(
                                    color: Colors.transparent,
                                    elevation: 2.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          1.0,
                                      height: 175.0,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            valueOrDefault<Color>(
                                              functions.hexToColor(
                                                  listViewMenuItemsRow
                                                      .gradient1!),
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                            valueOrDefault<Color>(
                                              functions.hexToColor(
                                                  listViewMenuItemsRow
                                                      .gradient2!),
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                            )
                                          ],
                                          stops: const [0.0, 1.0],
                                          begin: AlignmentDirectional(
                                              computeGradientAlignmentX(
                                                  valueOrDefault<double>(
                                                listViewMenuItemsRow
                                                    .gradientDegree
                                                    ?.toDouble(),
                                                120.0,
                                              )),
                                              computeGradientAlignmentY(
                                                  valueOrDefault<double>(
                                                listViewMenuItemsRow
                                                    .gradientDegree
                                                    ?.toDouble(),
                                                120.0,
                                              ))),
                                          end: AlignmentDirectional(
                                              -1 *
                                                  computeGradientAlignmentX(
                                                      valueOrDefault<double>(
                                                    listViewMenuItemsRow
                                                        .gradientDegree
                                                        ?.toDouble(),
                                                    120.0,
                                                  )),
                                              -1 *
                                                  computeGradientAlignmentY(
                                                      valueOrDefault<double>(
                                                    listViewMenuItemsRow
                                                        .gradientDegree
                                                        ?.toDouble(),
                                                    120.0,
                                                  ))),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: buildMenuCardContent(
                                          listViewMenuItemsRow),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
