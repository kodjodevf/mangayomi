import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/modules/more/settings/player/providers/custom_buttons_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class CustomButtonScreen extends ConsumerStatefulWidget {
  const CustomButtonScreen({super.key});

  @override
  ConsumerState<CustomButtonScreen> createState() => _CustomButtonScreenState();
}

class _CustomButtonScreenState extends ConsumerState<CustomButtonScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final customButtons = ref.watch(getCustomButtonsStreamProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.custom_buttons_edit)),
      body: customButtons.when(
        data: (data) {
          if (data.isEmpty) {
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

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final customButton = data[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  key: Key("custom_btn_col_${customButton.id}"),
                  children: [
                    Row(
                      key: Key("custom_btn_row_${customButton.id}"),
                      children: [
                        ReorderableDragStartListener(
                          index: index,
                          child: const Icon(Icons.drag_handle),
                        ),
                        Expanded(
                          child: Row(
                            key: Key("custom_btn_row1_${customButton.id}"),
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Expanded(
                                child: ListTile(
                                  key: Key(
                                    "custom_btn_tile_${customButton.id}",
                                  ),
                                  dense: true,
                                  title: Text(
                                    customButton.title!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  for (final button in data) {
                                    button.isFavourite =
                                        button.id == customButton.id;
                                  }
                                  await isar.writeTxn(
                                    () async =>
                                        await isar.customButtons.putAll(data),
                                  );
                                },
                                icon: Icon(
                                  (customButton.isFavourite ?? false)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: context.primaryColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await _showEditForm(customButton);
                                },
                                icon: Icon(Icons.mode_edit_outlined),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await _showDeleteButton(customButton);
                                },
                                icon: Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      customButton.codePress ?? "",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
              onReorder: (oldIndex, newIndex) async {
                if (oldIndex < newIndex) {
                  final draggedItemPos = data[oldIndex].pos;
                  for (var i = oldIndex; i < newIndex - 1; i++) {
                    data[i].pos = data[i + 1].pos;
                  }
                  data[newIndex - 1].pos = draggedItemPos;
                } else {
                  final draggedItemPos = data[oldIndex].pos;
                  for (var i = oldIndex; i > newIndex; i--) {
                    data[i].pos = data[i - 1].pos;
                  }
                  data[newIndex].pos = draggedItemPos;
                }
                await isar.writeTxn(
                  () async => await isar.customButtons.putAll(data),
                );
              },
            ),
          );
        },
        error: (Object error, StackTrace stackTrace) {
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
        onPressed: () async {
          await _showEditForm(null);
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

  Future<void> _showEditForm(CustomButton? customButton) async {
    bool isTitleMissing = customButton == null;
    bool isCodePressMissing = customButton == null;
    final titleController = TextEditingController(
      text: customButton?.title ?? "",
    );
    final codePressController = TextEditingController(
      text: customButton?.codePress ?? "",
    );
    final codeLongPressController = TextEditingController(
      text: customButton?.codeLongPress ?? "",
    );
    final codeStartupController = TextEditingController(
      text: customButton?.codeStartup ?? "",
    );
    await showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  "${context.l10n.custom_buttons_add}${customButton != null ? " (ID: ${customButton.id})" : ""}",
                ),
                scrollable: true,
                content: Column(
                  children: [
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      name: context.l10n.custom_buttons_text,
                      helperText: context.l10n.custom_buttons_text_req,
                      allowEnterNewLine: false,
                      controller: titleController,
                      context: context,
                      missing: (value) {
                        setState(() {
                          isTitleMissing = value;
                        });
                      },
                      isMissing: isTitleMissing,
                      val: (val) {},
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      name: context.l10n.custom_buttons_js_code,
                      helperText: context.l10n.custom_buttons_js_code_req,
                      minLines: 4,
                      controller: codePressController,
                      context: context,
                      missing: (value) {
                        setState(() {
                          isCodePressMissing = value;
                        });
                      },
                      isMissing: isCodePressMissing,
                      val: (val) {},
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      name: context.l10n.custom_buttons_js_code_long,
                      minLines: 4,
                      controller: codeLongPressController,
                      context: context,
                      missing: (value) {},
                      isMissing: false,
                      val: (val) {},
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      name: context.l10n.custom_buttons_startup,
                      minLines: 4,
                      controller: codeStartupController,
                      context: context,
                      missing: (value) {},
                      isMissing: false,
                      val: (val) {},
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(context.l10n.cancel),
                      ),
                      const SizedBox(width: 15),
                      TextButton(
                        onPressed: isTitleMissing || isCodePressMissing
                            ? null
                            : () async {
                                final temp = await isar.customButtons
                                    .filter()
                                    .idEqualTo(customButton?.id)
                                    .findFirst();
                                final button =
                                    temp ??
                                    CustomButton(
                                      title: "",
                                      codePress: "",
                                      codeLongPress: "",
                                      codeStartup: "",
                                      pos: await isar.customButtons.count(),
                                    );
                                await isar.writeTxn(() async {
                                  await isar.customButtons.put(
                                    button
                                      ..title = titleController.text
                                      ..codePress = codePressController.text
                                      ..codeLongPress =
                                          codeLongPressController.text
                                      ..codeStartup =
                                          codeStartupController.text,
                                  );
                                });
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                        child: Text(
                          customButton == null
                              ? context.l10n.add
                              : context.l10n.edit,
                          style: TextStyle(
                            color: isTitleMissing || isCodePressMissing
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
  }

  Future<void> _showDeleteButton(CustomButton customButton) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(context.l10n.custom_buttons_delete),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.l10n.cancel),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () async {
                    await isar.writeTxn(
                      () async =>
                          await isar.customButtons.delete(customButton.id!),
                    );
                    if (context.mounted) {
                      Navigator.pop(context, "ok");
                    }
                  },
                  child: Text(context.l10n.ok),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final BuildContext context;
  final Function(bool) missing;
  final bool isMissing;
  final String name;
  final String helperText;
  final int minLines;
  final bool allowEnterNewLine;
  final Function(String) val;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.context,
    required this.missing,
    required this.isMissing,
    this.name = "",
    this.helperText = "",
    this.minLines = 1,
    this.allowEnterNewLine = true,
    required this.val,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minLines,
      maxLines: null,
      controller: controller,
      keyboardType: allowEnterNewLine
          ? TextInputType.multiline
          : TextInputType.text,
      onChanged: (value) {
        missing(controller.text.isEmpty);
        val(value);
      },
      onFieldSubmitted: (s) {},
      decoration: InputDecoration(
        helperText: helperText,
        helperStyle: TextStyle(color: isMissing ? Colors.red : null),
        isDense: true,
        label: Text(
          name,
          style: TextStyle(color: isMissing ? Colors.red : null),
        ),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isMissing ? Colors.red : Theme.of(context).primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isMissing ? Colors.red : Theme.of(context).primaryColor,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: isMissing ? Colors.red : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
