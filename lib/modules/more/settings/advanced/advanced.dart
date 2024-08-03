import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/advanced/providers/native_http_client.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class AdvancedScreen extends ConsumerWidget {
  const AdvancedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final useNativeHttpClient = ref.watch(useNativeHttpClientStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.advanced),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SwitchListTile(
                  title: Text(l10n.use_native_http_client),
                  subtitle: Text(
                    l10n.use_native_http_client_info,
                    style:
                        TextStyle(fontSize: 11, color: context.secondaryColor),
                  ),
                  value: useNativeHttpClient,
                  onChanged: (value) {
                    ref
                        .read(useNativeHttpClientStateProvider.notifier)
                        .set(value);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
