import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/modules/more/settings/track/widgets/track_listile.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/trackers/anilist.dart';
import 'package:mangayomi/services/trackers/kitsu.dart';
import 'package:mangayomi/services/trackers/local_tracker.dart';
import 'package:mangayomi/services/trackers/myanimelist.dart';
import 'package:mangayomi/services/trackers/simkl.dart';
import 'package:mangayomi/services/trackers/trakt_tv.dart';

class TrackScreen extends ConsumerWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateProgressAfterReading = ref.watch(
      updateProgressAfterReadingStateProvider,
    );
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tracking)),
      body: SingleChildScrollView(
        padding: tvPageInsets,
        child: StreamBuilder(
          stream: trackRepository.watchAllWithSyncId(),
          builder: (context, snapshot) {
            List<TrackPreference>? entries = snapshot.hasData
                ? snapshot.data
                : [];
            return Column(
              children: [
                ShioriSettingsGroup(
                  children: [
                    ShioriSwitchRow(
                      autofocus: isTv,
                      title: l10n.updateProgressAfterReading,
                      value: updateProgressAfterReading,
                      onChanged: (v) => ref
                          .read(
                            updateProgressAfterReadingStateProvider.notifier,
                          )
                          .set(v),
                    ),
                  ],
                ),
                ShioriSettingsGroup(
                  title: l10n.services,
                  footer: l10n.tracking_warning_info,
                  children: [
                    TrackListile(
                      onTap: () async {
                        await ref
                            .read(
                              anilistProvider(
                                syncId: TrackerProviders.anilist.syncId,
                                widgetRef: ref,
                              ).notifier,
                            )
                            .login();
                      },
                      id: TrackerProviders.anilist.syncId,
                      entries: entries!,
                    ),
                    TrackListile(
                      onTap: () => _showDialogLogin(context, ref),
                      id: TrackerProviders.kitsu.syncId,
                      entries: entries,
                    ),
                    TrackListile(
                      onTap: () async {
                        await ref
                            .read(
                              myAnimeListProvider(
                                syncId: TrackerProviders.myAnimeList.syncId,
                                itemType: null,
                                widgetRef: ref,
                              ).notifier,
                            )
                            .login();
                      },
                      id: TrackerProviders.myAnimeList.syncId,
                      entries: entries,
                    ),
                    TrackListile(
                      onTap: () async {
                        await ref
                            .read(
                              simklProvider(
                                syncId: TrackerProviders.simkl.syncId,
                                itemType: null,
                                widgetRef: ref,
                              ).notifier,
                            )
                            .login();
                      },
                      id: TrackerProviders.simkl.syncId,
                      entries: entries,
                    ),
                    TrackListile(
                      onTap: () async {
                        await ref
                            .read(
                              traktTvProvider(
                                syncId: TrackerProviders.trakt.syncId,
                                itemType: null,
                                widgetRef: ref,
                              ).notifier,
                            )
                            .login();
                      },
                      id: TrackerProviders.trakt.syncId,
                      entries: entries,
                    ),
                  ],
                ),
                ShioriSettingsGroup(
                  title: l10n.on_this_device,
                  children: [
                    ShioriSwitchRow(
                      title: l10n.local_tracking,
                      subtitle: l10n.local_tracking_desc,
                      value: entries.any(
                        (e) => e.syncId == TrackerProviders.local.syncId,
                      ),
                      onChanged: (on) {
                        final local = ref.read(
                          localTrackerProvider(
                            syncId: TrackerProviders.local.syncId,
                            itemType: null,
                            widgetRef: ref,
                          ).notifier,
                        );
                        on ? local.enable() : local.disable();
                      },
                    ),
                  ],
                ),
                ShioriSettingsGroup(
                  children: [
                    ShioriSettingRow(
                      icon: Symbols.tune_rounded,
                      title: l10n.manage_trackers,
                      trailing: const Icon(Symbols.chevron_forward_rounded),
                      onTap: () => context.push('/manageTrackers'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<void> _showDialogLogin(BuildContext context, WidgetRef ref) async {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  bool canLogin = false;
  String errorMessage = "";
  bool isLoading = false;
  bool obscureText = true;
  final l10n = l10nLocalizations(context)!;
  void updateCanLogin() {
    canLogin =
        emailController.text.trim().isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        void doLogin() async {
          setState(() {
            isLoading = true;
            errorMessage = "";
          });
          final email = emailController.text.trim();
          final password = passwordController.text;
          final res = await ref
              .read(
                kitsuProvider(
                  syncId: TrackerProviders.kitsu.syncId,
                  widgetRef: ref,
                ).notifier,
              )
              .login(email, password);
          if (!res.$1) {
            setState(() {
              isLoading = false;
              errorMessage = res.$2;
            });
          } else {
            TextInput.finishAutofillContext();
            if (context.mounted) {
              Navigator.pop(context);
            }
          }
        }

        return ShioriDialog(
          title: l10n.login_into("Kitsu"),
          content: AutofillGroup(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: ShioriSpace.s16,
              children: [
                TextField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [
                    AutofillHints.email,
                    AutofillHints.username,
                  ],
                  autofocus: !isTv,
                  onChanged: (_) => setState(updateCanLogin),
                  onSubmitted: (_) => passwordFocusNode.requestFocus(),
                  decoration: InputDecoration(labelText: l10n.email_adress),
                ),
                TextField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  obscureText: obscureText,
                  onChanged: (_) => setState(updateCanLogin),
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (canLogin && !isLoading) doLogin();
                  },
                  enableSuggestions: false,
                  autocorrect: false,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    errorText: errorMessage.isEmpty ? null : errorMessage,
                    errorMaxLines: 3,
                    suffixIcon: IconButton(
                      tooltip: obscureText
                          ? l10n.show_password
                          : l10n.hide_password,
                      onPressed: () =>
                          setState(() => obscureText = !obscureText),
                      icon: Icon(
                        obscureText
                            ? Symbols.visibility_rounded
                            : Symbols.visibility_off_rounded,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ShioriButton.quiet(
              label: l10n.cancel,
              onPressed: () => Navigator.pop(context),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(ShioriSpace.s8),
                child: ShioriLoading.inline(),
              )
            else
              ShioriButton(
                label: l10n.login,
                onPressed: canLogin ? doLogin : null,
              ),
          ],
        );
      },
    ),
  );
  emailController.dispose();
  passwordController.dispose();
  emailFocusNode.dispose();
  passwordFocusNode.dispose();
}
