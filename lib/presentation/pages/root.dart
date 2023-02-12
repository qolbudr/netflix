import 'package:flutter/material.dart';
import 'package:netflix/presentation/pages/home.dart';
import 'package:netflix/presentation/pages/search.dart';
import 'package:remixicon/remixicon.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _index = 0;

  final List<Widget> _body = [
    const Home(),
    const Search(),
    const SizedBox(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body[_index],
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
          BottomNavigationBarItem(
            icon: Icon(Remix.home_2_line),
            label: "Home"   
          ),
          BottomNavigationBarItem(
            icon: Icon(Remix.search_2_line),
            label: "Search"
          ),
          BottomNavigationBarItem(
            icon: Icon(Remix.menu_line),
            label: "More"
          )
        ],
      ),
    );
  }
}