import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/home_model.dart';
import 'package:netflix/presentation/provider/search_provider.dart';
import 'package:netflix/presentation/widget/card_movie.dart';
import 'package:netflix/presentation/widget/section_newest.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'dart:async';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _scroll = ScrollController();
  final _search = ScrollController();
  final _text = TextEditingController();
  bool _isSearch = false;
  final Map<String, dynamic> _searchBody = {'page': 1, 'title': ''};
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        Provider.of<SearchProvider>(context, listen: false).getNewest(false);
      }
    );
    _scroll.addListener(_fetchNewest);
    _search.addListener(_fetchSearch);
  }

  void _fetchNewest() {
		if(_scroll.position.atEdge && _scroll.offset != 0) {
      Future.microtask(
      () {
        Provider.of<SearchProvider>(context, listen: false).getNewest(true);
      }
    );
		}
	}

  void _fetchSearch() {
		if(_search.position.atEdge && _search.offset != 0) {
      setState(() {
        _searchBody['page']++;
      });

      Future.microtask(
        () {
          Provider.of<SearchProvider>(context, listen: false).getSearch(_searchBody);
        }
      );
		}
	}

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Builder(
              builder: (context) {
                if(_isSearch) {
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
                                        _searchBody['title'] = value;
                                        _searchBody['page'] = 1;
                                        Provider.of<SearchProvider>(context, listen: false).getSearch(_searchBody);
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
                                      child: const Icon(Remix.close_circle_fill)
                                    )
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
                              _searchBody['title'] = '';
                            });
                          },
                          child: const Text("Cancel")
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
                            const SizedBox(width: 5,),
                            Text('Search', style: TextStyle(color: Colors.white.withOpacity(0.3))),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
            ),
            Consumer<SearchProvider>(
              builder: (_, sp, __) {
                if(sp.isLoading && sp.newestPage == 1) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  if(_searchBody['title'] == '') {
                    return Expanded(
                      child: Stack(
                        children: [
                          ListView(
                            controller: _scroll,
                            padding: const EdgeInsets.all(15),
                            children: [
                              SectionNewest(data: sp.newest!),
                            ],
                          ),
                          if(sp.isLoading && sp.newestPage != 1)
                            LinearProgressIndicator(backgroundColor: bgColor, minHeight: 1)
                        ],
                      )
                    );
                  } else {
                    if(sp.isLoading && _searchBody['page'] == 1) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Stack(
                          children: [
                            GridView.count(
                              controller: _search,
                              padding: const EdgeInsets.all(15),
                              crossAxisCount: 3,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 0,
                              childAspectRatio: 9/13,
                              children: List.generate(
                                sp.search!.length, (index) {
                                  Movie movie = sp.search![index];
                                  return CardMovie(movie: movie, noMargin: true);
                                }
                              ),
                            ),
                            if(sp.isLoading && _searchBody['page'] != 1)
                              LinearProgressIndicator(backgroundColor: bgColor, minHeight: 1)
                          ],
                        ),
                      );
                    }
                  }
                }
              }
            )
          ],
        ),
      ),
    );
  }
}