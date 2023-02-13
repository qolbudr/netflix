import "package:flutter/material.dart";
import 'package:remixicon/remixicon.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({super.key, required this.title, required this.icon, required this.onTap});
  final String title;
  final Icon icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        color: Colors.white.withOpacity(0.1),
        child: Opacity(
          opacity: 0.6,
          child: Row(
            children: [
              icon,
              const SizedBox(width: 10),
              Text(title),
              const Spacer(),
              const Icon(Remix.arrow_right_s_line),
            ]
          ),
        ),
      ),
    );
  }
}