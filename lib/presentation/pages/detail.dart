import 'dart:ui';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:netflix/constant.dart';
import 'package:netflix/data/model/home_model.dart';
import 'package:netflix/presentation/provider/detail_provider.dart';
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
  String _subtitleURL = '';
  InAppWebViewController? _webViewController;
  String? iframe;
  
  final adUrlFilters = [
    ".*.doubleclick.net/.*",
    ".*.ads.pubmatic.com/.*",
    ".*.googlesyndication.com/.*",
    ".*.google-analytics.com/.*",
    ".*.adservice.google.*/.*",
    ".*.adbrite.com/.*",
    ".*.exponential.com/.*",
    ".*.quantserve.com/.*",
    ".*.scorecardresearch.com/.*",
    ".*.phvhidwoetcbtno.com/.*",
    ".*.adsafeprotected.com/.*",
    ".*.glersaker.com/.*",
    ".*.dtscout.com/.*"
    ".*.123movies.tw/.*",
    ".*.19turanosephantasia.com/.*",
    ".*.1cloudfile.com/.*",
    ".*.20demidistance9elongations.com/.*",
    ".*.745mingiestblissfully.com/.*",
    ".*.9xmovies.app/.*",
    ".*.9xupload.asia/.*",
    ".*.adblockeronstape.me/.*",
    ".*.adblockeronstreamtape.me/.*",
    ".*.adblockeronstrtape.xyz/.*",
    ".*.adblockplustape.xyz/.*",
    ".*.adblockstreamtape.art/.*",
    ".*.adblockstreamtape.fr/.*",
    ".*.adblockstreamtape.site/.*",
    ".*.adblocktape.store/.*",
    ".*.adblocktape.wiki/.*",
    ".*.allsport.icu/.*",
    ".*.allsports.icu/.*",
    ".*.animepl.xyz/.*",
    ".*.aotonline.co/.*",
    ".*.asianstream.pro/.*",
    ".*.audaciousdefaulthouse.com/.*",
    ".*.bowfile.com/.*",
    ".*.capodeportes.fr/.*",
    ".*.cast4u.xyz/.*",
    ".*.clicknupload.to/.*",
    ".*.cloudvideo.tv/.*",
    ".*.coloredmanga.com/.*",
    ".*.cr7sports.us/.*",
    ".*.crackstreamshd.click/.*",
    ".*.cut-y.net/.*",
    ".*.daddyhd.com/.*",
    ".*.daddylive.click/.*",
    ".*.daddylive.fun/.*",
    ".*.dailyuploads.net/.*",
    ".*.deltabit.co/.*",
    ".*.dood.la/.*",
    ".*.dood.pm/.*",
    ".*.dood.re/.*",
    ".*.dood.sh/.*",
    ".*.dood.so/.*",
    ".*.dood.to/.*",
    ".*.dood.watch/.*",
    ".*.dood.wf/.*",
    ".*.dood.ws/.*",
    ".*.dood.yt/.*",
    ".*.dramacool.sr/.*",
    ".*.drivebuzz.icu/.*",
    ".*.dslayeronline.com/.*",
    ".*.dulu.to/.*",
    ".*.dum.to/.*",
    ".*.embedplayer.site/.*",
    ".*.embedsb.com/.*",
    ".*.embedsito.com/.*",
    ".*.embedstream.me/.*",
    ".*.enjoy4k.xyz/.*",
    ".*.eplayvid.net/.*",
    ".*.evoload.io/.*",
    ".*.f123movies.com/.*",
    ".*.fembed-hd.com/.*",
    ".*.fileclub.cyou/.*",
    ".*.filemoon.sx/.*",
    ".*.files.im/.*",
    ".*.filmy4wap.ink/.*",
    ".*.flashx.net/.*",
    ".*.flexy.stream/.*",
    ".*.fmovies.ps/.*",
    ".*.footyhunter3.xyz/.*",
    ".*.gameshdlive.xyz/.*",
    ".*.gamovideo.com/.*",
    ".*.gaybeeg.info/.*",
    ".*.givemenbastreams.com/.*",
    ".*.gogoanimes.org/.*",
    ".*.gogohd.net/.*",
    ".*.gogoplay.io/.*",
    ".*.gogoplay4.com/.*",
    ".*.goload.io/.*",
    ".*.gomo.to/.*",
    ".*.goodstream.org/.*",
    ".*.greaseball6eventual20.com/.*",
    ".*.hdfilme.cx/.*",
    ".*.hdtoday.ru/.*",
    ".*.hexupload.net/.*",
    ".*.housecardsummerbutton.com/.*",
    ".*.hurawatch.at/.*",
    ".*.ive.zone/.*",
    ".*.kesini.in/.*",
    ".*.kickassanime.ro/.*",
    ".*.kickasstorrents.to/.*",
    ".*.klubsports.click/.*",
    ".*.letsupload.io/.*",
    ".*.linkhub.icu/.*",
    ".*.linksafe.cc/.*",
    ".*.livetvon.click/.*",
    ".*.luxubu.review/.*",
    ".*.mangareader.cc/.*",
    ".*.mangareader.to/.*",
    ".*.mangovideo.pw/.*",
    ".*.maxsport.one/.*",
    ".*.meomeo.pw/.*",
    ".*.mirrorace.org/.*",
    ".*.mixdrop.bz/.*",
    ".*.mixdrop.ch/.*",
    ".*.mixdrop.click/.*",
    ".*.mixdrop.club/.*",
    ".*.mixdrop.co/.*",
    ".*.mixdrop.sx/.*",
    ".*.mixdrop.to/.*",
    ".*.mixdrops.xyz/.*",
    ".*.movies2watch.tv/.*",
    ".*.mp4upload.com/.*",
    ".*.mreader.co/.*",
    ".*.mycast.icu/.*",
    ".*.myoplay.club/.*",
    ".*.mystream.to/.*",
    ".*.nelion.me/.*",
    ".*.nocensor.biz/.*",
    ".*.ovagames.com/.*",
    ".*.owodeuwu.xyz/.*",
    ".*.pahaplayers.click/.*",
    ".*.papahd.club/.*",
    ".*.pcgamestorrents.com/.*",
    ".*.playtube.ws/.*",
    ".*.pouvideo.cc/.*",
    ".*.projectfreetv2.com/.*",
    ".*.proxyer.org/.*",
    ".*.puresoul.live/.*",
    ".*.putlocker-website.com/.*",
    ".*.putlockers.gs/.*",
    ".*.putlockertv.one/.*",
    ".*.radamel.icu/.*",
    ".*.reputationsheriffkennethsand.com/.*",
    ".*.rojadirecta.watch/.*",
    ".*.sbthe.com/.*",
    ".*.scloud.online/.*",
    ".*.send.cm/.*",
    ".*.sflix.to/.*",
    ".*.shavetape.cash/.*",
    ".*.shortlinkto.icu/.*",
    ".*.skidrowcodex.net/.*",
    ".*.smallencode.me/.*",
    ".*.soccerstreamslive.co/.*",
    ".*.sportshighlights.club/.*",
    ".*.stapadblockuser.art/.*",
    ".*.stapadblockuser.click/.*",
    ".*.stapadblockuser.info/.*",
    ".*.stape.fun/.*",
    ".*.stapewithadblock.beauty/.*",
    ".*.stapewithadblock.monster/.*",
    ".*.stapewithadblock.xyz/.*",
    ".*.stayonline.pro/.*",
    ".*.strcloud.in/.*",
    ".*.streamingsite.net/.*",
    ".*.streamlare.com/.*",
    ".*.streamsport.icu/.*",
    ".*.streamta.pe/.*",
    ".*.streamta.site/.*",
    ".*.streamtape.com/.*",
    ".*.streamtape.to/.*",
    ".*.streamtapeadblock.art/.*",
    ".*.streamtapeadblockuser.art/.*",
    ".*.streamtapeadblockuser.homes/.*",
    ".*.streamtapeadblockuser.monster/.*",
    ".*.streamtapeadblockuser.xyz/.*",
    ".*.streamz.ws/.*",
    ".*.streamzz.to/.*",
    ".*.strikeout.cc/.*",
    ".*.strtape.cloud/.*",
    ".*.strtape.tech/.*",
    ".*.strtapeadblock.club/.*",
    ".*.strtapeadblocker.xyz/.*",
    ".*.strtapewithadblock.art/.*",
    ".*.strtapewithadblock.xyz/.*",
    ".*.superstream123.net/.*",
    ".*.supervideo.tv/.*",
    ".*.techmyntra.net/.*",
    ".*.telerium.icu/.*",
    ".*.telyn610zoanthropy.com/.*",
    ".*.thepiratebay0.org/.*",
    ".*.theproxy.ws/.*",
    ".*.thevideome.com/.*",
    ".*.toxitabellaeatrebates306.com/.*",
    ".*.un-block-voe.net/.*",
    ".*.upbam.org/.*",
    ".*.uplinkto.one/.*",
    ".*.upload-4ever.com/.*",
    ".*.uproxy.to/.*",
    ".*.upstream.to/.*",
    ".*.uptobhai.com/.*",
    ".*.uqload.com/.*",
    ".*.userload.co/.*",
    ".*.userload.xyz/.*",
    ".*.userscloud.com/.*",
    ".*.v-o-e-unblock.com/.*",
    ".*.vanfem.com/.*",
    ".*.vidbam.org/.*",
    ".*.vidcloud.click/.*",
    ".*.vidembed.me/.*",
    ".*.videovard.sx/.*",
    ".*.vidlox.me/.*",
    ".*.vido.lol/.*",
    ".*.vidshar.org/.*",
    ".*.vidsrc.me/.*",
    ".*.vidsrc.stream/.*",
    ".*.vidz7.com/.*",
    ".*.vipleague.im/.*",
    ".*.vipleague.tv/.*",
    ".*.vivo.sx/.*",
    ".*.voe-un-block.com/.*",
    ".*.voe-unblock.com/.*",
    ".*.voe-unblock.net/.*",
    ".*.voe.bar/.*",
    ".*.voe.sx/.*",
    ".*.voeun-block.net/.*",
    ".*.voeunbl0ck.com/.*",
    ".*.voeunblck.com/.*",
    ".*.voeunblk.com/.*",
    ".*.voeunblock.com/.*",
    ".*.voeunblock1.com/.*",
    ".*.voeunblock2.com/.*",
    ".*.voeunblock3.com/.*",
    ".*.vostfree.online/.*",
    ".*.vudeo.io/.*",
    ".*.vudeo.net/.*",
    ".*.vumoo.to/.*",
    ".*.watch-free.tv/.*",
    ".*.watchkobe.info/.*",
    ".*.watchserieshd.live/.*",
    ".*.wowlive.info/.*",
    ".*.yesmovies.mn/.*",
    ".*.yodbox.com/.*",
    ".*.youtube4kdownloader.com/.*",
    ".*.zoro.to/.*",
  ];

  final List<ContentBlocker> contentBlockers = [];


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DetailProvider>(context, listen: false).getMovieDetail(widget.data.id!, widget.data.mediaType!);
      if(widget.data.mediaType! == 'tv') {
        Provider.of<DetailProvider>(context, listen: false).getEpisode(widget.data.id!, widget.data.season!);
      }
    });

    for (final adUrlFilter in adUrlFilters) {
      contentBlockers.add(ContentBlocker(
          trigger: ContentBlockerTrigger(
            urlFilter: adUrlFilter,
          ),
          action: ContentBlockerAction(
            type: ContentBlockerActionType.BLOCK,
          ),
        ),
      );
    }
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

      if(subtitle != null) {
        _webViewController!.loadUrl(urlRequest: URLRequest(url: Uri.parse('$url!&subtitle=$subtitle')));
      } else {
        _webViewController!.loadUrl(urlRequest: URLRequest(url: Uri.parse(url)));
      }
  }

  Future<void> _showSubtitle() {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return IntrinsicHeight(
          child: SizedBox(
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
                  child: Text("Custom Subtitle", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Subtitle URL"),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 38,
                        child: TextFormField(
                          autofocus: true,
                          onChanged: (value) {
                            setState(() {
                              _subtitleURL = value;
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                            border: const OutlineInputBorder(borderSide: BorderSide.none),
                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            disabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            filled: true,
                            hintText: "https://subscene.com/subtitles/wednesday-first-season/indonesian/2967105",
                            fillColor: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _play(_url!, subtitle: _subtitleURL);
                        },
                        style: defaultButton,
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Remix.play_fill),
                          SizedBox(width: 10),
                          Text("Play")
                        ],
                      ),
                      )
                    ],
                  ),
                ),
                Padding(padding: MediaQuery.of(context).viewInsets),
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DetailProvider>(
        builder: (_, dp, __) {
          if((dp.isLoading == true && widget.data.mediaType! == 'movie') || (widget.data.mediaType! == 'tv' && dp.isLoading == true && dp.episodeLoading == true)) {
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
                                              initialOptions: InAppWebViewGroupOptions(
                                                crossPlatform: InAppWebViewOptions(
                                                supportZoom: false,
                                                javaScriptEnabled: true,
                                                contentBlockers: contentBlockers
                                              )),
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
                                if(widget.data.mediaType == 'tv')
                                  EpisodeSection(data: widget.data, episodes: dp.episode!, play: _play),
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
                MovieDetailHeader(
                  data: widget.data, 
                  displaySub: (_url?.contains('gdriveplayer') ?? false),
                  onTap: _showSubtitle
                ),
              ],
            );
          }
        }
      ),
    );
  }
}