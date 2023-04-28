import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/categories.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/views/more/settings/categoties/widgets/custom_textfield.dart';
import 'package:random_string/random_string.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  List<CategoriesModel> entries = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit categories"),
      ),
      body: ValueListenableBuilder<Box<CategoriesModel>>(
          valueListenable: ref.watch(hiveBoxCategoriesProvider).listenable(),
          builder: (context, value, child) {
            entries = value.values.toList();
            if (entries.isNotEmpty) {
              return ListView.builder(
                itemCount: entries.length,
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
                                _renameCategory(entries[index]);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Icon(Icons.label_outline_rounded),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(child: Text(entries[index].name))
                                ],
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
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
                                        _renameCategory(entries[index]);
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
                                                        ' "${entries[index].name}"?'),
                                                    actions: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
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
                                                              onPressed: () {
                                                                ref
                                                                    .watch(
                                                                        hiveBoxCategoriesProvider)
                                                                    .delete(entries[
                                                                            index]
                                                                        .id
                                                                        .toString());
                                                                Navigator.pop(
                                                                    context);
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
            } else {
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
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            bool isExist = false;
            final controller = TextEditingController();
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Text(
                          "Add category",
                        ),
                        content: CustomTextFormField(
                            controller: controller,
                            entries: entries,
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
                                  onPressed: controller.text.isEmpty || isExist
                                      ? null
                                      : () {
                                          String randomId = randomNumeric(10);
                                          ref
                                              .watch(hiveBoxCategoriesProvider)
                                              .put(
                                                  randomId,
                                                  CategoriesModel(
                                                    id: int.parse(randomId),
                                                    name: controller.text,
                                                  ));
                                          Navigator.pop(context);
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
                  );
                });
          },
          label: Row(
            children: const [
              Icon(Icons.add),
              SizedBox(
                width: 10,
              ),
              Text("Add")
            ],
          )),
    );
  }

  _renameCategory(CategoriesModel category) {
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
                    entries: entries,
                    context: context,
                    exist: (value) {
                      setState(() {
                        isExist = value;
                      });
                    },
                    isExist: isExist,
                    name: category.name,
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
                          onPressed:
                              controller.text.isEmpty || isExist || isSameName
                                  ? null
                                  : () {
                                      ref.watch(hiveBoxCategoriesProvider).put(
                                          category.id.toString(),
                                          CategoriesModel(
                                            id: category.id,
                                            name: controller.text,
                                          ));
                                      Navigator.pop(context);
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
