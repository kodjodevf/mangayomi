import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_templates.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:shiori/shiori.dart';

class CreateExtension extends StatefulWidget {
  final Source? editSource;
  const CreateExtension({super.key, this.editSource});

  @override
  State<CreateExtension> createState() => _CreateExtensionState();
}

class _CreateExtensionState extends State<CreateExtension> {
  late bool _isNsfw = widget.editSource?.isNsfw ?? false;
  bool get _isEditMode => widget.editSource != null;

  late String _name = widget.editSource?.name ?? "";
  late String _lang = widget.editSource?.lang ?? "";
  late String _baseUrl = widget.editSource?.baseUrl ?? "";
  late String _apiUrl = widget.editSource?.apiUrl ?? "";
  late String _iconUrl = widget.editSource?.iconUrl ?? "";
  late String _notes = widget.editSource?.notes ?? "";
  late int _sourceTypeIndex = widget.editSource == null
      ? 0
      : _sourceTypeValues
            .indexOf(widget.editSource!.typeSource ?? "")
            .clamp(0, _sourceTypeValues.length - 1);
  late int _itemTypeIndex = widget.editSource?.itemType.index ?? 0;
  late int _languageIndex = switch (widget.editSource?.sourceCodeLanguage) {
    SourceCodeLanguage.javascript => 1,
    SourceCodeLanguage.lnreader => 2,
    _ => 0,
  };
  static const List<String> _sourceTypeValues = ["single", "multi", "torrent"];
  late SourceCodeLanguage _sourceCodeLanguage =
      widget.editSource?.sourceCodeLanguage ?? SourceCodeLanguage.dart;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sourceTypeLabels = [
      l10n.source_type_single,
      l10n.source_type_multi,
      l10n.source_type_torrent,
    ];
    final itemTypeLabels = [l10n.manga, l10n.anime, l10n.novel];
    final languageLabels = [
      l10n.source_language_dart,
      l10n.source_language_javascript,
      l10n.source_language_lnreader_compiled_js,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? "Edit Extension" : l10n.create_extension),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ShioriSpace.s8),
          child: Column(
            children: [
              ShioriValueRow<int>(
                title: l10n.choose_extension_language,
                icon: _isEditMode ? Symbols.lock_rounded : null,
                value: _languageIndex,
                options: [
                  for (final (i, label) in languageLabels.indexed)
                    ShioriChoice(i, label),
                ],
                onChanged: _isEditMode
                    ? null
                    : (v) => setState(() {
                        _sourceCodeLanguage = switch (v) {
                          0 => SourceCodeLanguage.dart,
                          1 => SourceCodeLanguage.javascript,
                          _ => SourceCodeLanguage.lnreader,
                        };
                        _languageIndex = v;
                      }),
              ),
              _textEditing(
                l10n.name,
                context,
                l10n.extension_name_example,
                (v) {
                  setState(() {
                    _name = v;
                  });
                },
                initialValue: _name,
                enabled: !_isEditMode,
              ),
              _textEditing(
                l10n.lang,
                context,
                l10n.language_code_example,
                (v) {
                  setState(() {
                    _lang = v;
                  });
                },
                initialValue: _lang,
                enabled: !_isEditMode,
              ),
              _textEditing(l10n.base_url, context, l10n.base_url_example, (v) {
                setState(() {
                  _baseUrl = v;
                });
              }, initialValue: _baseUrl),
              _textEditing(
                l10n.api_url_optional,
                context,
                l10n.api_url_example,
                (v) {
                  setState(() {
                    _apiUrl = v;
                  });
                },
                initialValue: _apiUrl,
              ),
              _textEditing(l10n.icon_url, context, l10n.source_icon_url, (v) {
                setState(() {
                  _iconUrl = v;
                });
              }, initialValue: _iconUrl),
              _textEditing(l10n.notes, context, l10n.extension_notes_example, (
                v,
              ) {
                setState(() {
                  _notes = v;
                });
              }, initialValue: _notes),
              ShioriValueRow<int>(
                title: l10n.type,
                icon: _isEditMode ? Symbols.lock_rounded : null,
                value: _sourceTypeIndex,
                options: [
                  for (final (i, label) in sourceTypeLabels.indexed)
                    ShioriChoice(i, label),
                ],
                onChanged: _isEditMode
                    ? null
                    : (v) => setState(() => _sourceTypeIndex = v),
              ),
              ShioriValueRow<int>(
                title: l10n.target,
                icon: _isEditMode ? Symbols.lock_rounded : null,
                value: _itemTypeIndex,
                options: [
                  for (final (i, label) in itemTypeLabels.indexed)
                    ShioriChoice(i, label),
                ],
                onChanged: _isEditMode
                    ? null
                    : (v) => setState(() => _itemTypeIndex = v),
              ),
              ShioriSwitchRow(
                title: "NSFW",
                value: _isNsfw,
                onChanged: (value) => setState(() => _isNsfw = value),
              ),
              Padding(
                padding: const EdgeInsets.all(ShioriSpace.s8),
                child: Consumer(
                  builder: (context, ref, child) => ShioriButton(
                    expand: true,
                    label: context.l10n.save,
                    onPressed: () {
                      if (_name.isNotEmpty &&
                          _lang.isNotEmpty &&
                          _baseUrl.isNotEmpty &&
                          _iconUrl.isNotEmpty) {
                        try {
                          if (_isEditMode) {
                            final source = widget.editSource!
                              ..baseUrl = _baseUrl
                              ..apiUrl = _apiUrl
                              ..iconUrl = _iconUrl
                              ..notes = _notes
                              ..isNsfw = _isNsfw
                              ..typeSource =
                                  _sourceTypeValues[_sourceTypeIndex];
                            sourceRepository.save(source);
                            Navigator.pop(context, source);
                            botToast("Source updated successfully");
                            return;
                          }
                          final id =
                              _sourceCodeLanguage == SourceCodeLanguage.dart
                              ? 'mangayomi-$_lang.$_name'.hashCode
                              : 'mangayomi-js-$_lang.$_name'.hashCode;
                          final checkIfExist = sourceRepository.getById(id);
                          if (checkIfExist == null) {
                            Source source = Source(
                              id: id,
                              name: _name,
                              lang: _lang,
                              baseUrl: _baseUrl,
                              apiUrl: _apiUrl,
                              iconUrl: _iconUrl,
                              typeSource: _sourceTypeValues[_sourceTypeIndex],
                              itemType: ItemType.values.elementAt(
                                _itemTypeIndex,
                              ),
                              isAdded: true,
                              isActive: true,
                              version: "0.0.1",
                              isNsfw: _isNsfw,
                              notes: _notes,
                            )..sourceCodeLanguage = _sourceCodeLanguage;
                            source = source
                              ..isLocal = true
                              ..sourceCode =
                                  _sourceCodeLanguage == SourceCodeLanguage.dart
                                  ? dartExtensionTemplate
                                  : jsExtensionTemplate(source);
                            sourceRepository.save(source);
                            Navigator.pop(context);
                            botToast(l10n.source_created_successfully);
                          } else {
                            botToast(l10n.source_already_exists);
                          }
                        } catch (e) {
                          botToast(
                            _isEditMode
                                ? "Error when updating source"
                                : l10n.error_when_creating_source,
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _textEditing(
  String label,
  BuildContext context,
  String hintText,
  void Function(String)? onChanged, {
  String? initialValue,
  bool enabled = true,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: ShioriSpace.s16,
      vertical: ShioriSpace.s4,
    ),
    child: TextFormField(
      initialValue: initialValue,
      enabled: enabled,
      keyboardType: TextInputType.text,
      onChanged: onChanged,
      decoration: InputDecoration(hintText: hintText, labelText: label),
    ),
  );
}
