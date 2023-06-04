import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_note/extension/date_formater.dart';
import 'package:simple_note/models/note.dart';
import 'package:simple_note/services/database_services.dart';
import 'package:simple_note/utils/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Note"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).pushNamed('add-note');
        },
        child: Icon(
          Icons.post_add_rounded,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(DatabaseService.boxName).listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text("Tidak ada data"),
            );
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final note = box.getAt(index);
                return NoteCard(
                  note: note,
                  databaseService: dbService,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.databaseService,
  });

  final Note note;
  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.key.toString()),
      onDismissed: (_) {
        databaseService.deleteNote(note).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text('Catatan berhasil dihapus'),
            ),
          );
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          onTap: () {
            GoRouter.of(context).pushNamed(
              AppRoutes.editNote,
              extra: note,
            );
          },
          title: Text(
            note.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(note.description),
          trailing: Text('Dibuat pada:\n ${note.createdAt.toSunda()}'),
        ),
      ),
    );
  }
}
