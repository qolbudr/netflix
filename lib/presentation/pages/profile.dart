import "package:flutter/material.dart";
import 'package:netflix/presentation/widget/menu_tile.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Netflix", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/user.png', width: 80),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.edit_outlined, color: Colors.white.withOpacity(0.5), size: 18),
                      const SizedBox(width: 5),
                      Text('Manage Profiles', style: TextStyle(color: Colors.white.withOpacity(0.5))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MenuTile(title: 'My List', icon: const Icon(Remix.check_line), onTap: () {}),
              MenuTile(
                title: 'Request Feature', icon: const Icon(Remix.apps_line),
                onTap: () async {
                  await launchUrl(
                    Uri.parse('https://github.com/qolbudr/netflix/issues'),
                    mode: LaunchMode.externalApplication
                  );
                },
              ),
              MenuTile(
                title: 'Report Bug', 
                icon: const Icon(Remix.bug_2_line),
                onTap: () async {
                  await launchUrl(
                    Uri.parse('https://github.com/qolbudr/netflix/issues'),
                    mode: LaunchMode.externalApplication
                  );
                },
              ),
              MenuTile(
                title: 'Check for Update', 
                icon: const Icon(Remix.arrow_up_circle_line),
                onTap: () async {
                  await launchUrl(
                    Uri.parse('https://github.com/qolbudr/netflix'),
                    mode: LaunchMode.externalApplication
                  );
                },
              ),
              const SizedBox(height: 20),
              Text('Version: 0.0.1(0008) 1.4.0-002', style: TextStyle(color: Colors.white.withOpacity(0.5)))
            ],
          )
        ],
      ),
    );
  }
}