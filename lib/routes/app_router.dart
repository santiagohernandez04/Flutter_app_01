import 'package:go_router/go_router.dart';
import '../views/home_view.dart';
import '../views/details_view.dart';
import '../views/async_view.dart';
import '../views/timer_view.dart';
import '../views/isolate_view.dart';
import '../views/giphy_list_view.dart';
import '../views/login_view.dart';
import '../views/evidence_view.dart';
import '../services/auth_service.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final isAuthenticated = await AuthService.isAuthenticated();
      final currentPath = state.matchedLocation;

      // Si está en rutas de autenticación y ya está autenticado, redirigir a evidencia
      if ((currentPath == '/login') && isAuthenticated) {
        return '/evidence';
      }

      // Si está en rutas protegidas y no está autenticado, redirigir a login
      if ((currentPath == '/evidence') && !isAuthenticated) {
        return '/login';
      }

      return null; // No redirigir
    },
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
      // Rutas de autenticación
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/evidence',
        name: 'evidence',
        builder: (context, state) => const EvidenceView(),
      ),
    ],
  );
}
