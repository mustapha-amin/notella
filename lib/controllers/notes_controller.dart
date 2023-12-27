import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notella/core/typedefs.dart';
import 'package:notella/models/note.dart';
import 'package:notella/services/notes_db.dart';

class NoteNotifier extends StateNotifier<List<Note>> {
  NoteDB noteDB;
  NoteNotifier({
    required this.noteDB,
  }) : super([]);

  void fetchNotes() {
    state = noteDB.fetchNotes();
  }

  FutureVoid addNote({Note? note}) async {
    await noteDB.addNote(note: note);
    fetchNotes();
  }

  FutureVoid editNote(int? key, Note? note) async {
    await noteDB.editNote(key, note);
    fetchNotes();
  }

  FutureVoid deleteNotes(int? key) async {
    await noteDB.deleteNote(key);
    fetchNotes();
  }

  void searchNote(String? query) {
    query!.toLowerCase();
    if (query.isEmpty) {
      fetchNotes();
    } else {
      state = noteDB
          .fetchNotes()
          .where((element) =>
              element.title!.toLowerCase().contains(query) ||
              element.content!.toLowerCase().contains(query))
          .toList();
    }
  }
}
