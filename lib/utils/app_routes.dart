import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_note/models/note.dart';
import 'package:simple_note/pages/add_note_screen.dart';
import 'package:simple_note/pages/home_screen.dart';

class AppRoutes {
  static const home = "home";
  static const addNote = "add-note";
  static const editNote = "edit-note";

  static Page _homeScreenBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return const MaterialPage(
      child: HomeScreen(),
    );
  }

  static Page _addNoteScreenBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return const MaterialPage(
      child: AddNoteScreen(),
    );
  }

  static Page _editNoteScreenBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return MaterialPage(
      child: AddNoteScreen(
        note: state.extra as Note,
      ),
    );
  }

  final GoRouter goRouter = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        name: home,
        path: "/",
        pageBuilder: _homeScreenBuilder,
        routes: [
          GoRoute(
            name: addNote,
            path: "add-note",
            pageBuilder: _addNoteScreenBuilder,
          ),
          GoRoute(
            name: editNote,
            path: "edit-note",
            pageBuilder: _editNoteScreenBuilder,
          ),
        ],
      ),
    ],
  );
}
