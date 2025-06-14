import 'package:flutter/material.dart';
import 'package:music_application_piton/screens/home_screen.dart';
import 'package:music_application_piton/models/podcast.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class NowPlayingScreen extends StatefulWidget {
  final Podcast podcast;

  const NowPlayingScreen({super.key, required this.podcast});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late AudioPlayer _audioPlayer;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;


  bool isPlaying = true;
  bool _isSeeking= false;
  Duration currentTime = const Duration(seconds: 0);
  Duration totalTime = const Duration(minutes: 42, seconds: 17);

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  void _initAudio() async {
    try {
      await _audioPlayer.setAsset(widget.podcast.audioUrl);

      _durationSubscription = _audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          setState(() => totalTime = duration);
        }
      });

      _positionSubscription = _audioPlayer.positionStream.listen((position) {
        setState(() => currentTime = position);
      });

      _audioPlayer.play();
    } catch (e) {
      print("Hata: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191717),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                widget.podcast.imageUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.podcast.title,
              style: const TextStyle(fontSize: 22, color: Colors.grey, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.podcast.author,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Progress bar
            // Progress bar - ekolayzır stili
            // Progress bar - interaktif slider
            Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.deepPurpleAccent,
                    inactiveTrackColor: Colors.deepPurpleAccent.withOpacity(0.3),
                    thumbColor: Colors.deepPurpleAccent,
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                  ),
                  child: Slider(
                    min: 0,
                    max: totalTime.inSeconds.toDouble(),
                    value: currentTime.inSeconds.clamp(0, totalTime.inSeconds).toDouble(),
                    onChangeStart: (value) {
                      _isSeeking = true;
                    },
                    onChanged: (value) {
                      setState(() {
                        currentTime = Duration(seconds: value.toInt());
                      });
                    },
                    onChangeEnd: (value) {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                      _isSeeking = false;
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(currentTime), style: const TextStyle(color: Colors.white)),
                    Text(_formatDuration(totalTime), style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),


            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    // önceki podcast
                  },
                  icon: const Icon(Icons.skip_previous, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                    isPlaying ? _audioPlayer.play() : _audioPlayer.pause();
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    size: 64,
                    color: Colors.white,
                  ),
                ),


                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    // sonraki podcast
                  },
                  icon: const Icon(Icons.skip_next, size: 40, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _audioPlayer.dispose();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    super.dispose();
  }


  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }
}
