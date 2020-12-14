import 'dart:io';
import 'package:youtube_darker/models/common/colors.dart';
import 'package:youtube_darker/models/common/widgets-service.dart';
import 'package:youtube_darker/models/user-lifecycle-models/ui-model.dart';
import 'package:youtube_darker/models/youtube-api-models/youtube-feed-model.dart';
import 'package:youtube_darker/services/api-service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../helper-screens/youtube-player-screen.dart';
import '../helper-screens/search-screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  ScrollController scrollController;

  RefreshController refreshController = RefreshController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Map _connectivitySource = {ConnectivityResult.none: false};

  MyConnectivity myConnectivity = MyConnectivity.myConnectivity;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    scrollController.addListener(
      () {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          if (int.parse(Provider.of<YoutubeFeedModel>(context, listen: false).channel.videoCount) != Provider.of<YoutubeFeedModel>(context, listen: false).channel.videos.length) {
            Provider.of<YoutubeFeedModel>(context, listen: false).loadMoreVideos();
            // if (_connectivitySource.values.toList()[0] == true) {}
          }
        }
      },
    );
    myConnectivity.initialise();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        myConnectivity.myStream.listen(
          (event) {
            setState(() => _connectivitySource = event);
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) {
                switch (_connectivitySource.values.toList()[0]) {
                  case false:
                    WidgetService.hideSnackbar(scaffoldKey);
                    WidgetService.showConnectionSnackbar('Currently offline', scaffoldKey);
                    break;
                  case true:
                    scaffoldKey.currentState.hideCurrentSnackBar();
                    break;
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    myConnectivity.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<YoutubeFeedModel, UIModel>(
      builder: (context, youtubeFeedModel, uiModel, child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          // backgroundColor: Color(0xff0c0c0c),
          resizeToAvoidBottomInset: false,
          key: scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: backgroundColor,
            centerTitle: true,
            elevation: 0.0,
            title: Text(
              '',
              style: TextStyle(color: textColor, fontSize: 20),
            ),
            leading: CupertinoButton(
              child: Icon(
                Icons.menu,
                color: iconColor,
              ),
              onPressed: () {
                uiModel.navBarHeight = 0;
                showSearch(
                  context: context,
                  delegate: AppSearch(),
                );
              },
            ),
            actions: [
              CupertinoButton(
                padding: EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundColor: backgroundColor,
                  backgroundImage: NetworkImage(
                    'https://lh3.googleusercontent.com/a-/AOh14GiaURAEF5BlYYzjtiQC15HQMfHKGaPS5mNVGb9ZcA=s88-c-k-c0x00ffffff-no-rj-mo',
                  ),
                  radius: 14,
                ),
                onPressed: () {},
              ),
            ],
          ),

          body: SmartRefresher(
            controller: refreshController,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: () async {
              if (_connectivitySource.values.toList()[0] == true) {
                try {
                  await youtubeFeedModel.reloadVideos();
                  refreshController.refreshCompleted();
                } on SocketException catch (_) {
                  refreshController.refreshFailed();
                }
              } else {
                refreshController.refreshFailed();
              }
            },
            child: youtubeFeedModel.channel == null
                ? Container()
                : ListView.builder(
                    cacheExtent: 1700,
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      return index == youtubeFeedModel.channel.videos.length - 1
                          ? int.parse(youtubeFeedModel.channel.videoCount) != youtubeFeedModel.channel.videos.length
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(
                                        backgroundColor: backgroundColor,
                                        valueColor: AlwaysStoppedAnimation(iconColor),
                                        strokeWidth: 2.0,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox()
                          : FeedEntry(
                              context: context,
                              channelTitle: youtubeFeedModel.channel.title,
                              channelProfilePictureUrl: youtubeFeedModel.channel.profilePictureUrl,
                              videoId: youtubeFeedModel.channel.videos[index].id,
                              videoThumbnail: youtubeFeedModel.channel.videos[index].thumbnailUrl,
                              videoTitile: youtubeFeedModel.channel.videos[index].title,
                              subscribeCount: youtubeFeedModel.channel.subscribeCount,
                            );
                    },
                    itemCount: youtubeFeedModel.channel.videos.length,
                  ),
          ),
        );
      },
    );
  }
}

class FeedEntry extends StatelessWidget {
  final BuildContext context;
  final String channelTitle;
  final String channelProfilePictureUrl;
  final String videoId;
  final String videoTitile;
  final String videoThumbnail;
  final String subscribeCount;

  const FeedEntry({Key key, this.context, this.channelTitle, this.channelProfilePictureUrl, this.videoId, this.videoTitile, this.videoThumbnail, this.subscribeCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                onPressed: () async {
                  Provider.of<UIModel>(context, listen: false).insideHomeDeepLinkedScreen = true;
                  Future.delayed(
                    Duration(milliseconds: 100),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return YoutubePlayerScreen(
                              key: youtubeScreenKey,
                              videoId: videoId,
                              channelTitle: channelTitle,
                              channelProfilePictureUrl: channelProfilePictureUrl,
                              videoTitle: videoTitile,
                              subscribeCount: subscribeCount,
                              videoThumbnail: videoThumbnail,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width.toDouble(),
                          height: 150.0,
                          color: lightBackgroundColor,
                        ),
                        Image.network(
                          videoThumbnail,
                          width: MediaQuery.of(context).size.width.toDouble(),
                          height: 150.0,
                          fit: BoxFit.fitWidth,
                          gaplessPlayback: true,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: backgroundColor,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image(
                                image: NetworkImage(
                                  channelProfilePictureUrl,
                                ),
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: lightBackgroundColor,
                                  );
                                },
                                gaplessPlayback: true,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: lightBackgroundColor,
                                  );
                                },
                              ),
                            ),
                            radius: 17,
                          ),
                          Expanded(
                            flex: 1000,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                                  child: Text(
                                    channelTitle,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0, top: 1, right: 12),
                                  child: Text(
                                    videoTitile,
                                    style: TextStyle(
                                      color: iconColor,
                                      fontSize: 13,
                                      letterSpacing: 0.1,
                                      height: 1.4,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.only(top: 0.0, right: 8.0, left: 0.0, bottom: 4.0),
              child: Icon(
                Icons.more_horiz_sharp,
                color: iconColor,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      color: backgroundColor,
                      height: MediaQuery.of(context).size.height / 2.5,
                    );
                  },
                  useRootNavigator: true,
                );
              },
            ),
          ],
        ),
        SizedBox(
          height: 45,
        ),
      ],
    );
  }
}
