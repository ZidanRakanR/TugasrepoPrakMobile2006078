import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_note/models/note.dart';
import 'package:simple_note/services/database_services.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({
    super.key,
    this.note,
  });

  final Note? note;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final DatabaseService dbService = DatabaseService();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  DatabaseService databaseService = DatabaseService();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note != null ? "Edit Note" : "Add Note",
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Masukan Judul",
                    hintStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                  ),
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Judul wajib diisi";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Masukan Deskripsi",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                  ),
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "deskripsi wajib diisi";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formkey.currentState!.validate()) {
            Note note = Note(
              _titleController.text,
              _descriptionController.text,
              DateTime.now(),
            );

            if (widget.note != null) {
              await dbService.editNote(widget.note!.key, note);
            } else {
              await dbService.addNote(note);
            }
            if (!mounted) return;
            GoRouter.of(context).pop();
          }
        },
        label: const Text("Simpan"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
