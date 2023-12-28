import 'package:hive/hive.dart';
import 'package:notella/core/typedefs.dart';
import 'package:notella/models/note.dart';

class NoteDB {
  Box<Note> notesBox;

  NoteDB({required this.notesBox});

  FutureVoid addNote({Note? note}) async {
    await notesBox.add(note!);
  }

  FutureVoid editNote(int? key, Note? note) async {
    await notesBox.putAt(key!, note!);
  }

  FutureVoid deleteNote(Note? note) async {
    await note!.delete();
  }

  List<Note>? fetchNotes() {
    return notesBox.values.toList()
      ..sort((a, b) => b.timeCreated!.compareTo(a.timeCreated!));
  }
}
