import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import '/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blessing_card.dart';
import 'mood_picker.dart';
import 'home_model.dart';
export 'home_model.dart';

const _kBibleContinueReadingPrefsKey = 'bible_continue_reading';
const _kVerseFavoritesPrefsKey = 'bible_verse_favorites_v2';

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

  int _savedVersesCount = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    _model.textFieldAIQuestionTextController ??= TextEditingController()
      ..addListener(() {
        debugLogWidgetClass(_model);
      });
    _model.textFieldAIQuestionFocusNode ??= FocusNode();
    _loadSavedVersesCount();
  }

  Future<void> _loadSavedVersesCount() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kVerseFavoritesPrefsKey);
    var count = 0;
    if (raw != null) {
      try {
        count = (jsonDecode(raw) as Map<String, dynamic>).length;
      } catch (_) {
        count = 0;
      }
    }
    if (!mounted) return;
    setState(() => _savedVersesCount = count);
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
    _loadSavedVersesCount();
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
    final greetingHour = DateTime.now().hour;
    final greetingIsDark = Theme.of(context).brightness == Brightness.dark;
    final String greetingText;
    final IconData greetingIcon;
    final Color greetingIconColor;
    const sunColor = Color(0xFFFFB300);
    // White reads as a glowing moon against the dark theme's night sky;
    // on the light theme's cream background it would vanish, so use a
    // muted slate-blue there instead.
    const moonColorLight = Color(0xFF5C6470);
    if (greetingHour >= 5 && greetingHour < 12) {
      greetingText = 'Good Morning';
      greetingIcon = Icons.wb_sunny_rounded;
      greetingIconColor = sunColor;
    } else if (greetingHour >= 12 && greetingHour < 17) {
      greetingText = 'Good Afternoon';
      greetingIcon = Icons.wb_sunny_rounded;
      greetingIconColor = sunColor;
    } else if (greetingHour >= 17 && greetingHour < 21) {
      greetingText = 'Good Evening';
      greetingIcon = Icons.nights_stay_rounded;
      greetingIconColor = greetingIsDark ? Colors.white : moonColorLight;
    } else {
      greetingText = 'Good Night';
      greetingIcon = Icons.nights_stay_rounded;
      greetingIconColor = greetingIsDark ? Colors.white : moonColorLight;
    }

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
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              // The floating glass tab bar (NavBarPage) is an overlay, not
              // something that reserves layout space — Scaffold's extendBody
              // deliberately lets this page's content run full-height behind
              // it. Without enough bottom padding here, the last row of
              // cards stays permanently covered by the bar even at full
              // scroll, so this needs to clear the bar's own footprint
              // (~64px pill + ~20px margin) plus the home-indicator safe
              // area (~34px on modern iPhones).
              padding: const EdgeInsets.only(bottom: 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 16.0, 24.0, 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          greetingIcon,
                          color: greetingIconColor,
                          size: 26.0,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$greetingText, $greetingName',
                                style: GoogleFonts.interTight(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "Glad you're here",
                                style: GoogleFonts.inter(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            NavBarPage.requestedTab.value = 'Profile';
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 22.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How do you feel today?',
                          style: GoogleFonts.interTight(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 26.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Choose a feeling to receive a short blessing.',
                          style: GoogleFonts.inter(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    child: MoodPicker(
                      selectedMood: _model.selectedMood,
                      onMoodSelected: (mood) =>
                          safeSetState(() => _model.selectedMood = mood),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    child: BlessingCard(mood: _model.selectedMood),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    child: InkWell(
                      onTap: () =>
                          context.pushNamed(SavedVersesWidget.routeName),
                      borderRadius: BorderRadius.circular(18.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 14.0),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(18.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context)
                                .alternate
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFB8823A)
                                    .withValues(alpha: 0.16),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.bookmark_rounded,
                                color: Color(0xFFB8823A),
                                size: 20.0,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Saved Verses',
                                    style: GoogleFonts.interTight(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'View and manage your saved verses',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_savedVersesCount > 0) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB8823A)
                                      .withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text(
                                  '$_savedVersesCount',
                                  style: GoogleFonts.interTight(
                                    color: const Color(0xFF7A4A1F),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                            ],
                            Icon(
                              Icons.chevron_right_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    child: Text(
                      'Explore',
                      style: GoogleFonts.interTight(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        10.0, 0.0, 10.0, 0.0),
                    child: FutureBuilder<List<MenuItemsRow>>(
                      future: MenuItemsTable().queryRows(
                        queryFn: (q) => q.order('OrderIndex', ascending: true),
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

                        // Category badge icon/color/short-subtitle,
                        // keyed by title the same way the tap
                        // handler below already switches on
                        // title. Falls back to the row's own
                        // (DB-driven) subtitle for any category
                        // not explicitly listed here, so a new
                        // menu item added later still shows
                        // something rather than going blank.
                        (IconData, Color) categoryVisual(String title) {
                          switch (title) {
                            case 'Bible':
                              return (
                                Icons.menu_book_rounded,
                                const Color(0xFFD08A3E)
                              );
                            case 'Kingdom Directory':
                              return (
                                Icons.people_alt_rounded,
                                const Color(0xFF5B8DEF)
                              );
                            case 'Community Groups':
                              return (
                                Icons.groups_rounded,
                                const Color(0xFF4CAF7D)
                              );
                            case 'Needs & Crisis Response':
                              return (
                                Icons.favorite_rounded,
                                const Color(0xFFE06C7C)
                              );
                            case 'Free Stuff':
                              return (
                                Icons.card_giftcard_rounded,
                                const Color(0xFF8C7AE6)
                              );
                            case 'Events & Mission Trips':
                              return (
                                Icons.event_rounded,
                                const Color(0xFF4FA5D8)
                              );
                            case 'Accommodation':
                              return (
                                Icons.home_rounded,
                                const Color(0xFF4CAF9E)
                              );
                            case 'Debates':
                              return (
                                Icons.forum_rounded,
                                const Color(0xFF9B8AFB)
                              );
                            default:
                              return (
                                Icons.explore_rounded,
                                const Color(0xFF9AA0AC)
                              );
                          }
                        }

                        String categorySubtitle(MenuItemsRow row) {
                          switch (row.title) {
                            case 'Bible':
                              return 'Read and grow';
                            case 'Kingdom Directory':
                              return 'Find and connect';
                            case 'Community Groups':
                              return 'Belong together';
                            case 'Needs & Crisis Response':
                              return 'Get help or support';
                            case 'Free Stuff':
                              return 'Give and receive';
                            case 'Events & Mission Trips':
                              return "What's happening";
                            case 'Accommodation':
                              return 'Housing & stays';
                            case 'Debates':
                              return 'Faithful conversations';
                            default:
                              return valueOrDefault<String>(row.subtitle, '');
                          }
                        }

                        Widget buildMenuCardContent(
                            MenuItemsRow listViewMenuItemsRow) {
                          final isDarkCardContent =
                              Theme.of(context).brightness == Brightness.dark;
                          final cardContentColor = isDarkCardContent
                              ? FlutterFlowTheme.of(context).info
                              : FlutterFlowTheme.of(context).primaryText;
                          final cardSubtitleColor =
                              FlutterFlowTheme.of(context).secondaryText;
                          final (categoryIcon, categoryColor) =
                              categoryVisual(listViewMenuItemsRow.title ?? '');
                          return InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (listViewMenuItemsRow.title == 'Bible') {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final raw = prefs.getString(
                                      _kBibleContinueReadingPrefsKey);
                                  Map<String, dynamic>? continueEntry;
                                  if (raw != null) {
                                    try {
                                      continueEntry = jsonDecode(raw)
                                          as Map<String, dynamic>;
                                    } catch (_) {
                                      continueEntry = null;
                                    }
                                  }
                                  if (continueEntry != null) {
                                    context.pushNamed(
                                      ChapterDataWidget.routeName,
                                      queryParameters: {
                                        'title': serializeParam(
                                          continueEntry['reference']
                                              ?.toString(),
                                          ParamType.String,
                                        ),
                                        'bibleid': serializeParam(
                                          continueEntry['bibleId']?.toString(),
                                          ParamType.String,
                                        ),
                                        'chapterid': serializeParam(
                                          continueEntry['chapterId']
                                              ?.toString(),
                                          ParamType.String,
                                        ),
                                        'version': serializeParam(
                                          continueEntry['version']?.toString(),
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );
                                  } else {
                                    context.pushNamed(BiblesWidget.routeName);
                                  }
                                } else if (listViewMenuItemsRow.title ==
                                    'Accommodation') {
                                  context
                                      .pushNamed(AccomodationWidget.routeName);
                                } else if (listViewMenuItemsRow.title ==
                                    'Community Groups') {
                                  context.pushNamed(CommunityWidget.routeName);
                                } else if (listViewMenuItemsRow.title ==
                                    'Free Stuff') {
                                  context.pushNamed(FreeStuffWidget.routeName);
                                } else if (listViewMenuItemsRow.title ==
                                    'Needs & Crisis Response') {
                                  context.pushNamed(NeedsWidget.routeName);
                                } else if (listViewMenuItemsRow.title ==
                                    'Kingdom Directory') {}
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 34.0,
                                      height: 34.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: categoryColor.withValues(
                                            alpha: 0.16),
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        categoryIcon,
                                        color: categoryColor,
                                        size: 17.0,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            valueOrDefault<String>(
                                              listViewMenuItemsRow.title,
                                              'Title',
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.interTight(
                                              color: cardContentColor,
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w700,
                                              height: 1.15,
                                            ),
                                          ),
                                          Text(
                                            categorySubtitle(
                                                listViewMenuItemsRow),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              color: cardSubtitleColor,
                                              fontSize: 11.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 2.0),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: cardSubtitleColor,
                                      size: 18.0,
                                    ),
                                  ],
                                ),
                              ));
                        }

                        final enabledMenuItems = listViewMenuItemsRowList
                            .where((row) => row.enabled == true)
                            .toList();

                        if (defaultTargetPlatform == TargetPlatform.iOS) {
                          if (enabledMenuItems.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          const cardHeight = 80.0;
                          const gridSpacing = 12.0;

                          return LayoutBuilder(
                            builder: (context, gridConstraints) {
                              final cardWidth =
                                  (gridConstraints.maxWidth - gridSpacing) / 2;

                              return GridView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: gridSpacing,
                                  crossAxisSpacing: gridSpacing,
                                  childAspectRatio: cardWidth / cardHeight,
                                ),
                                itemCount: enabledMenuItems.length,
                                itemBuilder: (context, listViewIndex) {
                                  final listViewMenuItemsRow =
                                      enabledMenuItems[listViewIndex];
                                  final isDarkCard =
                                      Theme.of(context).brightness ==
                                          Brightness.dark;
                                  const cardTintDark = Color(0xFF12161F);
                                  const cardGoldDark = Color(0xFFD4AF37);
                                  const cardWhiteLight = Color(0xFFFFFFFF);
                                  const cardGoldLight = Color(0xFFB8823A);
                                  final cardBg = isDarkCard
                                      ? cardTintDark
                                      : cardWhiteLight;
                                  final cardBgAlpha = isDarkCard ? 0.65 : 0.85;
                                  return Container(
                                    width: cardWidth,
                                    height: cardHeight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        color: isDarkCard
                                            ? Colors.white
                                                .withValues(alpha: 0.10)
                                            : cardGoldLight.withValues(
                                                alpha: 0.35),
                                        width: 1.0,
                                      ),
                                      boxShadow: isDarkCard
                                          ? [
                                              BoxShadow(
                                                color: cardGoldDark.withValues(
                                                    alpha: 0.28),
                                                blurRadius: 36.0,
                                                spreadRadius: 1.0,
                                              ),
                                            ]
                                          : [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.10),
                                                blurRadius: 14.0,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        // Opaque backing so whatever
                                        // scrolls behind this card
                                        // can't bleed through the
                                        // glass layer's translucency.
                                        Container(
                                          decoration: BoxDecoration(
                                            color: cardBg,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        GlassCard(
                                          width: cardWidth,
                                          height: cardHeight,
                                          padding: EdgeInsets.zero,
                                          useOwnLayer: true,
                                          quality: GlassQuality.standard,
                                          shape: const LiquidRoundedRectangle(
                                            borderRadius: 20.0,
                                          ),
                                          settings: LiquidGlassSettings(
                                            glassColor: cardBg.withValues(
                                                alpha: cardBgAlpha),
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
                              );
                            },
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
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: 175.0,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        valueOrDefault<Color>(
                                          functions.hexToColor(
                                              listViewMenuItemsRow.gradient1!),
                                          FlutterFlowTheme.of(context).primary,
                                        ),
                                        valueOrDefault<Color>(
                                          functions.hexToColor(
                                              listViewMenuItemsRow.gradient2!),
                                          FlutterFlowTheme.of(context)
                                              .secondary,
                                        )
                                      ],
                                      stops: const [0.0, 1.0],
                                      begin: AlignmentDirectional(
                                          computeGradientAlignmentX(
                                              valueOrDefault<double>(
                                            listViewMenuItemsRow.gradientDegree
                                                ?.toDouble(),
                                            120.0,
                                          )),
                                          computeGradientAlignmentY(
                                              valueOrDefault<double>(
                                            listViewMenuItemsRow.gradientDegree
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
                                    borderRadius: BorderRadius.circular(8.0),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
