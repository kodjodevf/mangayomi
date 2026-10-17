import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/repositories/custom_button_repository.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/modules/more/settings/player/providers/custom_buttons_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

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
            return ShioriEmptyState(
              icon: Symbols.terminal_rounded,
              title: l10n.custom_buttons,
              message: l10n.custom_buttons_info,
              actionLabel: l10n.custom_buttons_add,
              onAction: () => _edit(null),
            );
          }
          return ReorderableListView.builder(
            buildDefaultDragHandles: false,
            padding: const EdgeInsets.only(bottom: ShioriSpace.s48 * 2),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final button = data[index];
              final favourite = button.isFavourite ?? false;
              return ShioriListRow(
                key: ValueKey('custom_btn_${button.id}'),
                leading: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Symbols.drag_handle_rounded),
                ),
                title: button.title ?? '',
                subtitle: button.codePress,
                onTap: () => _edit(button),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: l10n.set_as_default,
                      isSelected: favourite,
                      onPressed: () async {
                        for (final other in data) {
                          other.isFavourite = other.id == button.id;
                        }
                        await customButtonRepository.putAll(data);
                      },
                      icon: Icon(
                        Symbols.star_rounded,
                        fill: favourite ? 1 : 0,
                        color: favourite
                            ? context.shiori.color.accentInk
                            : null,
                      ),
                    ),
                    ShioriMenuButton(
                      tooltip: MaterialLocalizations.of(context)
                          .moreButtonTooltip,
                      items: [
                        ShioriMenuItem(
                          label: l10n.edit,
                          icon: Symbols.edit_rounded,
                          onSelected: () => _edit(button),
                        ),
                        ShioriMenuItem(
                          label: MaterialLocalizations.of(context)
                              .deleteButtonTooltip,
                          icon: Symbols.delete_rounded,
                          destructive: true,
                          onSelected: () => _delete(button),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            onReorderItem: (oldIndex, newIndex) async {
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
              await customButtonRepository.putAll(data);
            },
          );
        },
        error: (error, stackTrace) => ErrorState(detail: '$error'),
        loading: () => const ShioriLoading(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(null),
        icon: const Icon(Symbols.add_rounded),
        label: Text(l10n.add),
      ),
    );
  }

  /// The button's text and its code, in a tall sheet: the code fields are
  /// several lines each, and a dialog left them a few words wide.
  Future<void> _edit(CustomButton? customButton) => showShioriSheet<void>(
    context,
    title: customButton == null
        ? context.l10n.custom_buttons_add
        : context.l10n.edit,
    maxHeightFactor: 0.95,
    builder: (_) => _CustomButtonForm(customButton: customButton),
  );

  Future<void> _delete(CustomButton customButton) async {
    final confirmed = await showShioriConfirm(
      context,
      title: context.l10n.custom_buttons_delete,
      message: customButton.title,
      confirmLabel: MaterialLocalizations.of(context).deleteButtonTooltip,
      destructive: true,
    );
    if (confirmed) await customButtonRepository.delete(customButton.id!);
  }
}

class _CustomButtonForm extends StatefulWidget {
  const _CustomButtonForm({required this.customButton});

  final CustomButton? customButton;

  @override
  State<_CustomButtonForm> createState() => _CustomButtonFormState();
}

class _CustomButtonFormState extends State<_CustomButtonForm> {
  late final _title = TextEditingController(
    text: widget.customButton?.title ?? '',
  );
  late final _press = TextEditingController(
    text: widget.customButton?.codePress ?? '',
  );
  late final _longPress = TextEditingController(
    text: widget.customButton?.codeLongPress ?? '',
  );
  late final _startup = TextEditingController(
    text: widget.customButton?.codeStartup ?? '',
  );

  @override
  void initState() {
    super.initState();
    // The save button follows the two required fields.
    _title.addListener(_refresh);
    _press.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    for (final c in [_title, _press, _longPress, _startup]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _complete =>
      _title.text.trim().isNotEmpty && _press.text.trim().isNotEmpty;

  Future<void> _save() async {
    final existing = await customButtonRepository.findById(
      widget.customButton?.id,
    );
    final button =
        existing ??
        CustomButton(
          title: "",
          codePress: "",
          codeLongPress: "",
          codeStartup: "",
          pos: await customButtonRepository.count(),
        );
    await customButtonRepository.save(
      button
        ..title = _title.text
        ..codePress = _press.text
        ..codeLongPress = _longPress.text
        ..codeStartup = _startup.text,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mono = context.shiori.text.row.copyWith(fontFamily: 'monospace');
    Widget field(
      TextEditingController controller,
      String label, {
      String? helper,
      bool code = true,
    }) => TextField(
      controller: controller,
      minLines: code ? 3 : 1,
      maxLines: code ? 8 : 1,
      keyboardType: code ? TextInputType.multiline : TextInputType.text,
      style: code ? mono : null,
      decoration: InputDecoration(labelText: label, helperText: helper),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(ShioriSpace.s16),
              children: [
                field(
                  _title,
                  l10n.custom_buttons_text,
                  helper: l10n.custom_buttons_text_req,
                  code: false,
                ),
                const SizedBox(height: ShioriSpace.s16),
                field(
                  _press,
                  l10n.custom_buttons_js_code,
                  helper: l10n.custom_buttons_js_code_req,
                ),
                const SizedBox(height: ShioriSpace.s16),
                field(_longPress, l10n.custom_buttons_js_code_long),
                const SizedBox(height: ShioriSpace.s16),
                field(_startup, l10n.custom_buttons_startup),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                ShioriSpace.s16,
                0,
                ShioriSpace.s16,
                ShioriSpace.s16,
              ),
              child: ShioriButton(
                label: widget.customButton == null ? l10n.add : l10n.save,
                expand: true,
                onPressed: _complete ? _save : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
