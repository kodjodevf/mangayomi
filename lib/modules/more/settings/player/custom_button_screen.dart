import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/modules/more/settings/player/providers/custom_buttons_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class CustomButtonScreen extends ConsumerStatefulWidget {
  const CustomButtonScreen({super.key});

  @override
  ConsumerState<CustomButtonScreen> createState() => _CustomButtonScreenState();
}

class _CustomButtonScreenState extends ConsumerState<CustomButtonScreen> {
  List<CustomButton> _entries = [];
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final customButtons = ref.watch(getCustomButtonsStreamProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.custom_buttons_edit)),
      body: customButtons.when(
        data: (data) {
          if (data.isEmpty) {
            _entries = [];
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  l10n.custom_buttons_edit,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          data.sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0));
          _entries = data;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final customButton = _entries[index];
                return Row(
                  key: Key('custom_btn_${customButton.id}'),
                  children: [
                    ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_handle),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              (customButton.isFavourite ?? false)
                                  ? Icons.star
                                  : Icons.star_border,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.mode_edit_outlined),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              onReorder: (oldIndex, newIndex) {
                /*if (oldIndex < newIndex) {
                  final draggedItem = navigationOrder[oldIndex];
                  for (var i = oldIndex; i < newIndex - 1; i++) {
                    navigationOrder[i] = navigationOrder[i + 1];
                  }
                  navigationOrder[newIndex - 1] = draggedItem;
                } else {
                  final draggedItem = navigationOrder[oldIndex];
                  for (var i = oldIndex; i > newIndex; i--) {
                    navigationOrder[i] = navigationOrder[i - 1];
                  }
                  navigationOrder[newIndex] = draggedItem;
                }
                ref
                    .read(navigationOrderStateProvider.notifier)
                    .set(navigationOrder);*/
              },
            ),
          );
        },
        error: (Object error, StackTrace stackTrace) {
          _entries = [];
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                l10n.custom_buttons_edit,
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
                      title: Text(l10n.add_category),
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
                        val: (val) {},
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(l10n.cancel),
                            ),
                            const SizedBox(width: 15),
                            TextButton(
                              onPressed: controller.text.isEmpty || isExist
                                  ? null
                                  : () async {
                                      /*final category = Category(
                                        forItemType: widget.itemType,
                                        name: controller.text,
                                        updatedAt: DateTime.now()
                                            .millisecondsSinceEpoch,
                                      );
                                      isar.writeTxnSync(() {
                                        isar.categorys.putSync(
                                          category..pos = category.id,
                                        );
                                        final categories = isar.categorys
                                            .filter()
                                            .posIsNull()
                                            .findAllSync();
                                        for (var category in categories) {
                                          isar.categorys.putSync(
                                            category..pos = category.id,
                                          );
                                        }
                                      });*/

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                              child: Text(
                                l10n.add,
                                style: TextStyle(
                                  color: controller.text.isEmpty || isExist
                                      ? Theme.of(
                                          context,
                                        ).primaryColor.withValues(alpha: 0.2)
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
        label: Row(
          children: [
            const Icon(Icons.add),
            const SizedBox(width: 10),
            Text(l10n.add),
          ],
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final List<CustomButton> entries;
  final BuildContext context;
  final Function(bool) exist;
  final bool isExist;
  final String name;
  final Function(String) val;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.entries,
    required this.context,
    required this.exist,
    required this.isExist,
    this.name = "",
    required this.val,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context);
    return TextFormField(
      autofocus: true,
      controller: controller,
      keyboardType: TextInputType.text,
      onChanged: (value) {
        if (name != controller.text) {
          exist(
            entries
                .where((element) => element.title == controller.text)
                .toList()
                .isNotEmpty,
          );
        }
        val(value);
      },
      onFieldSubmitted: (s) {},
      decoration: InputDecoration(
        helperText: isExist == true
            ? l10n!.add_category_error_exist
            : l10n!.category_name_required,
        helperStyle: TextStyle(color: isExist == true ? Colors.red : null),
        isDense: true,
        label: Text(
          l10n.name,
          style: TextStyle(color: isExist == true ? Colors.red : null),
        ),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isExist == true
                ? Colors.red
                : Theme.of(context).primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isExist == true
                ? Colors.red
                : Theme.of(context).primaryColor,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: isExist == true
                ? Colors.red
                : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
