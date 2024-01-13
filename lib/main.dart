import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:netflix/constant.dart';
import 'package:netflix/views/pages/detail.dart';
import 'package:netflix/views/pages/player.dart';
import 'package:netflix/views/pages/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Netflix',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const SplashScreen(),
      getPages: [
        GetPage(name: '/root', page: () => const Root(), transition: Transition.cupertino),
        GetPage(name: '/detail', page: () => const Detail(), transition: Transition.cupertino),
        GetPage(name: '/player', page: () => const Player(), transition: Transition.cupertino),
      ],
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3500), () => Get.offAndToNamed('/root'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Lottie.asset(
          animate: true,
          'assets/lottie.json',
          width: 200,
        ),
      ),
    );
  }
}
