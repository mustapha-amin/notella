import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? content;
  @HiveField(2)
  DateTime? timeCreated;

  Note({
    this.title,
    this.content,
    this.timeCreated,
  });

  Note copyWith({String? title, String? content}) {
    return Note(
      title: title ?? this.title,
      content: content ?? this.content,
      timeCreated: DateTime.now(),
    );
  }
}
