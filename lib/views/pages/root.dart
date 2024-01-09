import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netflix/constant.dart';
import 'package:netflix/controllers/home_controller.dart';
import 'package:netflix/views/pages/home.dart';
import 'package:netflix/views/pages/profile.dart';
import 'package:netflix/views/pages/search.dart';
import 'package:remixicon/remixicon.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final HomeController _c = Get.put(HomeController());
  int _index = 0;
  double _opacity = 0;
  bool _isShowGenre = false;

  void _closeGenre() async {
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 25));
      setState(() {
        _opacity -= 0.2;
      });
    }

    setState(() {
      _isShowGenre = false;
    });
  }

  void _openGenre() async {
    setState(() {
      _isShowGenre = true;
    });

    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 25));
      setState(() {
        _opacity += 0.2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> body = [Home(openGenre: _openGenre), const Search(), const Profile()];

    return Stack(
      children: [
        Scaffold(
          body: body[_index],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _index,
            onTap: (index) {
              setState(() => _index = index);
            },
            selectedFontSize: 10,
            unselectedFontSize: 10,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.5),
            backgroundColor: Colors.black,
            items: const [
              BottomNavigationBarItem(icon: Icon(Remix.home_2_line), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Remix.search_2_line), label: "Search"),
              BottomNavigationBarItem(icon: Icon(Remix.menu_line), label: "More")
            ],
          ),
        ),
        if (_isShowGenre) ...[
          Scaffold(
            backgroundColor: Colors.transparent,
            body: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: _opacity * 30, sigmaY: _opacity * 30),
              child: Opacity(
                opacity: _opacity,
                child: Stack(
                  children: [
                    ListView.separated(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 100),
                      separatorBuilder: (context, index) => const SizedBox(height: 35),
                      itemCount: genre.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _c.setCategory(genre[index]);
                            _closeGenre();
                          },
                          child: Text(
                            genre[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.8)),
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(margin: const EdgeInsets.only(bottom: 20), child: GestureDetector(onTap: _closeGenre, child: const Icon(Remix.close_circle_fill, size: 65))),
                    )
                  ],
                ),
              ),
            ),
          )
        ]
      ],
    );
  }
}
