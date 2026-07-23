import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/tv_row_button.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class ListTileWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  final String? subtitle;
  final Widget? trailing;

  /// Claim focus on first build. Set on the first row of a pushed menu (the
  /// settings hub, etc.) so the remote has a starting point instead of being
  /// stranded on a screen with no established focus.
  final bool autofocus;
  const ListTileWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    this.subtitle,
    this.trailing,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    // On TV, a plain menu row gets the same lit band and accent focus as the
    // Browse / Updates / History lists, so settings and the other menus read
    // like the rest of the TV UI. Rows with an interactive trailing (a toggle)
    // keep the plain tile so that control stays reachable.
    if (isTv && trailing == null) {
      return TvListRow(
        children: [
          Expanded(
            child: TvRowButton(
              autofocus: autofocus,
              onTap: onTap,
              child: ListTile(
                leading: SizedBox(
                  height: 40,
                  child: Icon(icon, color: context.primaryColor),
                ),
                title: Text(title),
                subtitle: subtitle != null
                    ? Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.secondaryColor,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      );
    }
    return ListTile(
      autofocus: autofocus,
      onTap: onTap,
      // subtitle: subtitle != null
      //     ? Text(
      //         subtitle!,
      //         style: TextStyle(fontSize: 11, color: context.secondaryColor),
      //       )
      //     : null,
      leading: SizedBox(
        height: 40,
        child: Icon(icon, color: context.primaryColor),
      ),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(fontSize: 11, color: context.secondaryColor),
            )
          : null,
      trailing: trailing,
    );
  }
}
