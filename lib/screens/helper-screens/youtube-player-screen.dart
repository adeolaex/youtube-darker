import 'package:youtubedarker/models/common/colors.dart';
import 'package:youtubedarker/models/common/widgets-service.dart';
import 'package:youtubedarker/models/user-lifecycle-models/ui-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

GlobalKey<YoutubePlayerScreenState> youtubeScreenKey = GlobalKey<YoutubePlayerScreenState>();

class YoutubePlayerScreen extends StatefulWidget {
  YoutubePlayerScreen({
    Key key,
    this.videoId,
    this.videoTitle,
    this.channelTitle,
    this.subscribeCount,
    this.channelProfilePictureUrl,
    this.videoThumbnail,
  }) : super(key: key);

  final String videoId;
  final String videoTitle;
  final String channelTitle;
  final String subscribeCount;
  final String channelProfilePictureUrl;
  final String videoThumbnail;

  @override
  YoutubePlayerScreenState createState() => YoutubePlayerScreenState();
}

class YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  // final Completer<WebViewController> completer = Completer<WebViewController>();
  @override
  void initState() {
    // youtubePlayerController = YoutubePlayerController(
    // initialVideoId: widget.videoId,
    // flags: YoutubePlayerFlags(
    //   mute: false,
    //   autoPlay: true,
    //   loop: true,
    //   forceHD: true,
    //   hideControls: false,
    // ),
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                brightness: Brightness.dark,
                backgroundColor: backgroundColor,
                snap: true,
                floating: true,
                pinned: true,
                centerTitle: true,
                forceElevated: true,
                elevation: 0.0,
                // title: Text(
                //   widget.channelTitle,
                //   style: TextStyle(color: textColor, fontSize: 20),
                // ),
                leading: CupertinoButton(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Icon(
                    Icons.arrow_back_sharp,
                    color: iconColor,
                  ),
                  onPressed: () {
                    WidgetService.screenPopper(context);
                    Provider.of<UIModel>(context, listen: false).insideHomeDeepLinkedScreen = false;
                  },
                ),
                actions: [
                  // CupertinoButton(
                  //   padding: EdgeInsets.only(right: 16.0),
                  //   child: Icon(
                  //     Icons.more_horiz_sharp,
                  //     color: Colors.white,
                  //   ),
                  //   onPressed: () {
                  //     Share.share(widget.videoId);
                  //   },
                  // ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    // Container(
                    //   height: 205,
                    //   child: InAppWebView(
                    //     initialUrl: 'https://youtubedarkerapi.web.app/',
                    //     initialOptions: InAppWebViewGroupOptions(
                    //       ios: IOSInAppWebViewOptions(
                    //         allowsAirPlayForMediaPlayback: true,
                    //         allowsPictureInPictureMediaPlayback: true,
                    //         allowsInlineMediaPlayback: true,
                    //       ),
                    //       crossPlatform: InAppWebViewOptions(
                    //         debuggingEnabled: true,
                    //       ),
                    //     ),
                    //     // javascriptMode: JavascriptMode.unrestricted,
                    //     // onWebViewCreated: (WebViewController controller) {
                    //     //   completer.complete(controller);
                    //     // },
                    //   ),
                    // ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: CircleAvatar(
                            backgroundColor: backgroundColor,
                            backgroundImage: NetworkImage(widget.channelProfilePictureUrl),
                            radius: 17,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                widget.channelTitle,
                                style: TextStyle(color: textColor, fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 2),
                              child: Text(
                                widget.subscribeCount.replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},") + ' subscribers',
                                style: TextStyle(
                                  color: iconColor,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 64.0, top: 15.0, right: 28.0),
                      child: Container(
                        width: MediaQuery.of(context).size.height,
                        height: 30,
                        child: Marquee(
                          text: widget.videoTitle,
                          style: TextStyle(color: iconColor, fontSize: 15),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 50.0.toDouble(),
                          velocity: 12.0,
                          fadingEdgeEndFraction: 0.1,
                          fadingEdgeStartFraction: 0.1,
                          // startAfter: Duration(milliseconds: 1000),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
