import 'package:youtube_darker/common/colors.dart';
import 'package:youtube_darker/common/widgets-service.dart';
import 'package:youtube_darker/models/user-lifecycle-models/ui-model.dart';
import 'package:youtube_darker/models/user-lifecycle-models/user-model.dart';
import 'package:youtube_darker/services/server/api-service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  ScrollController scrollController;
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

  List<Widget> profileLayout = [
    Padding(
      padding: EdgeInsets.only(
        top: 50,
      ),
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: Image(
            image: NetworkImage(
              'https://lh3.googleusercontent.com/a-/AOh14GiaURAEF5BlYYzjtiQC15HQMfHKGaPS5mNVGb9ZcA=s600-k-no-rp-mo',
            ),
            fit: BoxFit.contain,
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
        radius: 60.0,
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Center(
        child: Text(
          'Adeola',
          style: TextStyle(color: textColor, fontSize: 18.0),
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(top: 2.5),
      child: Consumer2<UIModel, UserModel>(
        builder: (context, uiModel, userModel, _) {
          return Center(
            child: Text(
              userModel.user == null ? '' : userModel.user.phoneNumber ?? '',
              style: TextStyle(color: iconColor, fontSize: 14.5),
            ),
          );
        },
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 40.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 5.0),
            child: Icon(
              CupertinoIcons.rocket_fill,
              color: iconColor,
              size: 21.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Socials',
              style: TextStyle(
                color: textColor.withOpacity(0.9),
                fontSize: 15.5,
                height: 1.38,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              height: 60,
              width: 80,
            ),
          ),
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 5.0),
            child: Icon(
              Icons.settings_sharp,
              color: iconColor,
              size: 21.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Settings',
              style: TextStyle(
                color: textColor.withOpacity(0.9),
                fontSize: 15.5,
                height: 1.38,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              height: 60,
              width: 80,
            ),
          ),
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 5.0),
            child: Icon(
              Icons.favorite_sharp,
              color: iconColor,
              size: 21.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Acknowledgements',
              style: TextStyle(
                color: textColor.withOpacity(0.9),
                fontSize: 15.5,
                height: 1.38,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              height: 60,
              width: 80,
            ),
          ),
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 2.0, bottom: 200),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 5.0),
            child: Icon(
              Icons.feedback_sharp,
              color: iconColor,
              size: 21.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Feedback',
              style: TextStyle(
                color: textColor.withOpacity(0.9),
                fontSize: 15.5,
                height: 1.38,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              height: 60,
              width: 80,
            ),
          ),
        ],
      ),
    ),
    // Container(
    //   height: 200,
    //   color: backgroundColor,
    // ),
    Padding(
      padding: const EdgeInsets.only(left: 32.0, bottom: 32.0),
      child: Text(
        'v 0.1',
        style: TextStyle(
          color: iconColor,
          fontSize: 15.5,
          height: 1.38,
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            brightness: Brightness.dark,
            backgroundColor: backgroundColor,
            snap: false,
            floating: true,
            pinned: true,
            centerTitle: false,
            elevation: 0.0,
            title: Consumer2<UIModel, UserModel>(
              builder: (context, uiModel, userModel, _) {
                return Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    '[ 🚀 ]',
                    style: TextStyle(color: textColor, fontSize: 21.5),
                  ),
                );
              },
            ),
            actions: [
              CupertinoButton(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.more_horiz_sharp,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return profileLayout[index];
              },
              childCount: profileLayout.length,
            ),
          ),
        ],
      ),
    );
  }
}
