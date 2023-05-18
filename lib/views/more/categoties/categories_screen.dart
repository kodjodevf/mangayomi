import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/views/more/categoties/providers/isar_providers.dart';
import 'package:mangayomi/views/more/categoties/widgets/custom_textfield.dart';
import 'package:mangayomi/views/widgets/progress_center.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  List<Category> _entries = [];
  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(getMangaCategorieStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit categories"),
      ),
      body: categories.when(
        data: (data) {
          if (data.isEmpty) {
            _entries = [];
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "You have no categories. Tap the plus button to create one for organizing your library",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          _entries = data;
          return ListView.builder(
            itemCount: _entries.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  child: Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)))),
                          onPressed: () {
                            _renameCategory(_entries[index]);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(Icons.label_outline_rounded),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text(_entries[index].name!))
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.arrow_drop_up_outlined),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_drop_down_outlined)
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _renameCategory(_entries[index]);
                                  },
                                  icon: const Icon(
                                      Icons.mode_edit_outline_outlined)),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                title: const Text(
                                                  "Delete category",
                                                ),
                                                content: Text(
                                                    "Do you wish to delete the category"
                                                    ' "${_entries[index].name}"?'),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Cancel")),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      TextButton(
                                                          onPressed: () async {
                                                            await isar.writeTxn(
                                                                () async {
                                                              await isar
                                                                  .categorys
                                                                  .delete(_entries[
                                                                          index]
                                                                      .id!);
                                                            });
                                                            if (mounted) {
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child: const Text(
                                                            "OK",
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.delete_outlined))
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        error: (Object error, StackTrace stackTrace) {
          _entries = [];
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "You have no categories. Tap the plus button to create one for organizing your library",
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        loading: () {
          return const ProgressCenter();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            bool isExist = false;
            final controller = TextEditingController();
            showDialog(
                context: context,
                builder: (context) {
                  return SizedBox(
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text(
                            "Add category",
                          ),
                          content: CustomTextFormField(
                              controller: controller,
                              entries: _entries,
                              context: context,
                              exist: (value) {
                                setState(() {
                                  isExist = value;
                                });
                              },
                              isExist: isExist,
                              val: (val) {}),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel")),
                                const SizedBox(
                                  width: 15,
                                ),
                                TextButton(
                                    onPressed:
                                        controller.text.isEmpty || isExist
                                            ? null
                                            : () async {
                                                await isar.writeTxn(() async {
                                                  await isar.categorys
                                                      .put(Category(
                                                    name: controller.text,
                                                  ));
                                                });
                                                if (mounted) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                    child: Text(
                                      "Add",
                                      style: TextStyle(
                                          color:
                                              controller.text.isEmpty || isExist
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.2)
                                                  : null),
                                    )),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  );
                });
          },
          label: const Row(
            children: [
              Icon(Icons.add),
              SizedBox(
                width: 10,
              ),
              Text("Add")
            ],
          )),
    );
  }

  _renameCategory(Category category) {
    bool isExist = false;
    final controller = TextEditingController(text: category.name);
    bool isSameName = controller.text == category.name;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text(
                  "Rename category",
                ),
                content: CustomTextFormField(
                    controller: controller,
                    entries: _entries,
                    context: context,
                    exist: (value) {
                      setState(() {
                        isExist = value;
                      });
                    },
                    isExist: isExist,
                    name: category.name!,
                    val: (val) {
                      setState(() {
                        isSameName = controller.text == category.name;
                      });
                    }),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      const SizedBox(
                        width: 15,
                      ),
                      TextButton(
                          onPressed: controller.text.isEmpty ||
                                  isExist ||
                                  isSameName
                              ? null
                              : () async {
                                  await isar.writeTxn(() async {
                                    category.name = controller.text;
                                    await isar.categorys.put(category);
                                  });
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                          child: Text(
                            "OK",
                            style: TextStyle(
                                color: controller.text.isEmpty ||
                                        isExist ||
                                        isSameName
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2)
                                    : null),
                          )),
                    ],
                  )
                ],
              );
            },
          );
        });
  }
}
