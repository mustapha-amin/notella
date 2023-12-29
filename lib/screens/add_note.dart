import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notella/models/note.dart';
import 'package:notella/utils/extensions.dart';
import 'package:notella/utils/textstyle.dart';

import '../core/providers.dart';

class AddNote extends ConsumerStatefulWidget {
  const AddNote({super.key});

  @override
  ConsumerState<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends ConsumerState<AddNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool saveBttnVisible = false;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    titleController.addListener(() {
      titleController.text.isNotEmpty
          ? setState(() => saveBttnVisible = true)
          : setState(() => saveBttnVisible = false);
    });
    contentController.addListener(() {
      contentController.text.isNotEmpty
          ? setState(() => saveBttnVisible = true)
          : setState(() => saveBttnVisible = false);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(titleFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add note"),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: saveBttnVisible
                ? () {
                    ref.read(noteStateNotifierProvider.notifier).addNote(
                          note: Note(
                            title: titleController.text.trim(),
                            content: contentController.text.trim(),
                            timeCreated: DateTime.now(),
                          ),
                        );
                    context.pop();
                  }
                : null,
            icon: Icon(
              Icons.check,
              color: saveBttnVisible ? Colors.white : null,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              focusNode: titleFocus,
              style: kTextStyle(24, fontWeight: FontWeight.bold),
              cursorColor: Colors.white,
              textCapitalization: TextCapitalization.sentences,
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
                hintStyle: kTextStyle(
                  24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                titleFocus.unfocus();
                FocusScope.of(context).requestFocus(contentFocus);
              },
            ),
            TextField(
              style: kTextStyle(16),
              cursorColor: Colors.white,
              focusNode: contentFocus,
              controller: contentController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Content...",
                hintStyle: kTextStyle(16, color: Colors.grey),
              ),
              maxLines: null,
            ),
          ],
        ).padX(10),
      ),
    );
  }
}
