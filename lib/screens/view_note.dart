import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notella/utils/extensions.dart';
import 'package:notella/utils/textstyle.dart';

import '../core/providers.dart';
import '../models/note.dart';

class ViewNote extends ConsumerStatefulWidget {
  final int id;
  const ViewNote({required this.id, super.key});

  @override
  ConsumerState<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends ConsumerState<ViewNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool isReadOnly = true;
  bool changesMade = false;
  Note? note = Note(title: '', content: '', timeCreated: DateTime.now());

  bool noteIsValid() {
    return titleController.text.isNotEmpty || contentController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      note = ref.watch(noteStateNotifierProvider).elementAt(widget.id);
      setState(() {});
      titleController.text = note!.title!;
      contentController.text = note!.content!;

      titleController.addListener(() {
        titleController.text == note!.title &&
                contentController.text == note!.content
            ? setState(() => changesMade = false)
            : setState(() => changesMade = true);
      });

      contentController.addListener(() {
        titleController.text == note!.title &&
                contentController.text == note!.content
            ? setState(() => changesMade = false)
            : setState(() => changesMade = true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !changesMade && noteIsValid(),
      onPopInvoked: (_) {
        changesMade && noteIsValid()
            ? showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Save changes"),
                    content: const Text("Do you want to save these changes"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ref.read(noteStateNotifierProvider.notifier).editNote(
                              widget.id,
                              note!.copyWith(
                                title: titleController.text,
                                content: contentController.text,
                              ));
                          setState(() {
                            changesMade = false;
                            isReadOnly = true;
                          });
                        },
                        child: const Text("Yes"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            titleController.text = note!.title!;
                            contentController.text = note!.content!;
                            changesMade = false;
                            isReadOnly = true;
                          });
                        },
                        child: const Text("Discard"),
                      ),
                    ],
                  );
                })
            : null;
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          actions: [
            !isReadOnly && changesMade && noteIsValid()
                ? IconButton(
                    onPressed: () {
                      Note editedNote = note!.copyWith(
                        title: titleController.text.trim(),
                        content: contentController.text.trim(),
                      );
                      ref
                          .read(noteStateNotifierProvider.notifier)
                          .editNote(widget.id, editedNote);
                      Navigator.maybePop(context);
                    },
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${note!.timeCreated!.getFormattedDate(abbreviated: false)} ${note!.timeCreated!.formattedTime}",
                style: kTextStyle(15),
              ),
              TextField(
                cursorColor: Colors.white,
                style: kTextStyle(24, fontWeight: FontWeight.bold),
                controller: titleController,
                readOnly: isReadOnly,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                  hintStyle: kTextStyle(25,
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                onTap: () {
                  setState(() {
                    isReadOnly = false;
                  });
                },
              ),
              TextField(
                style: kTextStyle(16),
                cursorColor: Colors.white,
                controller: contentController,
                maxLines: null,
                readOnly: isReadOnly,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Content...",
                  hintStyle: kTextStyle(16,
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                onTap: () {
                  setState(() {
                    isReadOnly = false;
                  });
                },
              ),
            ],
          ).padX(10),
        ),
      ),
    );
  }
}
