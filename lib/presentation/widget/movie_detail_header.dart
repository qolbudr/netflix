import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/home_model.dart';

class MovieDetailHeader extends StatelessWidget {
  const MovieDetailHeader({super.key, required this.data});
  final Movie data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      height: 80,
      child: Opacity(
        opacity: 1,
        child: Align(
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
      ),
    );
  }
}