import 'dart:ui';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/home_model.dart';
import 'package:netflix/presentation/provider/detail_provider.dart';
import 'package:netflix/presentation/widget/media_section.dart';
import 'package:netflix/presentation/widget/movie_detail_header.dart';
import 'package:netflix/presentation/widget/movie_info.dart';
import 'package:netflix/presentation/widget/movie_summary.dart';
import 'package:netflix/presentation/widget/trailer_section.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:remixicon/remixicon.dart';

class Detail extends StatefulWidget {
  const Detail({super.key, required this.data});
  final Movie data;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  String? _url;
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DetailProvider>(context, listen: false).getMovieDetail(widget.data.id!, widget.data.mediaType!);
    });
  }

  void _closePlayer() {
    setState(() {
      _url = null;
    });
  }

  void _play(String url) {
    setState(() {
      if(_url == null) {
        _url = url;
      } else {
        _webViewController!.loadUrl(urlRequest: URLRequest(url: Uri.parse(url)));
      }
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DetailProvider>(
        builder: (_, dp, __) {
          if(dp.isLoading == true) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(0),
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          opacity: 0.3,
                          image: CachedNetworkImageProvider(
                            'https://image.tmdb.org/t/p/w500/${widget.data.backdropPath}',
                          )
                        )
                      ),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                const SizedBox(height: 80),
                                Builder(
                                  builder: (context) {
                                    if(_url != null) {
                                      return Stack(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 16/10,
                                            child: InAppWebView(
                                              initialUrlRequest: URLRequest(url: Uri.parse(_url!)),
                                              onWebViewCreated: (controller) {
                                                _webViewController = controller;
                                              },
                                              onEnterFullscreen: (controller) {
                                                 AutoOrientation.landscapeAutoMode(); 
                                              },
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: _closePlayer,
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                margin: const EdgeInsets.only(top: 15, right: 15),
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white.withOpacity(0.2),
                                                ),
                                                child: const Center(
                                                  child: Icon(Remix.close_line, size: 12),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: MovieSummary(data: widget.data, play: _play),
                                      );
                                    }
                                  }
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: MovieInfo(data: widget.data, detail: dp.movie!),
                                ),
                              ],
                            )
                          )
                        ),
                      ),
                    ),
                    DefaultTabController(
                      length: widget.data.mediaType == 'tv' ? 3 : 2,
                      child: Column(
                        children: [
                          TabBar(
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(color: primaryColor, width: 2),
                              insets: const EdgeInsets.only(bottom: 45),
                            ),
                            tabs: [
                              if(widget.data.mediaType == 'tv')
                                const Tab(text: 'Episodes'),
                              const Tab(text: 'Trailers & More'),
                              const Tab(text: 'Collections')
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 300,
                            child: TabBarView(
                              children: [
                                TrailerSection(data: dp.movie!, play: _play),
                                TrailerSection(data: dp.movie!, play: _play),
                                MediaSection(data: dp.movie!),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                MovieDetailHeader(data: widget.data)
              ],
            );
          }
        }
      ),
    );
  }
}