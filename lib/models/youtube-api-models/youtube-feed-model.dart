import 'package:youtube_darker/services/server/api-service.dart';
import 'package:flutter/material.dart';

class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  Video({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
  });

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['resourceId']['videoId'],
      title: map['title'],
      thumbnailUrl: map['thumbnails']['standard'] != null ? map['thumbnails']['standard']['url'] : map['thumbnails']['high']['url'],
      channelTitle: map['channelTitle'],
    );
  }
}

class Channel {
  final String id;
  final String title;
  final String profilePictureUrl;
  final String subscribeCount;
  final String videoCount;
  final String uploadPlaylistId;
  List<Video> videos;

  Channel({this.id, this.title, this.profilePictureUrl, this.subscribeCount, this.videoCount, this.uploadPlaylistId});

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      subscribeCount: map['statistics']['subscriberCount'],
      videoCount: map['statistics']['videoCount'],
      uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],
    );
  }
}

class YoutubeFeedModel extends ChangeNotifier {
  YoutubeFeedModel() {
    _initVideos();
  }

  Channel _channel;

  Channel get channel => _channel;

  set channel(Channel newChannel) {
    _channel = newChannel;
    notifyListeners();
  }

  set channelVideos(List<Video> newVideo) {
    _channel.videos.addAll(newVideo);
    notifyListeners();
  }
  // Helper functions

  Future<void> _initVideos() async {
    Channel channel = await YoutubeAPIService.youtubeAPIService.fetchChannel('UCV0qA-eDDICsRR9rPcnG7tw');
    this.channel = channel;
  }

  Future<Channel> reloadVideos() async {
    Channel channel = await YoutubeAPIService.youtubeAPIService.fetchChannel('UCd21m0AHf4Vx88Znty7v4Cw');
    this.channel = channel;
    return channel;
  }

  Future<void> loadMoreVideos() async {
    List<Video> videos = await YoutubeAPIService.youtubeAPIService.fetchVideoesFromPlaylist(playlistId: this.channel.uploadPlaylistId);
    channelVideos = videos;
  }
}
