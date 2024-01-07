import 'dart:ui';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:netflix/constant.dart';
import 'package:netflix/data/api.dart';
import 'package:netflix/data/model/movie_model.dart';
import 'package:netflix/presentation/provider/detail_provider.dart';
import 'package:netflix/presentation/pages/player.dart';
import 'package:netflix/presentation/widget/episode_section.dart';
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
  String? iframe;
  final getIt = GetIt.instance;
  int season = 1;
  String? selectedPath;
  String selectedTile = 'english';
  bool subpathLoading = false;
  bool movieLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      season = widget.data.season?.toInt() ?? 0;
    });
    Future.microtask(() {
      if (widget.data.series ?? false) {
        Provider.of<DetailProvider>(context, listen: false).getEpisode(widget.data.tmdb?.id ?? 0, season);
      }
      Provider.of<DetailProvider>(context, listen: false).getSubtitlePath(widget.data.tmdb?.externalIds?.imdbId ?? '');
    });
  }

  @override
  void deactivate() {
    if (mounted) Provider.of<DetailProvider>(context, listen: false).resetSubtitle();
    super.deactivate();
  }

  void _closePlayer() {
    setState(() {
      _url = null;
    });
  }

  void _play(String url, {String? subtitle}) {
    setState(() {
      _url = url;
    });

    if (subtitle != null) {
      _webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    } else {
      _webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    }
  }

  void _playMovie({int? episode}) async {
    setState(() => movieLoading = true);
    DetailProvider dp = Provider.of<DetailProvider>(context, listen: false);
    PlayerArgument argument;
    Map<String, dynamic>? response;

    if (widget.data.series ?? false) {
      response = await getIt<Api>().getPlayer(
        widget.data.link ?? '',
        episode?.toString(),
      );
    } else {
      response = await getIt<Api>().getPlayer(
        widget.data.link ?? '',
        null,
      );
    }

    argument = PlayerArgument(url: response['file'], subtitle: dp.subtitleRaw, movie: widget.data);
    setState(() => movieLoading = false);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    if (mounted) Navigator.pushNamed(context, '/player', arguments: argument);
  }

  Future<void> _showSubtitle() {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, sS) {
          return IntrinsicHeight(
            child: Container(
              color: bgColor,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Center(
                      child: Container(
                        width: 72,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Consumer<DetailProvider>(builder: (_, dp, __) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Text("Custom Subtitle", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  Consumer<DetailProvider>(
                    builder: (_, dp, __) {
                      if (dp.subtitleLoading == true) {
                        return SizedBox(
                          width: double.infinity,
                          height: 500,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 500,
                          child: ListView(
                            key: ValueKey('builder $selectedTile'),
                            children: [
                              ...(dp.subtitlePathModel?.entries ?? []).map((itemKeys) {
                                return Theme(
                                  data: themeData.copyWith(dividerColor: Colors.white.withOpacity(0.1)),
                                  child: ExpansionTile(
                                    textColor: primaryColor,
                                    collapsedTextColor: Colors.white,
                                    title: Text(itemKeys.key.toUpperCase()),
                                    initiallyExpanded: selectedTile == itemKeys.key.toLowerCase(),
                                    onExpansionChanged: (value) {
                                      setState(() {
                                        selectedTile = itemKeys.key.toLowerCase();
                                      });

                                      sS(() {});
                                    },
                                    children: [
                                      ...(dp.subtitlePathModel?[itemKeys.key] ?? []).map((e) {
                                        return Column(
                                          children: [
                                            Divider(height: 1, color: Colors.white.withOpacity(0.1)),
                                            ListTile(
                                              trailing: subpathLoading && selectedPath == e.name
                                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
                                                  : (selectedPath == e.name)
                                                      ? Icon(Remix.check_fill, color: primaryColor)
                                                      : null,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                              onTap: () async {
                                                sS(() {
                                                  subpathLoading = true;
                                                  selectedPath = e.name;
                                                });
                                                await dp.getSubtitleRawData(widget.data.tmdb?.externalIds?.imdbId ?? '', e.path ?? '');
                                                sS(() => subpathLoading = false);
                                              },
                                              title: Text(e.name ?? ''),
                                            ),
                                          ],
                                        );
                                      })
                                    ],
                                  ),
                                );
                              })
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Padding(padding: MediaQuery.of(context).viewInsets),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // Future<int?> _showSeason() {
  //   return showModalBottomSheet<int?>(
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(15),
  //         topRight: Radius.circular(15),
  //       ),
  //     ),
  //     context: context,
  //     builder: (BuildContext context) {
  //       return IntrinsicHeight(
  //         child: SizedBox(
  //           height: double.infinity,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
  //                 child: Center(
  //                   child: Container(
  //                     width: 72,
  //                     height: 5,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white.withOpacity(0.3),
  //                       borderRadius: BorderRadius.circular(30),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 5),
  //               const Padding(
  //                 padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
  //                 child: Text("Choose Season", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
  //               ),
  //               const SizedBox(height: 10),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   ...(widget.data.tmdb?.seasons ?? []).map(
  //                     (e) => Column(
  //                       children: [
  //                         ListTile(
  //                           contentPadding: const EdgeInsets.symmetric(horizontal: 20),
  //                           onTap: () {
  //                             Navigator.pop(context, e.seasonNumber);
  //                           },
  //                           title: Text(e.name ?? ''),
  //                         ),
  //                         const Divider(height: 1),
  //                       ],
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               const SizedBox(height: 10),
  //               Padding(padding: MediaQuery.of(context).viewInsets),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DetailProvider>(builder: (_, dp, __) {
        if (dp.episodeLoading == true) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
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
                          'https://image.tmdb.org/t/p/w500/${widget.data.tmdb?.backdropPath}',
                        ),
                      ),
                    ),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              const SizedBox(height: 80),
                              Builder(builder: (context) {
                                if (_url != null) {
                                  return Stack(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 16 / 10,
                                        child: InAppWebView(
                                          initialOptions: InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions(supportZoom: false, javaScriptEnabled: true)),
                                          initialUrlRequest: URLRequest(url: WebUri(_url!)),
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
                                    child: MovieSummary(data: widget.data, play: _playMovie, isLoading: movieLoading),
                                  );
                                }
                              }),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: MovieInfo(data: widget.data),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (widget.data.series ?? false)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        key: Key("Season $season"),
                        readOnly: true,
                        // onTap: () async {
                        //   int? seasonNumber = await _showSeason();
                        //   if (seasonNumber != null) {
                        //     setState(() {
                        //       season = seasonNumber;
                        //     });

                        //     await dp.getEpisode(widget.data.tmdb?.id ?? 0, season);
                        //   }
                        // },
                        initialValue: 'Season $season',
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.only(left: 15),
                          border: const OutlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          disabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          suffixIcon: const Icon(Remix.movie_2_fill),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  DefaultTabController(
                    length: widget.data.series ?? false ? 3 : 2,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(color: primaryColor, width: 2),
                            insets: const EdgeInsets.only(bottom: 45),
                          ),
                          tabs: [if (widget.data.series ?? false) const Tab(text: 'Episodes'), const Tab(text: 'Trailers & More'), const Tab(text: 'Collections')],
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: TabBarView(
                            children: [
                              if (widget.data.series ?? false) EpisodeSection(data: widget.data, episodes: dp.episode ?? [], play: _playMovie),
                              TrailerSection(data: widget.data, play: _play),
                              MediaSection(data: widget.data),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              MovieDetailHeader(
                enableSubtitle: selectedPath != null,
                data: widget.data,
                onTap: () async {
                  await _showSubtitle();
                },
              ),
            ],
          );
        }
      }),
    );
  }
}
