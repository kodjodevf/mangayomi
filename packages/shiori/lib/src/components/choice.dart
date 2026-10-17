import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../tokens.dart';
import 'button.dart';
import 'sheet.dart';

/// One option in [showShioriChoice] or [showShioriMultiChoice].
class ShioriChoice<T> {
  const ShioriChoice(
    this.value,
    this.label, {
    this.subtitle,
    this.icon,
    this.leading,
  });

  final T value;
  final String label;

  /// One muted line: what this option does differently.
  final String? subtitle;

  /// A leading `Symbols.*_rounded` glyph.
  final IconData? icon;

  /// A leading glyph of the app's own, drawn where [icon] would be; it
  /// takes precedence over [icon].
  final Widget? leading;
}

/// Asks for one value out of [options], in a sheet: the current one is
/// checked and in view, and picking one closes the sheet. Resolves to the
/// value picked, or null when the sheet is dismissed. [message] says what
/// the choice is about, over the options; [searchHint] adds a field that
/// narrows a long list.
///
/// This replaces the dialog of radio buttons with a Cancel button: the
/// choice is the action, and dismissing is the cancel.
Future<T?> showShioriChoice<T>(
  BuildContext context, {
  required String title,
  required List<ShioriChoice<T>> options,
  T? selected,
  String? searchHint,
  String? message,
}) {
  return showShioriSheet<T>(
    context,
    title: title,
    builder: (sheetContext) {
      void pick(T value) => Navigator.pop(sheetContext, value);
      final list = searchHint != null
          ? _SearchableChoice<T>(
              options: options,
              selected: selected,
              hint: searchHint,
              onPick: pick,
            )
          : _choiceList(options, selected, pick);
      if (message == null) return list;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Message(message),
          Flexible(child: list),
        ],
      );
    },
  );
}

/// What the choice is about, when its title alone doesn't say.
class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ShioriSpace.s16,
        0,
        ShioriSpace.s16,
        ShioriSpace.s8,
      ),
      child: Text(
        text,
        style: tokens.text.meta.copyWith(color: tokens.color.fgMuted),
      ),
    );
  }
}

Widget _choiceList<T>(
  List<ShioriChoice<T>> options,
  T? selected,
  ValueChanged<T> onPick, {
  bool autofocus = true,
}) {
  final initial = options.indexWhere((o) => o.value == selected);
  return _ChoiceList(
    // A new list when the options change, so it scrolls from the top.
    key: ValueKey(options.length),
    itemCount: options.length,
    initialIndex: initial,
    itemBuilder: (_, i) {
      final option = options[i];
      final checked = i == initial;
      return _ChoiceRow(
        option: option,
        checked: checked,
        autofocus: autofocus && (checked || (initial < 0 && i == 0)),
        onTap: () => onPick(option.value),
      );
    },
  );
}

/// A long list of options with a field over it that narrows them by
/// label: languages, fonts.
class _SearchableChoice<T> extends StatefulWidget {
  const _SearchableChoice({
    required this.options,
    required this.selected,
    required this.hint,
    required this.onPick,
  });

  final List<ShioriChoice<T>> options;
  final T? selected;
  final String hint;
  final ValueChanged<T> onPick;

  @override
  State<_SearchableChoice<T>> createState() => _SearchableChoiceState<T>();
}

class _SearchableChoiceState<T> extends State<_SearchableChoice<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final shown = q.isEmpty
        ? widget.options
        : widget.options
              .where((o) => o.label.toLowerCase().contains(q))
              .toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            ShioriSpace.s16,
            0,
            ShioriSpace.s16,
            ShioriSpace.s8,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: const Icon(Symbols.search_rounded),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Flexible(
          child: _choiceList(
            shown,
            widget.selected,
            widget.onPick,
            // The field is where a keyboard user starts.
            autofocus: false,
          ),
        ),
      ],
    );
  }
}

/// Asks for any number of values out of [options], in a sheet with a
/// confirm button. Resolves to the values checked, or null when the sheet
/// is dismissed without confirming.
Future<Set<T>?> showShioriMultiChoice<T>(
  BuildContext context, {
  required String title,
  required List<ShioriChoice<T>> options,
  Set<T> selected = const {},
  String? confirmLabel,
  String? message,
}) {
  return showShioriSheet<Set<T>>(
    context,
    title: title,
    builder: (sheetContext) => _MultiChoice<T>(
      options: options,
      initial: selected,
      message: message,
      confirmLabel:
          confirmLabel ?? MaterialLocalizations.of(sheetContext).okButtonLabel,
    ),
  );
}

class _MultiChoice<T> extends StatefulWidget {
  const _MultiChoice({
    required this.options,
    required this.initial,
    required this.message,
    required this.confirmLabel,
  });

  final List<ShioriChoice<T>> options;
  final Set<T> initial;
  final String? message;
  final String confirmLabel;

  @override
  State<_MultiChoice<T>> createState() => _MultiChoiceState<T>();
}

class _MultiChoiceState<T> extends State<_MultiChoice<T>> {
  late final Set<T> _checked = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.message != null) _Message(widget.message!),
        Flexible(
          child: _ChoiceList(
            itemCount: widget.options.length,
            initialIndex: -1,
            itemBuilder: (_, i) {
              final option = widget.options[i];
              return CheckboxListTile(
                autofocus: i == 0,
                value: _checked.contains(option.value),
                secondary:
                    option.leading ??
                    (option.icon == null ? null : Icon(option.icon)),
                title: Text(option.label),
                subtitle: option.subtitle == null
                    ? null
                    : Text(option.subtitle!),
                onChanged: (on) => setState(
                  () => on == true
                      ? _checked.add(option.value)
                      : _checked.remove(option.value),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(ShioriSpace.s16),
          child: ShioriButton(
            label: widget.confirmLabel,
            expand: true,
            onPressed: () => Navigator.pop(context, _checked),
          ),
        ),
      ],
    );
  }
}

/// The options, scrolled so the current one starts in view.
class _ChoiceList extends StatefulWidget {
  const _ChoiceList({
    super.key,
    required this.itemCount,
    required this.initialIndex,
    required this.itemBuilder,
  });

  final int itemCount;
  final int initialIndex;
  final IndexedWidgetBuilder itemBuilder;

  @override
  State<_ChoiceList> createState() => _ChoiceListState();
}

class _ChoiceListState extends State<_ChoiceList> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    // Rows are about a row height tall; starting two rows above the current
    // one keeps it in view with some context, and the list clamps the rest.
    final row = ShioriDensity.phone.rowHeight;
    _controller = ScrollController(
      initialScrollOffset: widget.initialIndex > 2
          ? (widget.initialIndex - 2) * row
          : 0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: ShioriSpace.s8),
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
    );
  }
}

class _ChoiceRow<T> extends StatelessWidget {
  const _ChoiceRow({
    required this.option,
    required this.checked,
    required this.autofocus,
    required this.onTap,
  });

  final ShioriChoice<T> option;
  final bool checked;
  final bool autofocus;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return ListTile(
      autofocus: autofocus,
      selected: checked,
      leading:
          option.leading ?? (option.icon == null ? null : Icon(option.icon)),
      title: Text(
        option.label,
        style: checked ? const TextStyle(fontWeight: FontWeight.w700) : null,
      ),
      subtitle: option.subtitle == null ? null : Text(option.subtitle!),
      trailing: checked
          ? Icon(Symbols.check_rounded, color: tokens.color.accentInk)
          : null,
      minTileHeight: tokens.density.rowHeight,
      onTap: onTap,
    );
  }
}
