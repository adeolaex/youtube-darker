import 'package:youtube_darker/models/common/colors.dart';
import 'package:youtube_darker/models/user-lifecycle-models/ui-model.dart';
import 'package:youtube_darker/models/user-lifecycle-models/user-model.dart';
import 'package:youtube_darker/models/youtube-api-models/youtube-feed-model.dart';
import 'package:youtube_darker/screens/core-screens/core-header-screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'screens/core-screens/core-header-screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
  );
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

  final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      // onDidReceiveLocalNotification:
      );

  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onSelectNotification: selectNotification,
  );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ],
  );

  GestureBinding.instance.resamplingEnabled = true;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UIModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserAuthModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => YoutubeFeedModel(),
        )
      ],
      child: RefreshConfiguration(
        headerBuilder: () => ClassicHeader(
          releaseIcon: Icon(Icons.arrow_upward_sharp, color: iconColor),
          idleIcon: Icon(Icons.arrow_downward_sharp, color: iconColor),
          refreshingIcon: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              backgroundColor: backgroundColor,
              valueColor: AlwaysStoppedAnimation(iconColor),
              strokeWidth: 2.0,
            ),
          ),
          idleText: '',
          releaseText: '',
          refreshingText: '',
          completeText: '',
          failedText: '',
          iconPos: IconPosition.top,
        ),
        footerBuilder: () => ClassicFooter(
          idleIcon: SizedBox(),
          noMoreIcon: SizedBox(),
          canLoadingIcon: SizedBox(),
          loadingIcon: IgnorePointer(
            ignoring: true,
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                backgroundColor: backgroundColor,
                valueColor: AlwaysStoppedAnimation(iconColor),
                strokeWidth: 2.0,
              ),
            ),
          ),
          loadingText: '',
          noDataText: '',
          iconPos: IconPosition.top,
          failedText: '',
          canLoadingText: '',
          idleText: '',
          onClick: () {},
        ), // Configure default bottom indicator

        enableScrollWhenRefreshCompleted: true,
        enableLoadingWhenFailed: true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
        hideFooterWhenNotFull: true, // Disable pull-up to load more functionality when Viewport is less than one screen
        enableBallisticLoad: true,
        child: MaterialApp(
          title: 'youtube_darker',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            accentColor: blueColor,
            highlightColor: Colors.transparent,
            splashColor: blueColor.withOpacity(0.6),
            brightness: Brightness.dark,
            cursorColor: blueColor,
            textSelectionColor: blueColor.withOpacity(0.3),
            textSelectionHandleColor: blueColor,
            cupertinoOverrideTheme: CupertinoThemeData(
              brightness: Brightness.dark,
              primaryColor: blueColor,
              textTheme: CupertinoTextThemeData(primaryColor: textColor),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          home: CoreHeaderScreen(),
        ),
      ),
    ),
  );
}
