import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LivesPage extends StatefulWidget{
    const LivesPage({super.key});
    @override
    LivesPageState createState() => LivesPageState();
}
class LivesPageState extends State<LivesPage>{
   String? _audioUrl;
   //String apiKey = 'AIzaSyDgqTH_UQhL0Uijj5euCEVnw-P7G-4rDrg';
   //String channelId = 'UChs0pSaEoNLV4mevBFGaoKA';
   late AudioPlayer _audioPlayer;
   @override
   void initState() {
       super.initState();
       _audioPlayer = AudioPlayer();
       _fetchLiveAudioUrl();
   }
   Future<String> getAudioStreamUrl(String videoId) async {
       var yt = YoutubeExplode();
       var manifest = await yt.videos.streamsClient.getManifest(videoId);
       var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
       return audioStreamInfo.url.toString();
   }
   Future<void> _fetchLiveAudioUrl() async {
       try {
           var yt = YoutubeExplode();
           var video = await yt.videos.get("https://www.youtube.com/watch?v=9UMxZofMNbA");
           var manifest = await yt.videos.streams.getHttpLiveStreamUrl(video.id);
           var aud =  manifest.toString();
           setState(() {
               _audioUrl = aud.toString();
               //_audioUrl = "https://manifest.googlevideo.com/api/manifest/hls_playlist/expire/1722567842/ei/QvirZuOWGLayvdIPuuyysAE/ip/196.65.210.193/id/yCJvERM6d4U.1/itag/234/source/yt_live_broadcast/requiressl/yes/ratebypass/yes/live/1/goi/133/sgoap/gir%3Dyes%3Bitag%3D140/rqh/1/hdlc/1/hls_chunk_host/rr3---sn-p5h-gc5y.googlevideo.com/xpc/EgVo2aDSNQ%3D%3D/playlist_duration/3600/manifest_duration/3600/vprv/1/playlist_type/DVR/initcwndbps/477500/mh/eQ/mm/44/mn/sn-p5h-gc5y/ms/lva/mv/m/mvi/3/pl/21/dover/13/pacing/0/short_key/1/keepalive/yes/mt/1722545823/sparams/expire,ei,ip,id,itag,source,requiressl,ratebypass,live,goi,sgoap,rqh,hdlc,xpc,playlist_duration,manifest_duration,vprv,playlist_type/sig/AJfQdSswRQIgEMl5O6tmqPmSw8wcHAvO3-YveQo46CMdT_ZthVn5VKoCIQDJ43ZJCTAkZNOE05RQI_a1kiPHDJ0osvVCcJVSAysDWA%3D%3D/lsparams/hls_chunk_host,initcwndbps,mh,mm,mn,ms,mv,mvi,pl/lsig/AGtxev0wRQIhAOIKBqc_Mo9uPwtlbixSQJyfuvQvHOtSccx5q99wb4k0AiBs39PILhrh81dp4sv9Pxveduup77tpcysA_Pq2R0Uc9Q%3D%3D/playlist/index.m3u8";
                       //"https://www.youtube.com/embed/9UMxZofMNbA?si=MQWbMhLdogDr2XEU";
           });
           //_audioPlayer.play(UrlSource(_audioUrl!));
       } catch (e) {
           print('Error: $e');
       }
   }
   //@override
   //void dispose() {
   //    _audioPlayer.dispose();
   //    super.dispose();
   //}
   @override
   Widget build(BuildContext context) {
       return _audioUrl == null
               ? const Center(child: CircularProgressIndicator())
               : Center(
                   child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                           const Text('Playing live audio stream...'),
                           IconButton(
                               icon: const Icon(Icons.pause),
                               onPressed: () => _audioPlayer.stop(),
                           ),
                           IconButton(
                               icon: const Icon(Icons.play_arrow),
                               onPressed: () => _audioPlayer.play(UrlSource(_audioUrl!)),
                           ),
                       ],
                   ),
               );
   }
   //Future<String> getLiveVideoId(String apiKey, String channelId) async {
   //    final url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&eventType=live&type=video&key=$apiKey';
   //    final response = await http.get(Uri.parse(url));
   //    if (response.statusCode == 200) {
   //        final data = json.decode(response.body);
   //        if (data['items'].isNotEmpty) {
   //            return data['items'][0]['id']['videoId'];
   //        } else {
   //            throw Exception('No live video found');
   //        }
   //    } else {
   //        throw Exception('Failed to fetch live video');
   //    }
   //}
}





