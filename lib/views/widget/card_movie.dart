import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:netflix/constant.dart';
import 'package:netflix/models/tmdb_model.dart';

class CardMovie extends StatelessWidget {
  const CardMovie({super.key, required this.movie, this.noMargin});
  final bool? noMargin;
  final Tmdb movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/detail', arguments: movie),
      child: Container(
        margin: EdgeInsets.only(right: noMargin != null ? 0 : 10),
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
            errorWidget: (context, url, error) => Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/placeholder.png',
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
