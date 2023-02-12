import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/home_model.dart';
import 'package:netflix/presentation/provider/detail_provider.dart';
import 'package:netflix/presentation/widget/media_section.dart';
import 'package:netflix/presentation/widget/movie_detail_header.dart';
import 'package:netflix/presentation/widget/movie_info.dart';
import 'package:netflix/presentation/widget/trailer_section.dart';
import 'package:provider/provider.dart';

class Detail extends StatefulWidget {
  const Detail({super.key, required this.data});
  final Movie data;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DetailProvider>(context, listen: false).getMovieDetail(widget.data.id!);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Consumer<DetailProvider>(
            builder: (_, dp, __) {
              if(dp.isLoading == true) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.all(0),
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              opacity: 0.3,
                              image: CachedNetworkImageProvider(
                                'https://image.tmdb.org/t/p/w500/${widget.data.backdropPath}',
                              )
                            )
                          ),
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                child: MovieInfo(data: widget.data, detail: dp.movie!)
                              )
                            ),
                          ),
                        ),
                        DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              TabBar(
                                indicator: UnderlineTabIndicator(
                                  borderSide: BorderSide(color: primaryColor),
                                  insets: const EdgeInsets.only(bottom: 45),
                                ),
                                tabs: const [
                                  Tab(text: 'Trailers & More'),
                                  Tab(text: 'Collections')
                                ],
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: TabBarView(
                                  children: [
                                    TrailerSection(data: dp.movie!),
                                    MediaSection(data: dp.movie!),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    MovieDetailHeader(data: widget.data)
                  ],
                );
              }
            }
          );
        }
      ),
    );
  }
}