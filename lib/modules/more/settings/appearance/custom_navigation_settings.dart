import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/appearance/appearance_screen.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class CustomNavigationSettings extends ConsumerStatefulWidget {
  const CustomNavigationSettings({super.key});

  @override
  ConsumerState<CustomNavigationSettings> createState() =>
      _CustomNavigationSettingsState();
}

class _CustomNavigationSettingsState
    extends ConsumerState<CustomNavigationSettings> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final navigationOrder = ref.watch(navigationOrderStateProvider);
    final hideItems = ref.watch(hideItemsStateProvider);
    final isMobile = Platform.isAndroid || Platform.isIOS;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reorder_navigation),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ReorderableListView.builder(
            shrinkWrap: true,
            itemCount: navigationOrder.length,
            itemBuilder: (context, index) {
              final navigation = navigationOrder[index];
              return Row(
                key: Key('navigation_$navigation'),
                children: [
                  if (isMobile) Icon(Icons.drag_handle),
                  Expanded(
                    child: SwitchListTile.adaptive(
                      key: Key(navigation),
                      dense: true,
                      contentPadding: isMobile
                          ? null
                          : const EdgeInsets.only(left: 0, right: 40),
                      value: !hideItems.contains(navigation),
                      onChanged: ["/more", "/browse", "/history"]
                              .any((element) => element == navigation)
                          ? null
                          : (value) {
                              final temp = hideItems.toList();
                              if (!value && !hideItems.contains(navigation)) {
                                temp.add(navigation);
                              } else if (value) {
                                temp.remove(navigation);
                              }
                              ref
                                  .read(hideItemsStateProvider.notifier)
                                  .set(temp);
                            },
                      title: Text(navigationItems[navigation]!),
                    ),
                  ),
                ],
              );
            },
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
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
                  .set(navigationOrder);
            },
          ),
        ),
      ),
    );
  }
}
