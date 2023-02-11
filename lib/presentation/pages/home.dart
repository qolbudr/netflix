import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/home_model.dart';
import 'package:netflix/presentation/provider/home_provider.dart';
import 'package:netflix/presentation/widget/genre_separator.dart';
import 'package:netflix/presentation/widget/section_home.dart';
import 'package:netflix/presentation/widget/section_shop.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _scrollOffset = 0;
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HomeProvider>(context, listen: false).getData();
    });
    _scrollController.addListener(_onScroll);
  }
  

  void _onScroll() {
    setState(() {
      if(_scrollController.offset <= 140) {
        _scrollOffset = _scrollController.offset;
      } else {
        _scrollOffset = 140;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<HomeProvider>(
        builder: (_, hp, __) {
          if(hp.isLoading == true) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            HomeModel data = hp.data!;
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
                          Image.network(
                            'https://image.tmdb.org/t/p/w500/${data.banner!.posterPath}',
                            width: double.infinity,
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black,
                                    Colors.transparent
                                  ]
                                )
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          data.banner!.name!, 
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 32),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(data.banner!.genre!.length, (index) => 
                                            Row(
                                              children: [
                                                Text(data.banner!.genre![index]),
                                                if(index != data.banner!.genre!.length - 1)
                                                const GenreSeparator(),
                                              ],
                                            )
                                          )
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {}, 
                                                  child: const Icon(Icons.add_outlined)
                                                ),
                                                const Text("My List")
                                              ],
                                            ),
                                            const SizedBox(width: 25),
                                            ElevatedButton(
                                              onPressed: () {}, 
                                              style: primaryButton,
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.play_arrow),
                                                  Text("Play")
                                                ]
                                              )
                                            ),
                                            const SizedBox(width: 25),
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {}, 
                                                  child: const Icon(Icons.info_outline)
                                                ),
                                                const Text("Info")
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                      SectionHome(data: data.action!, title: 'Action'),
                      const SectionShop(),
                      SectionHome(data: data.romance!, title: 'Romance'),
                      SectionHome(data: data.series!, title: 'Series'),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          Colors.black.withOpacity(_scrollOffset / 145)
                        ]
                      )
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.only(left:15, top:40, bottom: 0, right: 25),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/netflix_logo.png', width: 15,),
                            const Spacer(),
                            const Icon(Icons.cast),
                            const SizedBox(width: 15,),
                            Image.asset('assets/images/user.png', width: 25,),
                          ],
                        ),
                        SizedBox(
                          height: 60 - (40 * _scrollOffset/140),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("TV Shows"),
                                Text("Movies"),
                                Text("Categories"),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ),
              ],
            );
          }
        }
      ),
    );
  }
}