import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:netflix/constant.dart';
import 'package:netflix/controllers/home_controller.dart';
import 'package:netflix/models/home_model.dart';
import 'package:netflix/models/tmdb_model.dart';
import 'package:netflix/views/widget/card_movie.dart';
import 'package:netflix/views/widget/genre_separator.dart';
import 'package:netflix/views/widget/section_home.dart';
import 'package:netflix/views/widget/section_shop.dart';
import 'package:remixicon/remixicon.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.openGenre});
  final Function() openGenre;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController _c = Get.put(HomeController());
  double _scrollOffset = 0;
  int page = 1;
  final _scrollController = ScrollController();
  final _scrollControllerGenre = ScrollController();

  @override
  void initState() {
    super.initState();
    _c.getData();
    _scrollController.addListener(_onScroll);
    _scrollControllerGenre.addListener(_onScrollGenre);
  }

  void _onScroll() {
    setState(() {
      if (_scrollController.offset <= 140) {
        _scrollOffset = _scrollController.offset;
      } else {
        _scrollOffset = 140;
      }
    });
  }

  void _onScrollGenre() {
    setState(() {
      if (_scrollControllerGenre.offset <= 140) {
        _scrollOffset = _scrollControllerGenre.offset;
      } else {
        _scrollOffset = 140;
      }
    });

    if (_scrollControllerGenre.position.atEdge && _scrollControllerGenre.offset != 0) {
      setState(() {
        page++;
      });

      _c.getCategory(page);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollControllerGenre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
          builder: (context) {
            if (_c.category == null) {
              if (_c.status.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                HomeModel data = _c.data!;
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(0),
                        children: [
                          Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/w500/${data.banner?.posterPath}',
                                placeholder: (_, url) => AspectRatio(
                                  aspectRatio: 0.67,
                                  child: Container(
                                    width: double.infinity,
                                    color: bgColor,
                                  ),
                                ),
                                width: double.infinity,
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black, Colors.transparent])),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              data.banner?.name ?? '-',
                                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 32),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: List.generate(
                                                data.banner?.genres?.length ?? 0,
                                                (index) => Row(
                                                  children: [
                                                    Text(data.banner?.genres?[index].name ?? '-'),
                                                    if (index != data.banner!.genres!.length - 1) const GenreSeparator(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [GestureDetector(onTap: () {}, child: const Icon(Icons.add_outlined)), const Text("My List")],
                                                ),
                                                const SizedBox(width: 25),
                                                ElevatedButton(
                                                  onPressed: () => Get.toNamed('/detail', arguments: data.banner),
                                                  style: primaryButton,
                                                  child: const Row(
                                                    children: [
                                                      Icon(Icons.play_arrow),
                                                      Text("Play"),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 25),
                                                Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: const Icon(Icons.info_outline),
                                                    ),
                                                    const Text("Info"),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SectionHome(data: data.trendingMovies!, title: 'Trending Movie'),
                          const SectionShop(),
                          SectionHome(data: data.trendingTv!, title: 'Trending Series'),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration:
                            BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black, Colors.black.withOpacity(_scrollOffset / 145)])),
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 15, top: 40, bottom: 0, right: 25),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/netflix_logo.png',
                                  width: 15,
                                ),
                                const Spacer(),
                                const Icon(Icons.cast),
                                const SizedBox(
                                  width: 15,
                                ),
                                Image.asset(
                                  'assets/images/user.png',
                                  width: 25,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 60 - (40 * _scrollOffset / 140),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("TV Shows"),
                                    const Text("Movies"),
                                    InkWell(
                                      onTap: () => widget.openGenre(),
                                      child: Row(
                                        children: [
                                          Text(_c.category ?? 'Categories'),
                                          const SizedBox(width: 5),
                                          Opacity(opacity: 1 - (_scrollOffset / 140), child: const Icon(Remix.arrow_down_s_line)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            } else {
              if (_c.status.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                List<Tmdb> data = _c.movies;
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ListView(
                        controller: _scrollControllerGenre,
                        padding: const EdgeInsets.all(0),
                        children: [
                          Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/w500/${data.first.posterPath}',
                                placeholder: (_, url) => AspectRatio(
                                  aspectRatio: 0.67,
                                  child: Container(
                                    width: double.infinity,
                                    color: bgColor,
                                  ),
                                ),
                                width: double.infinity,
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black, Colors.transparent])),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              data.first.name ?? '--',
                                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 32),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: List.generate(
                                                data.first.genres?.length ?? 0,
                                                (index) => Row(
                                                  children: [
                                                    Text(data.first.genres![index].name!),
                                                    if (index != data.first.genres!.length - 1) const GenreSeparator(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [GestureDetector(onTap: () {}, child: const Icon(Icons.add_outlined)), const Text("My List")],
                                                ),
                                                const SizedBox(width: 25),
                                                ElevatedButton(
                                                  onPressed: () => Get.toNamed('/detail', arguments: data.first),
                                                  style: primaryButton,
                                                  child: const Row(
                                                    children: [
                                                      Icon(Icons.play_arrow),
                                                      Text("Play"),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 25),
                                                Column(
                                                  children: [GestureDetector(onTap: () {}, child: const Icon(Icons.info_outline)), const Text("Info")],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(_c.category!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 15),
                                Builder(builder: (context) {
                                  List<Tmdb> display = _c.movies.sublist(1, _c.movies.length);
                                  return GridView.count(
                                    // controller: _search,
                                    padding: const EdgeInsets.all(15),
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 5,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    crossAxisSpacing: 0,
                                    childAspectRatio: 9 / 13,
                                    children: List.generate(display.length, (index) {
                                      Tmdb movie = display[index];
                                      return CardMovie(movie: movie, noMargin: true);
                                    }),
                                  );
                                })
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black,
                                  Colors.black.withOpacity(_scrollOffset / 145),
                                ],
                              ),
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 15, top: 40, bottom: 0, right: 25),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/netflix_logo.png',
                                      width: 15,
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.cast),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Image.asset(
                                      'assets/images/user.png',
                                      width: 25,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 60 - (40 * _scrollOffset / 140),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("TV Shows"),
                                        const Text("Movies"),
                                        InkWell(
                                          onTap: () {
                                            widget.openGenre();
                                            setState(() {
                                              page = 1;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Text(_c.category ?? 'Categories'),
                                              const SizedBox(width: 5),
                                              Opacity(opacity: 1 - (_scrollOffset / 140), child: const Icon(Remix.arrow_down_s_line)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (_c.status.isLoading) LinearProgressIndicator(backgroundColor: bgColor, minHeight: 1)
                        ],
                      ),
                    ),
                  ],
                );
              }
            }
          },
        ),
      );
    
  }
}
