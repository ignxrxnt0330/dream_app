import 'package:dream_app/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(

  initialLocation: '/home/0',
  routes: [
    GoRoute(
      path: "/home/:page",
      name: HomeScreen.name,
      builder: (context, state) {
        final index = int.parse(state.pathParameters['page'] ?? "0");
        return HomeScreen(index: index);
      },
      // add other routes so they are its children and they can arrow back to it
      routes: const [],
    ),
    GoRoute(
      path: "/dream/:dreamId",
      name: DreamScreen.name,
      builder: (context, state) {
        final dreamId = int.parse(state.pathParameters['dreamId'] ?? "0");
        return DreamScreen(dreamId: dreamId);
      },
    ),
    GoRoute(
      path: "/", // arg is always a string
      redirect: (_, __) => "/home/0",
    ),
  ],
);
