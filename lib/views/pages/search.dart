import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:netflix/constant.dart';
import 'package:netflix/controllers/home_controller.dart';
import 'package:netflix/controllers/search_controller.dart' as base;
import 'package:netflix/models/tmdb_model.dart';
import 'package:netflix/views/widget/card_movie.dart';
import 'package:netflix/views/widget/section_newest.dart';
import 'package:remixicon/remixicon.dart';
import 'dart:async';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final base.SearchController _c = Get.put(base.SearchController());
  final HomeController _hc = Get.put(HomeController());

  final _search = ScrollController();
  final _text = TextEditingController();
  bool _isSearch = false;
  int page = 1;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _search.addListener(_fetchSearch);
  }

  void _fetchSearch() {
    if (_search.position.atEdge && _search.offset != 0) {
      setState(() {
        page++;
      });

      Future.microtask(() {
        _c.getSearch({'title': _text.text, 'page': page});
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Builder(builder: (context) {
                if (_isSearch) {
                  return Container(
                    color: bgColor,
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 38,
                            child: Stack(
                              children: [
                                TextFormField(
                                  controller: _text,
                                  autofocus: true,
                                  onChanged: (value) {
                                    setState(() {
                                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                                      _debounce = Timer(const Duration(milliseconds: 500), () {
                                        _c.getSearch({'title': _text.text, 'page': 1});
                                      });
                                    });
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.all(0),
                                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                                    disabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                                    prefixIcon: const Icon(Remix.search_2_line),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        _text.clear();
                                      },
                                      child: const Icon(Remix.close_circle_fill),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSearch = false;
                              _text.clear();
                            });
                          },
                          child: const Text("Cancel"),
                        )
                      ],
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () => setState(() {
                      _isSearch = true;
                    }),
                    child: Container(
                      color: bgColor,
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Remix.search_2_line, size: 14, color: Colors.white.withOpacity(0.3)),
                            const SizedBox(
                              width: 5,
                            ),
                            Text('Search', style: TextStyle(color: Colors.white.withOpacity(0.3))),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }),
              if (_hc.status.isLoading) ...[
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ] else ...[
                if (_text.text == '') ...[
                  Expanded(
                    child: Stack(
                      children: [
                        if (_hc.status.isLoading) ...[
                          Center(child: CircularProgressIndicator(color: primaryColor))
                        ] else ...[
                          ListView(
                            padding: const EdgeInsets.all(15),
                            children: [
                              SectionNewest(data: [..._hc.data?.trendingMovies ?? [], ..._hc.data?.trendingTv ?? []]),
                            ],
                          )
                        ],
                      ],
                    ),
                  ),
                ] else ...[
                  if (_c.status.isLoading && page == 1) ...[
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ] else ...[
                    Expanded(
                      child: Stack(
                        children: [
                          GridView.count(
                            controller: _search,
                            padding: const EdgeInsets.all(15),
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 0,
                            childAspectRatio: 9 / 13,
                            children: List.generate(_c.search.length, (index) {
                              Tmdb movie = _c.search[index].tmdb!;
                              return CardMovie(movie: movie, noMargin: true);
                            }),
                          ),
                          if (_c.status.isLoading && page != 1) LinearProgressIndicator(backgroundColor: bgColor, minHeight: 1)
                        ],
                      ),
                    ),
                  ]
                ]
              ]
            ],
          ),
        ),
      ),
    );
  }
}
