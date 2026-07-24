import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/route_names.dart';
import 'theme/app_theme.dart';
import '../features/splash/presentation/pages/splash_screen.dart';
import '../features/main/presentation/pages/main_wrapper.dart';
import '../features/player/presentation/pages/player_screen.dart';
import '../features/search/presentation/pages/search_screen.dart';

class ModiMusicApp extends ConsumerWidget {
  const ModiMusicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Modi Music',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}

// Route Paths define karte hain taaki router mein use ho sakein
class RoutePaths {
  static const String splash = '/';
  static const String home = '/home';
  static const String library = '/library';
  static const String player = '/player';
  static const String search = '/search';
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RoutePaths.splash,
  routes: [
    GoRoute(
      path: RoutePaths.splash,
      name: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RoutePaths.home,
      name: RouteNames.home,
      builder: (context, state) => const MainWrapper(),
    ),
    GoRoute(
      path: RoutePaths.player,
      name: RouteNames.player,
      builder: (context, state) => const PlayerScreen(),
    ),
    GoRoute(
      path: RoutePaths.search,
      name: RouteNames.search,
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);

final appRouterProvider = Provider<GoRouter>((ref) {
  return appRouter;
});