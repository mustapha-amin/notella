import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notella/models/note.dart';

import '../controllers/notes_controller.dart';
import '../services/notes_db.dart';

final hiveProvider = Provider((ref) => Hive.box<Note>('notes_db'));

final noteDBProvider = Provider((ref) {
  final noteBox = ref.watch(hiveProvider);
  return NoteDB(notesBox: noteBox);
});

final noteStateNotifierProvider =
    StateNotifierProvider<NoteNotifier, List<Note>>((ref) {
  final noteDB = ref.watch(noteDBProvider);
  final notifier = NoteNotifier(noteDB: noteDB);
  notifier.fetchNotes();
  return notifier;
});