import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/supabase_auth/supabase_user_provider.dart';
import 'auth/supabase_auth/auth_util.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';

import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();
  debugLogAppConstant();

  await SupaFlow.initialize();

  await FlutterFlowTheme.initialize();

  await LiquidGlassWidgets.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();
  debugLogAppState(appState);
  appState.addListener(() {
    debugLogAppState(appState);
  });

  final originalErrorWidgetBuilder = ErrorWidget.builder;
  ErrorWidget.builder = (FlutterErrorDetails details) {
    try {
      final match = RegExp(
              r'The relevant error-causing widget was:\s+([a-zA-Z0-9]+)(.|\n)*When the exception was thrown, this was the stack:((.|\n)*)')
          .firstMatch(details.toString());
      if (match == null) {
        return originalErrorWidgetBuilder(details);
      }
      final widgetName = match.group(1);
      final stackTrace = match.group(3)!;

      // The stack trace usually is very long, and most of it is entirely
      // irrelevant for troubleshooting, e.g.:
      //
      // dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 251:49  throw_
      // dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 29:3    assertFailed
      // packages/flutter/src/widgets/text.dart 378:14                                 new
      // packages/debug_screen_test/home_page/home_page_widget.dart 51:15              build
      // packages/flutter/src/widgets/framework.dart 4870:27                           build
      // packages/flutter/src/widgets/framework.dart 4754:15                           performRebuild
      // packages/flutter/src/widgets/framework.dart 4928:11                           performRebuild
      // packages/flutter/src/widgets/framework.dart 4477:5                            rebuild
      // <a long long list of internal libraries>
      //
      // We truncate everything after project-specific code.

      final filteredStackTrace = <String>[];
      var foundProjectTraces = false;
      for (final line in stackTrace.split('\n')) {
        if (line.startsWith('packages/rocktivate_supabase/')) {
          foundProjectTraces = true;
        } else {
          if (foundProjectTraces) {
            filteredStackTrace.add('...');
            break;
          }
        }
        filteredStackTrace.add(line);
      }

      final result = '''${details.exceptionAsString()}
      
The relevant error-causing widget was: $widgetName

Stack trace: ${filteredStackTrace.join("\n")}''';

      return ErrorWidget.withDetails(message: result);
    } catch (_) {
      return originalErrorWidgetBuilder(details);
    }
  };

  /// Every second, fire logging call for different channel (tag) so that frequent
  /// logging calls don't get delayed too much
  Timer.periodic(const Duration(seconds: 2), (timer) {
    EasyDebounce.fire('405ebf2ff50c295c675b5802889ea941f081fd51');
    EasyDebounce.cancel('405ebf2ff50c295c675b5802889ea941f081fd51');
    EasyDebounce.fire('fbcc19a787981a30d86b10103c2f3951604b2ae6');
    EasyDebounce.cancel('fbcc19a787981a30d86b10103c2f3951604b2ae6');

    EasyDebounce.fire('c0186d2c21d5d9300ee148206df9fbd1850b8d41');
    EasyDebounce.cancel('c0186d2c21d5d9300ee148206df9fbd1850b8d41');

    EasyDebounce.fire('508f3c74205c87928b71f49040062e732f9c20b0');
    EasyDebounce.cancel('508f3c74205c87928b71f49040062e732f9c20b0');
  });

  runApp(LiquidGlassWidgets.wrap(
    brightnessResolver: Theme.maybeBrightnessOf,
    child: ChangeNotifierProvider(
      create: (context) => appState,
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = rocktivateSupabaseSupabaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
        debugLogAuthenticatedUser();
      });
    jwtTokenStream.listen((_) {});
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );

    _router.routerDelegate.addListener(() {
      if (mounted) {
        debugLogGlobalProperty(
          context,
          routePath: getRoute(),
          routeStack: getRouteStack(),
        );
      }
    });
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RocktivateSupabase',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({
    super.key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  });

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  /// Lets a screen pushed on top of this one (e.g. the Bible reader, which
  /// renders its own copy of this tab bar) switch this still-alive
  /// [NavBarPage] instance's selected tab before popping back to it —
  /// avoids losing tab state by pushing a brand new [NavBarPage].
  static final ValueNotifier<String?> requestedTab =
      ValueNotifier<String?>(null);

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'Home';
  late Widget? _currentPage;

  // Auto-hide/show for the bottom nav bar as the active tab's content
  // scrolls: hidden only while actively scrolling down. It reappears the
  // moment scrolling stops (idle) or reverses (scrolling up), and is always
  // forced visible at the very top/bottom of the scroll — so a scroll that
  // stops mid-list never leaves it stuck hidden.
  bool _navBarVisible = true;

  bool _handleNavBarScrollNotification(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis != Axis.vertical) return false;
    if (notification.depth != 0) return false;

    final atEdge = metrics.pixels <= metrics.minScrollExtent + 4.0 ||
        metrics.pixels >= metrics.maxScrollExtent - 4.0;

    if (notification is UserScrollNotification) {
      final direction = notification.direction;
      final shouldShow = atEdge ||
          direction == ScrollDirection.idle ||
          direction == ScrollDirection.forward;
      if (shouldShow) {
        if (!_navBarVisible) safeSetState(() => _navBarVisible = true);
      } else if (direction == ScrollDirection.reverse) {
        if (_navBarVisible) safeSetState(() => _navBarVisible = false);
      }
    } else if (atEdge && !_navBarVisible) {
      safeSetState(() => _navBarVisible = true);
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
    _hydrateLoggedInUserIfNeeded();
    NavBarPage.requestedTab.addListener(_handleRequestedTab);
  }

  @override
  void dispose() {
    NavBarPage.requestedTab.removeListener(_handleRequestedTab);
    super.dispose();
  }

  void _handleRequestedTab() {
    final tab = NavBarPage.requestedTab.value;
    if (tab == null) return;
    NavBarPage.requestedTab.value = null;
    if (!mounted) return;
    safeSetState(() {
      _currentPage = null;
      _currentPageName = tab;
    });
  }

  // If the Supabase session was restored without going through the login
  // screen (e.g. a fresh install/cache clear on a device with a still-valid
  // session), FFAppState's cached profile fields are never populated there.
  // Fetch them here so screens that depend on LoggedInUserUUID don't crash.
  Future<void> _hydrateLoggedInUserIfNeeded() async {
    if (FFAppState().LoggedInUserUUID.isNotEmpty || currentUserUid.isEmpty) {
      return;
    }
    final loggedInUser = await PeopleTable().queryRows(
      queryFn: (q) => q.eqOrNull('UserUUID', currentUserUid),
    );
    final person = loggedInUser.firstOrNull;
    if (person == null || !mounted) {
      return;
    }
    FFAppState().LoggedInUserUUID = person.uuid;
    FFAppState().HasCompletedOnboarding = valueOrDefault<bool>(
      person.hasCompletedOnboarding,
      true,
    );
    FFAppState().LoggedInUserFullName = valueOrDefault<String>(
      '${person.firstName} ${person.lastName}',
      'Unknown User',
    );
    FFAppState().LoggedInUserDP = valueOrDefault<String>(
      person.profileImage,
      'https://placehold.co/150/png',
    );
    FFAppState().LoggedInUserProfilePic = valueOrDefault<String>(
      person.profileImage,
      'https://placehold.co/150/png',
    );
    safeSetState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'Home': const HomeWidget(),
      'Search': const SearchWidget(),
      'PublicFeed': const PublicFeedWidget(),
      'MyMessages': const MyMessagesWidget(),
      'Profile': const ProfileWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return GlassScaffold(
        resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: NotificationListener<ScrollNotification>(
          onNotification: _handleNavBarScrollNotification,
          child: _currentPage ?? tabs[_currentPageName]!,
        ),
        bottomBar: Visibility(
          visible: responsiveVisibility(
            context: context,
            desktop: false,
          ),
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            offset: _navBarVisible ? Offset.zero : const Offset(0, 1.4),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _navBarVisible ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: !_navBarVisible,
                child: GlassTabBar.bottom(
                  selectedIndex: currentIndex,
                  onTabSelected: (i) => safeSetState(() {
                    _currentPage = null;
                    _currentPageName = tabs.keys.toList()[i];
                  }),
                  selectedIconColor: FlutterFlowTheme.of(context).secondary,
                  unselectedIconColor:
                      FlutterFlowTheme.of(context).secondaryText,
                  tabs: const [
                    GlassTab(
                      icon: FaIcon(FontAwesomeIcons.home, size: 24.0),
                      semanticLabel: 'Home',
                    ),
                    GlassTab(
                      icon: FaIcon(FontAwesomeIcons.search, size: 24.0),
                      semanticLabel: 'Search',
                    ),
                    GlassTab(
                      icon: FaIcon(FontAwesomeIcons.stream, size: 24.0),
                      semanticLabel: 'Feed',
                    ),
                    GlassTab(
                      icon: FaIcon(FontAwesomeIcons.comment, size: 24.0),
                      semanticLabel: 'Messages',
                    ),
                    GlassTab(
                      icon: Icon(Icons.person_rounded, size: 28.0),
                      semanticLabel: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleNavBarScrollNotification,
        child: _currentPage ?? tabs[_currentPageName]!,
      ),
      bottomNavigationBar: Visibility(
        visible: responsiveVisibility(
          context: context,
          desktop: false,
        ),
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          offset: _navBarVisible ? Offset.zero : const Offset(0, 1.4),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _navBarVisible ? 1.0 : 0.0,
            child: IgnorePointer(
              ignoring: !_navBarVisible,
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (i) => safeSetState(() {
                  _currentPage = null;
                  _currentPageName = tabs.keys.toList()[i];
                }),
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                selectedItemColor: FlutterFlowTheme.of(context).secondary,
                unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.home,
                      size: 24.0,
                    ),
                    label: 'Home',
                    tooltip: '',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.search,
                      size: 24.0,
                    ),
                    label: 'Home',
                    tooltip: '',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.stream,
                      size: 24.0,
                    ),
                    label: 'Home',
                    tooltip: '',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.comment,
                      size: 24.0,
                    ),
                    label: 'Home',
                    tooltip: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_rounded,
                      size: 28.0,
                    ),
                    label: 'Home',
                    tooltip: '',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
