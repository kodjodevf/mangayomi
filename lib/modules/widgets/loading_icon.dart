import 'package:flutter/material.dart';

class LoadingIcon extends StatelessWidget {
  const LoadingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/app_icons/icon.png",
          color: Colors.black,
          fit: BoxFit.cover,
          height: 100,
        ),
      ),
    );
  }
}
