import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class ListTileWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  final String? subtitle;
  final Widget? trailing;
  const ListTileWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
