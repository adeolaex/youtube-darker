import 'package:youtubedarker/models/common/colors.dart';
import 'package:youtubedarker/models/common/widgets-service.dart';
import 'package:youtubedarker/screens/core-screens/settings-screen.dart';
import 'package:youtubedarker/services/api-service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home-screen.dart';
import 'notifications-screen.dart';

class CoreHeaderScreen extends StatefulWidget {
  CoreHeaderScreen({Key key}) : super(key: key);
  @override
  CoreHeaderScreenState createState() => CoreHeaderScreenState();
}

class CoreHeaderScreenState extends State<CoreHeaderScreen> with TickerProviderStateMixin {
  ScrollController scrollController;

  ScrollController scrollControllerK;

  TabController tabController;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Map _connectivitySource = {ConnectivityResult.none: false};

  MyConnectivity myConnectivity = MyConnectivity.myConnectivity;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollControllerK = ScrollController();
    tabController = TabController(length: 3, initialIndex: 0, vsync: this);
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
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            '',
            style: TextStyle(color: textColor, fontSize: 20.5),
          ),
        ),
        leading: CupertinoButton(
          child: Icon(Icons.sticky_note_2_sharp, color: iconColor),
          onPressed: () {},
        ),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: backgroundColor,
              backgroundImage: NetworkImage(
                'https://lh3.googleusercontent.com/a-/AOh14GiaURAEF5BlYYzjtiQC15HQMfHKGaPS5mNVGb9ZcA=s88-c-k-c0x00ffffff-no-rj-mo',
              ),
              radius: 14.0,
            ),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          indicatorColor: blueColor,
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelStyle: TextStyle(color: iconColor),
          labelColor: textColor,
          labelStyle: TextStyle(
            fontSize: 15.0,
          ),
          tabs: [
            Tab(text: "Home"),
            Tab(text: "Notifications"),
            Tab(text: "Settings"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          HomeScreen(),
          NotificationScreen(),
          SettingsScreen(),
        ],
      ),
    );
  }
}
