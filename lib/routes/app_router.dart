import 'package:go_router/go_router.dart';
import '../views/home_view.dart';
import '../views/details_view.dart';

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
    ],
  );
}
