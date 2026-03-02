import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/modules/more/settings/track/widgets/track_listile.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/trackers/anilist.dart';
import 'package:mangayomi/services/trackers/kitsu.dart';
import 'package:mangayomi/services/trackers/myanimelist.dart';
import 'package:mangayomi/services/trackers/simkl.dart';
import 'package:mangayomi/services/trackers/trakt_tv.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class TrackScreen extends ConsumerWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateProgressAfterReading = ref.watch(
      updateProgressAfterReadingStateProvider,
    );
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10nLocalizations(context)!.tracking)),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: isar.trackPreferences.filter().syncIdIsNotNull().watch(
            fireImmediately: true,
          ),
          builder: (context, snapshot) {
            List<TrackPreference>? entries = snapshot.hasData
                ? snapshot.data
                : [];
            return Column(
              children: [
                SwitchListTile(
                  value: updateProgressAfterReading,
                  title: Text(context.l10n.updateProgressAfterReading),
                  onChanged: (value) {
                    ref
                        .read(updateProgressAfterReadingStateProvider.notifier)
                        .set(value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 10,
                    top: 5,
                  ),
                  child: Row(
                    children: [
                      Text(
                        l10n.services,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
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
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: context.secondaryColor,
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    l10n.tracking_warning_info,
                    style: TextStyle(
                      fontSize: 11,
                      color: context.secondaryColor,
                    ),
                  ),
                ),
                ListTileWidget(
                  title: l10n.manage_trackers,
                  icon: Icons.settings,
                  onTap: () => context.push('/manageTrackers'),
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

        return AlertDialog(
          title: Text(
            l10n.login_into("Kitsu"),
            style: const TextStyle(fontSize: 30),
          ),
          content: SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.username,
                      ],
                      autofocus: true,
                      onChanged: (_) => setState(updateCanLogin),
                      onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
                      decoration: InputDecoration(
                        hintText: l10n.email_adress,
                        filled: false,
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 0.4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      obscureText: obscureText,
                      onChanged: (_) => setState(updateCanLogin),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        if (canLogin && !isLoading) doLogin();
                      },
                      enableSuggestions: false,
                      autocorrect: false,
                      autofillHints: const [AutofillHints.password],
                      decoration: InputDecoration(
                        hintText: l10n.password,
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            obscureText = !obscureText;
                          }),
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                        filled: false,
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 0.4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: context.width(1),
                      height: 50,
                      child: ElevatedButton(
                        onPressed: (!canLogin || isLoading) ? null : doLogin,
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : Text(l10n.login),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
  emailController.dispose();
  passwordController.dispose();
  emailFocusNode.dispose();
  passwordFocusNode.dispose();
}
