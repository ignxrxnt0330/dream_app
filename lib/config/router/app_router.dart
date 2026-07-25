import 'package:dream_app/presentation/screens/screens.dart';
import 'package:dream_app/presentation/widgets/config/export_dreams_dialog.dart';
import 'package:flutter/material.dart';
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
    GoRoute(
      path: "/bio_validate/:obj/:finalUrl",
      name: BiometricsValidator.urlName,
      builder: (context, state) {
        final obj = state.pathParameters['obj'] ?? "";
        final finalUrl = state.pathParameters['finalUrl'] ?? "";
        return BiometricsValidator(
          obj: obj,
          redirUrl: finalUrl,
        );
      },
    ),
    GoRoute(
      path: "/bio_validate_dialog",
      name: BiometricsValidator.dialogName,
      builder: (context, state) {
        final dialog = state.extra as Widget?;
        return BiometricsValidator(
          dialog: dialog,
        );
      },
    ),
    GoRoute(
      path: "/config/action",
      name: "ConfigAction",
      builder: (context, state) {
        return HomeScreen(
          index: 3,
          configDialog: ExportDreamsDialog(),
        );
      },
    ),
  ],
);
