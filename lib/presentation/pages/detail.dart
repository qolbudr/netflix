import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/home_model.dart';
import 'package:netflix/data/model/movie_detail_model.dart';
import 'package:netflix/presentation/provider/detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 80),
                                    CachedNetworkImage(
                                      imageUrl: 'https://image.tmdb.org/t/p/w200/${widget.data.posterPath}',
                                      width: 120,
                                      placeholder: (_, url) => AspectRatio(
                                        aspectRatio: 0.71,
                                        child: Container(
                                          width: 120,
                                          color: bgColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${widget.data.voteCount} Vote',
                                          style: const TextStyle(color: Color(0xff46D267)),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          widget.data.firstAirDate == null ? 'N/A' : widget.data.firstAirDate.toString().substring(0, 4),
                                          style: TextStyle(color: Colors.white.withOpacity(0.4)),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          widget.data.quality ?? 'N/A',
                                          style: TextStyle(color: Colors.white.withOpacity(0.4)),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          widget.data.runtime == null ? 'N/A' : widget.data.runtime.toString(),
                                          style: TextStyle(color: Colors.white.withOpacity(0.4)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    ElevatedButton(
                                      style: defaultButton,
                                      onPressed: () {}, 
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Remix.play_fill),
                                          SizedBox(width: 10),
                                          Text("Play")
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(widget.data.overview!, maxLines: 3),
                                    const SizedBox(height: 15),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Builder(
                                        builder: (_) {
                                          List<Cast> cast = dp.movie!.credits!.cast!.where((item) => item.knownForDepartment == "Acting").toList().sublist(0, 3);
                                          List casts = [];
                                          for(Cast item in cast) {
                                            casts.add(item.name);
                                          }
                                          return Text(casts.join(', '), style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4)));
                                        }
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {}, 
                                              child: const Icon(Icons.add_outlined)
                                            ),
                                            Text("My List", style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4)))
                                          ],
                                        ),
                                        const SizedBox(width: 30),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {}, 
                                              child: const Icon(Remix.thumb_up_line)
                                            ),
                                            Text("Rate", style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4)))
                                          ],
                                        ),
                                        const SizedBox(width: 30),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {}, 
                                              child: const Icon(Remix.upload_2_line)
                                            ),
                                            Text("Share", style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4)))
                                          ],
                                        ),
                                      ],
                                    ),  
                                    const SizedBox(height: 15),
                                  ],
                                ),
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
                                    ListView.builder(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      itemCount: dp.movie!.videos!.results!.length,
                                      itemBuilder: (context, index) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: 'https://img.youtube.com/vi/${dp.movie!.videos!.results![index].key!}/mqdefault.jpg',
                                          ),
                                          const SizedBox(height: 15),
                                          Text(dp.movie!.videos!.results![index].name!),
                                          const SizedBox(height: 30),
                                        ],
                                      ),

                                    ),
                                    ListView(
                                      padding: const EdgeInsets.all(0),
                                      children: [
                                        GridView.count(
                                          padding: const EdgeInsets.all(0),
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          crossAxisCount: 2,
                                          childAspectRatio: 16/9,
                                          children: List.generate(dp.movie!.images!.backdrops!.length, (index) => 
                                            CachedNetworkImage(
                                              imageUrl: 'https://image.tmdb.org/t/p/w200/${dp.movie!.images!.backdrops![index].filePath!}'
                                            )
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: bgColor,
                      padding: const EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      height: 80,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              margin: const EdgeInsets.only(right: 15),
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.2)
                              ),
                              child: const Icon(Remix.close_line, size: 17)
                            ),
                          ),
                          Opacity(
                            opacity: 1,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: 200,
                                child: Text(
                                  widget.data.title ?? widget.data.name!,
                                  style: const TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
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