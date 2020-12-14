import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_darker/models/common/api-keys.dart';
import 'package:youtube_darker/models/youtube-api-models/youtube-feed-model.dart';

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _myConnectivity = MyConnectivity._internal();

  static MyConnectivity get myConnectivity => _myConnectivity;

  Connectivity connectivity = Connectivity();

  StreamController streamController = StreamController.broadcast();

  Stream get myStream => streamController.stream;

  void initialise() async {
    ConnectivityResult connectivityResult = await connectivity.checkConnectivity();
    _checkConnectivityStatus(connectivityResult);
    connectivity.onConnectivityChanged.listen((event) {
      _checkConnectivityStatus(connectivityResult);
    });
  }

  void _checkConnectivityStatus(ConnectivityResult connectivityResult) async {
    bool isOnline = false;

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    if (!streamController.isClosed) {
      streamController.sink.add({connectivityResult: isOnline});
    }
  }

  void disposeStream() => streamController.close();
}

class YoutubeAPIService {
  YoutubeAPIService._internal();

  static final YoutubeAPIService _youtubeAPIService = YoutubeAPIService._internal();

  static YoutubeAPIService get youtubeAPIService => _youtubeAPIService;

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel(String channelId) async {
    _nextPageToken = '';
    Map<String, String> parameters = {
      'part': 'snippet, statistics, contentDetails',
      'id': channelId,
      'key': youtubeAPIKey,
    };

    Map<String, String> headers = {
      HttpHeaders.acceptHeader: 'application.json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );

    var response;
    try {
      response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedMap = json.decode(response.body)['items'][0];
        Channel channel = await compute(parseChannel, decodedMap);
        channel.videos = await fetchVideoesFromPlaylist(playlistId: channel.uploadPlaylistId);
        return channel;
      } else {
        throw json.decode(response.body)['error']['messsage'];
      }
    } on SocketException catch (_) {
      throw json.decode(response.body)['error']['messsage'];
    }
  }

  Future<List<Video>> fetchVideoesFromPlaylist({String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '20',
      'pageToken': _nextPageToken,
      'key': youtubeAPIKey,
    };
    Map<String, String> headers = {
      HttpHeaders.acceptHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    var response;

    response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedMap = json.decode(response.body);
      _nextPageToken = decodedMap['nextPageToken'] ?? '';
      List<dynamic> listOfDecodedMap = decodedMap['items'];
      List<Video> videos = [];
      videos = await compute(parseVideos, listOfDecodedMap);
      return videos;
    } else {
      throw json.decode(response.body)['error']['messsage'];
    }
  }
}

Future<Channel> parseChannel(Map<String, dynamic> decodedMap) async {
  return Channel.fromMap(decodedMap);
}

Future<List<Video>> parseVideos(List<dynamic> listOfDecodedMap) async {
  List<Video> videos = [];
  listOfDecodedMap.forEach(
    (element) {
      videos.add(
        Video.fromMap(
          element['snippet'],
        ),
      );
    },
  );
  return videos;
}
