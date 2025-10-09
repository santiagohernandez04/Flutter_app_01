import 'package:go_router/go_router.dart';
import '../views/home_view.dart';
import '../views/details_view.dart';
import '../views/async_view.dart';
import '../views/timer_view.dart';
import '../views/isolate_view.dart';
import '../views/giphy_list_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/details/:navigationType/:parameter',
        name: 'details',
        builder: (context, state) {
          final navigationType = state.pathParameters['navigationType']!;
          final parameter = state.pathParameters['parameter']!;
          return DetailsView(
            navigationType: navigationType,
            parameter: parameter,
          );
        },
      ),
      GoRoute(
        path: '/async',
        name: 'async',
        builder: (context, state) => const AsyncView(),
      ),
      GoRoute(
        path: '/timer',
        name: 'timer',
        builder: (context, state) => const TimerView(),
      ),
      GoRoute(
        path: '/isolate',
        name: 'isolate',
        builder: (context, state) => const IsolateView(),
      ),
      // Rutas para el taller de Giphy
      GoRoute(
        path: '/giphy',
        name: 'giphy',
        builder: (context, state) => const GiphyListView(),
      ),
    ],
  );
}
