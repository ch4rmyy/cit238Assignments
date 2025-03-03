import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final AppLifecycleListener _listener;
  bool _isPlaying = false;
  String? _currentSong;


  final List<Map<String, String>> _songs = [
    {"title": "Zico - New Thing", "path": "assets/music/Zico-NewThing.mp3"},
    {"title": "BTS - Home", "path": "assets/music/bts-home.mp3"},
    {"title": "BTS - Mikrokosmos", "path": "assets/music/bts-mikrokosmos.mp3"},
    {
      "title": "Sample Sound",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3"
    },
  ];

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onPause: () => _pauseMusic(),
      onResume: () => _resumeMusic(),
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playMusicLocal(String path) async { //Play music from local
    if (_currentSong == path && _isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(path.replaceFirst("assets/", "")));
      setState(() {
        _isPlaying = true;
        _currentSong = path;
      });
    }
  }

  Future<void> _playMusicOnline(String url) async {
    if (_currentSong == url && _isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _isPlaying = true;
        _currentSong = url;
      });
    }
  }

  Future<void> _pauseMusic() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _resumeMusic() async {
    if (_currentSong != null && !_isPlaying) {
      await _audioPlayer.resume();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Continente's Mini Playlist"),
          centerTitle: true,
          backgroundColor: Color(0xFFA4DAF1)),
      backgroundColor: Color(0xFFC8E9F6),
      body: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          final isPlaying = _currentSong == (song["path"] ?? song["url"]) && _isPlaying;

          return ListTile(
            title: Text(song["title"]!),
            subtitle: Text(isPlaying ? "Music is playing..." : "Tap to play"),
            leading: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: isPlaying ? Colors.lightBlueAccent : null,
            ),
            onTap: () {
              if (isPlaying) {
                _pauseMusic();
              } else {
                if (song.containsKey("path")) {
                  _playMusicLocal(song["path"]!);
                } else if (song.containsKey("url")) {
                  _playMusicOnline(song["url"]!);
                }
              }
            },
          );
        },
      ),
    );
  }
}
