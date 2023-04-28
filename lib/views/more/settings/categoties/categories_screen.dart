import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/categories.dart';
import 'package:mangayomi/providers/hive_provider.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit categories"),
      ),
      body: ValueListenableBuilder<Box<CategoriesModel>>(
          valueListenable: ref.watch(hiveBoxCategoriesProvider).listenable(),
          builder: (context, value, child) {
            final entries = value.values.toList();
            if (entries.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {},
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
            showDialog(
                context: context,
                builder: (context) {
                  final controller = TextEditingController();
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Text(
                          "Add category",
                        ),
                        content: TextFormField(
                          autofocus: true,
                          controller: controller,
                          keyboardType: TextInputType.text,
                          onChanged: (s) {
                            setState(() {});
                          },
                          onFieldSubmitted: (s) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              isDense: true,
                              labelText: "Name",
                              filled: true,
                              fillColor: Colors.transparent,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor))),
                        ),
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
                                  onPressed: controller.text.isEmpty
                                      ? null
                                      : () {
                                          Navigator.pop(context);
                                        },
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                        color: controller.text.isEmpty
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
}
