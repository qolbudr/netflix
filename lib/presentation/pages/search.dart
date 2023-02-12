import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/presentation/provider/search_provider.dart';
import 'package:netflix/presentation/widget/section_newest.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        Provider.of<SearchProvider>(context, listen: false).getNewest(false);
      }
    );
    _scroll.addListener(_fetchNewest);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: bgColor,
              padding: const EdgeInsets.all(15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white.withOpacity(0.1)
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
            Consumer<SearchProvider>(
              builder: (_, sp, __) {
                if(sp.isLoading && sp.newestPage == 1) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
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
                }
              }
            )
          ],
        ),
      ),
    );
  }
}