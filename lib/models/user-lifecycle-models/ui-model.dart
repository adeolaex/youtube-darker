import 'package:flutter/material.dart';

class UIModel extends ChangeNotifier {
  bool _ignoreDrawerGestures = false;
  bool _showYoutubePlayer = true;
  int _navBarHeight = 50;
  // Non consumers

  bool locked = false;
  int _tabIndex = 0;
  bool insideHomeDeepLinkedScreen = false;

  bool get ignoreDrawerGestures => _ignoreDrawerGestures;

  set ignoreDrawerGestures(bool newIgnoreDrawerGestures) {
    _ignoreDrawerGestures = newIgnoreDrawerGestures;
    notifyListeners();
  }

  int get navBarHeight => _navBarHeight;

  set navBarHeight(int newNavBarHeight) {
    _navBarHeight = newNavBarHeight;
    notifyListeners();
  }

  bool get showYoutubePlayer => _showYoutubePlayer;

  set showYoutubePlayer(bool newShowYoutubePlayer) {
    _showYoutubePlayer = newShowYoutubePlayer;
    notifyListeners();
  }

  int get tabIndex => _tabIndex;

  set tabIndex(int newTabIndex) {
    _tabIndex = newTabIndex;
    notifyListeners();
  }
}
