import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/home_model.dart';
import 'package:netflix/presentation/pages/detail.dart';
import 'package:netflix/presentation/pages/root.dart';
import 'package:netflix/injection.dart' as di;
import 'package:netflix/presentation/provider/detail_provider.dart';
import 'package:netflix/presentation/provider/home_provider.dart';
import 'package:netflix/presentation/provider/search_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.locator<HomeProvider>()),
        ChangeNotifierProvider(create: (_) => di.locator<DetailProvider>()),
        ChangeNotifierProvider(create: (_) => di.locator<SearchProvider>()),
      ],
      child: MaterialApp(
        title: 'Netflix',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: const SplashScreen(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/root':
              return CupertinoPageRoute(builder: (_) => const Root(), settings: const RouteSettings(name: '/root'));
            case '/detail':
              final Movie data = settings.arguments as Movie;
              return CupertinoPageRoute(builder: (_) => Detail(data: data), settings: const RouteSettings(name: '/detail'));
            
            default: 
              return CupertinoPageRoute(builder: (_) => const Root(), settings: const RouteSettings(name: '/root'));
          }
        }
      ),
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
    Future.delayed(
      const Duration(milliseconds: 3500),
      () => Navigator.pushReplacementNamed(context, '/root')
    );
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