import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:dream_app/presentation/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      path: "/dream/:dream_id",
      name: DreamScreen.name,
      builder: (context, state) {
        final dreamId = int.parse(state.pathParameters['dreamId'] ?? "0");
        return BlocProvider(
          create: (context) => DreamFormBloc(),
          child: DreamScreen(dreamId: dreamId),
        );
      },
    ),
    GoRoute(
      path: "/", // arg is always a string
      redirect: (_, __) => "/home/0",
    ),
  ],
);
