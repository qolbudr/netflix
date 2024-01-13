import 'dart:ui';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:netflix/constant.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:netflix/controllers/detail_controller.dart';
import 'package:netflix/controllers/services/api_services.dart';
import 'package:netflix/models/source_model.dart';
import 'package:netflix/models/tmdb_model.dart';
import 'package:netflix/views/pages/player.dart';
import 'package:netflix/views/widget/episode_section.dart';
import 'package:netflix/views/widget/media_section.dart';
import 'package:netflix/views/widget/movie_detail_header.dart';
import 'package:netflix/views/widget/movie_info.dart';
import 'package:netflix/views/widget/movie_summary.dart';
import 'package:netflix/views/widget/trailer_section.dart';
import 'package:remixicon/remixicon.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final DetailController _c = Get.put(DetailController());
  final Tmdb data = Get.arguments;
  final ApiServices _apiServices = ApiServices();
  String? _url;
  InAppWebViewController? _webViewController;
  String? iframe;
  int season = 1;
  String? selectedPath;
  String selectedTile = 'english';
  bool subpathLoading = false;
  bool movieLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      Future.microtask(
        () {
          if (data.numberOfSeasons != null) {
            _c.getEpisode(data.id ?? 0, season);
          }

          _c.getSubtitlePath(data.externalIds?.imdbId ?? '');
        },
      );
    });
  }

  void _closePlayer() => setState(() => _url = null);

  void _play(String url, {String? subtitle}) {
    setState(() => _url = url);

    if (subtitle != null) {
      _webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    } else {
      _webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    }
  }

  void _playMovie({int? episode}) async {
    setState(() => movieLoading = true);
    PlayerArgument argument;
    List<SourceModel>? response;

    if (data.numberOfSeasons != null) {
      response = await _apiServices.getSources(
        imdb: data.externalIds?.imdbId,
        season: season,
        episode: episode,
      );
    } else {
      response = await _apiServices.getSources(imdb: data.externalIds?.imdbId);
    }

    if (response.isNotEmpty) {
      argument = PlayerArgument(url: response.first.file!, subtitle: _c.subtitleRaw, movie: data);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
      if (mounted) Get.toNamed('/player', arguments: argument);
    }

    setState(() => movieLoading = false);
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
        return StatefulBuilder(
          builder: (context, sS) {
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
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Text("Custom Subtitle", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_c.subtitleDataStatus.isLoading) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 500,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                      )
                    ] else ...[
                      SizedBox(
                        height: 500,
                        child: ListView(
                          key: ValueKey('builder $selectedTile'),
                          children: [
                            ...(_c.subtitlePathModel?.entries ?? []).map((itemKeys) {
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
                                    ...(_c.subtitlePathModel?[itemKeys.key] ?? []).map((e) {
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
                                              await _c.getSubtitleRawData(data.externalIds?.imdbId ?? '', e.path ?? '');
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
                      ),
                    ],
                    const SizedBox(height: 10),
                    Padding(padding: MediaQuery.of(context).viewInsets),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<int?> _showSeason() {
    return showModalBottomSheet<int?>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text("Choose Season", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...(data.seasons ?? []).map(
                          (e) => Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                onTap: () {
                                  Get.back(result: e.seasonNumber);
                                },
                                title: Text(e.name ?? ''),
                              ),
                              Divider(height: 1, color: Colors.white.withOpacity(0.1)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(padding: MediaQuery.of(context).viewInsets),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: (data.numberOfSeasons != null && _c.episodeDataStatus.isLoading) || _c.subtitleDataStatus.isLoading
            ? Center(child: CircularProgressIndicator(color: primaryColor))
            : Stack(
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
                              'https://image.tmdb.org/t/p/w500/${data.backdropPath}',
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
                                              initialSettings: InAppWebViewSettings(javaScriptEnabled: true, supportZoom: true),
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
                                        child: MovieSummary(data: data, play: _playMovie, isLoading: movieLoading),
                                      );
                                    }
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: MovieInfo(data: data),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (data.numberOfSeasons != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            key: Key("Season $season"),
                            readOnly: true,
                            onTap: () async {
                              int? seasonNumber = await _showSeason();
                              if (seasonNumber != null) {
                                setState(() {
                                  season = seasonNumber;
                                });

                                await _c.getEpisode(data.id ?? 0, season);
                              }
                            },
                            initialValue: 'Season $season',
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.only(left: 15),
                              border: const OutlineInputBorder(borderSide: BorderSide.none),
                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                              disabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                              suffixIcon: const Icon(Remix.arrow_down_line),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      DefaultTabController(
                        length: data.numberOfSeasons != null ? 3 : 2,
                        child: Column(
                          children: [
                            TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(color: primaryColor, width: 2),
                                insets: const EdgeInsets.only(bottom: 45),
                              ),
                              tabs: [if (data.numberOfSeasons != null) const Tab(text: 'Episodes'), const Tab(text: 'Trailers & More'), const Tab(text: 'Collections')],
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 300,
                              child: TabBarView(
                                children: [
                                  if (data.numberOfSeasons != null) EpisodeSection(data: data, episodes: _c.episode, play: _playMovie),
                                  TrailerSection(data: data, play: _play),
                                  MediaSection(data: data),
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
                    data: data,
                    onTap: () async {
                      await _showSubtitle();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
