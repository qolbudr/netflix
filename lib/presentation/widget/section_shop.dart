import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:netflix/constant.dart';

class SectionShop extends StatelessWidget {
  const SectionShop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            primaryColor.withOpacity(0.4),
            Colors.transparent
          ],
        )
      ),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Shop", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
                const SizedBox(height: 15,),
                const Text("Exclusive limited editions of carefully selected high-quality apparel and lifestyle"),
                const SizedBox(height: 15,),
                ElevatedButton(
                  style: primaryButton,
                  onPressed: () {}, 
                  child: const Text("Go to Shop")
                )
              ],
            ),
          ),
          Expanded(
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: 'https://image.tmdb.org/t/p/w200/6ko4jfA5BrcRADDaAfMagZ4ZGpG.jpg',
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
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: 'https://image.tmdb.org/t/p/w200/uKvVjHNqB5VmOrdxqAt2F7J78ED.jpg',
                              width: 120,
                              placeholder: (_, url) => AspectRatio(
                                aspectRatio: 0.71428,
                                child: Container(
                                  width: 120,
                                  color: bgColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}