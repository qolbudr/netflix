import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:netflix/data/model/movie_detail_model.dart';
import 'package:remixicon/remixicon.dart';

class TrailerSection extends StatelessWidget {
  const TrailerSection({super.key, required this.data, required this.play});
  final MovieDetailModel data;
  final Function(String) play;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: data.videos!.results!.length,
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: 'https://img.youtube.com/vi/${data.videos!.results![index].key!}/mqdefault.jpg',
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => play('https://www.youtube.com/embed/${data.videos!.results![index].key!}'),
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    child: const Center(child: Icon(Remix.play_circle_line, size: 50))
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Text(data.videos!.results![index].name!),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}