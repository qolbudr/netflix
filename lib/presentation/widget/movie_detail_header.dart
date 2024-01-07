import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/movie_model.dart';
import 'package:remixicon/remixicon.dart';

class MovieDetailHeader extends StatelessWidget {
  const MovieDetailHeader({super.key, required this.data, required this.onTap, required this.enableSubtitle});
  final Movie data;
  final Function() onTap;
  final bool enableSubtitle;

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
                data.season != null ?
                '${data.tmdb?.name} - Season ${data.season}' : '${data.tmdb?.name}',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                child:  Icon(Remix.closed_captioning_line, color: enableSubtitle ? primaryColor : Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
