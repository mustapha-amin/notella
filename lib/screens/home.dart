import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:notella/models/note.dart';
import 'package:notella/screens/add_note.dart';
import 'package:notella/screens/view_note.dart';
import 'package:notella/utils/extensions.dart';
import 'package:notella/utils/textstyle.dart';

import '../core/providers.dart';
import '../widgets/note_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  bool fabIsVisible = true;
  FocusNode searchFocus = FocusNode();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.hasClients &&
          scrollController.offset == 0.0 &&
          !searchFocus.hasFocus) {
        setState(() {
          fabIsVisible = true;
        });
      } else {
        setState(() {
          fabIsVisible = false;
        });
      }
    });
    searchFocus.addListener(() {
      if (searchFocus.hasFocus) {
        setState(() {
          fabIsVisible = false;
        });
      } else {
        setState(() {
          fabIsVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Note> notes = ref.watch(noteStateNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notes",
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SearchBar(
            textStyle: MaterialStatePropertyAll(
              kTextStyle(15, color: Colors.grey[300]),
            ),
            focusNode: searchFocus,
            backgroundColor: MaterialStatePropertyAll(Colors.grey[600]),
            controller: searchController,
            trailing: const [
              Icon(Icons.search) // 0xFF6,66666,
            ],
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            hintText: "Search notes",
            hintStyle: MaterialStatePropertyAll(
              kTextStyle(15, color: Colors.grey[300]),
            ),
            constraints: BoxConstraints(
              minHeight: context.screenHeight * .06,
              minWidth: context.screenWidth * .7,
            ),
            onChanged: (query) {
              ref.read(noteStateNotifierProvider.notifier).searchNote(query);
            },
          ).padX(10),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: notes.isEmpty
                ? Center(
                    child: Text(
                      "No notes",
                      style: kTextStyle(20),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.push(ViewNote(id: index));
                        },
                        child: Dismissible(                      
                          background: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            height: context.screenHeight * 12,
                            color: Colors.red,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [Icon(Icons.delete_forever)],
                            ),
                          ).padX(5),
                          secondaryBackground: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            height: context.screenHeight * 12,
                            color: Colors.red,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Icon(Icons.delete_forever)],
                            ),
                          ).padX(5),
                          key: UniqueKey(),
                          onDismissed: (_) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Delete note"),
                                  content: const Text(
                                      "Do you want to delete this note?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        ref
                                            .read(noteStateNotifierProvider
                                                .notifier)
                                            .deleteNote((notes[index]));
                                      },
                                      child: const Text("Yes"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        ref.invalidate(
                                            noteStateNotifierProvider);
                                      },
                                      child: const Text("No"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: NoteTile(
                            note: notes[index],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: fabIsVisible
          ? FloatingActionButton(
              onPressed: () {
                context.push(const AddNote());
              },
              child: const Icon(
                Icons.add,
              ),
            )
          : const SizedBox(),
    );
  }
}
