import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/home_model.dart';
import 'package:remixicon/remixicon.dart';

class MovieDetailHeader extends StatelessWidget {
  const MovieDetailHeader({super.key, required this.data, required this.displaySub, required this.onTap});
  final Movie data;
  final bool displaySub;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      height: 80,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 200,
              child: Text(
                data.season == null ? data.title! : '${data.name} - Season ${data.season}',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            )
          ),
          if(displaySub)
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: const Icon(Remix.global_line)
                )
              )
            ),
        ],
      ),
    );
  }
}