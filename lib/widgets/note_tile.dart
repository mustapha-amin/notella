import 'package:flutter/material.dart';
import 'package:notella/models/note.dart';
import 'package:notella/utils/extensions.dart';
import 'package:notella/utils/textstyle.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  const NoteTile({required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: const Color(0xFF005C5C), // 0xFF4B0082
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        note.title!,
        style: kTextStyle(15, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(note.content!,
          style: kTextStyle(12, color: Colors.black)
              .copyWith(overflow: TextOverflow.ellipsis)),
      trailing: Text(
          "${note.timeCreated!.getFormattedDate()}  ${note.timeCreated!.formattedTime}"),
    ).padAll(10);
  }
}
