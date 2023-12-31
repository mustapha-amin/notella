import 'package:flutter/material.dart';
import 'package:notella/models/note.dart';
import 'package:notella/utils/extensions.dart';
import 'package:notella/utils/textstyle.dart';

class NoteTile extends StatelessWidget {
  Note? note;
  NoteTile({this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          note!.title!,
          style:
              kTextStyle(16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(note!.content!,
            style: kTextStyle(12, color: Colors.grey)
                .copyWith(overflow: TextOverflow.ellipsis)),
        trailing: Text(
            "${note!.timeCreated!.getFormattedDate()}  ${note!.timeCreated!.formattedTime}",
            style: kTextStyle(12, color: Colors.grey)),
      ).padAll(5),
    ).padX(3);
  }
}
