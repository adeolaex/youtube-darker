import 'dart:io';
import 'package:youtube_darker/common/colors.dart';
import 'package:youtube_darker/common/widgets-service.dart';
import 'package:youtube_darker/models/user-lifecycle-models/ui-model.dart';
import 'package:youtube_darker/screens/helper-screens/search-screen.dart';
import 'package:youtube_darker/services/server/api-service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);
  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  ScrollController scrollController;

  RefreshController refreshController = RefreshController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Map _connectivitySource = {ConnectivityResult.none: false};

  MyConnectivity myConnectivity = MyConnectivity.myConnectivity;

  @override
  void initState() {
    scrollController = ScrollController();

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

    super.initState();
  }

  @override
  void dispose() {
    myConnectivity.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      body: NestedScrollView(
        floatHeaderSlivers: false,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              brightness: Brightness.dark,
              backgroundColor: backgroundColor,
              snap: false,
              floating: false,
              pinned: true,
              centerTitle: true,
              forceElevated: true,
              elevation: 0.0,
              title: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  'Notifications',
                  style: TextStyle(color: textColor, fontSize: 20),
                ),
              ),
              leading: Consumer<UIModel>(
                builder: (context, uiModel, child) {
                  return CupertinoButton(
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
          ];
        },
        body: Scrollbar(
          controller: scrollController,
          child: SmartRefresher(
            onRefresh: () async {
              if (_connectivitySource.values.toList()[0] == true) {
                try {
                  await http.get('https://github.com/adeolaex/youtube_darker/blob/adb772ba48bde4cd4bf805833af8ebda2c241ce5/lib/screens/core-screens/home-screen.dart');
                  refreshController.refreshCompleted();
                } on SocketException catch (_) {
                  refreshController.refreshFailed();
                }
              } else {
                refreshController.refreshFailed();
              }
            },
            onLoading: () {},
            controller: refreshController,
            child: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) {
                return notificationEntry(index: index, context: context);
              },
              itemCount: 10,
            ),
          ),
        ),
      ),
    );
  }
}

Widget notificationEntry({
  BuildContext context,
  int index,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 20.0, right: 12.0, bottom: 16.0, top: 16.0),
    child: CupertinoButton(
      onPressed: () {},
      padding: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 5.0),
            child: CircleAvatar(
              backgroundColor: backgroundColor,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  image: NetworkImage(
                    'https://yt3.ggpht.com/ytc/AAUvwnioT6AtBNpN24dIZVVC7lufbV1o9zBo9xr5SZkr1Q=s176-c-k-c0x00ffffff-no-rj',
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
              radius: 23.0,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    'Adeola and malcom had one or two things to say reagrding how and when you should use dart for programming',
                    style: TextStyle(
                      color: textColor.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.38,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Text(
                  '4 hours ago',
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              height: 60,
              width: 80,
              child: Image(
                image: NetworkImage(
                  'https://i.ytimg.com/vi/GkI7lgfjRPM/hqdefault.jpg?sqp=-oaymwEjCNACELwBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLC4eTGD4RH3GHoC5K1kHnIk-1-Uog',
                ),
                fit: BoxFit.fitWidth,
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
          ),
        ],
      ),
    ),
  );
}
