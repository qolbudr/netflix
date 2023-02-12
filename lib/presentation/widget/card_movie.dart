import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/home_model.dart';

class CardMovie extends StatelessWidget {
  const CardMovie({super.key, required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: movie),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/w200/${movie.posterPath}',
            width: 120,
            placeholder: (_, url) => AspectRatio(
              aspectRatio: 0.71,
              child: Container(
                width: 120,
                color: bgColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}