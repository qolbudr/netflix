import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:netflix/data/model/movie_detail_model.dart';

class TrailerSection extends StatelessWidget {
  const TrailerSection({super.key, required this.data});
  final MovieDetailModel data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: data.videos!.results!.length,
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: 'https://img.youtube.com/vi/${data.videos!.results![index].key!}/mqdefault.jpg',
          ),
          const SizedBox(height: 15),
          Text(data.videos!.results![index].name!),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}