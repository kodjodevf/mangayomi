import 'package:flutter/material.dart';
import 'package:mangayomi/utils/colors.dart';

class ListTileWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  final String? subtitle;
  final Widget? trailing;
  const ListTileWidget(
      {super.key,
      required this.onTap,
      required this.title,
      required this.icon,
      this.subtitle,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      // subtitle: subtitle != null
      //     ? Text(
      //         subtitle!,
      //         style: TextStyle(fontSize: 11, color: secondaryColor(context)),
      //       )
      //     : null,
      leading: SizedBox(
          height: 40,
          child: Icon(
            icon,
            color: primaryColor(context),
          )),
      title: Text(title),
      trailing: trailing,
    );
  }
}
