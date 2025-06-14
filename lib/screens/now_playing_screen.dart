import 'package:flutter/material.dart';
import 'package:music_application_piton/screens/home_screen.dart';
import 'package:music_application_piton/models/podcast.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class NowPlayingScreen extends StatefulWidget {
  final List<Podcast> podcasts;
  final int initialIndex;
  const NowPlayingScreen({
    super.key,
    required this.podcasts,
    required this.initialIndex,
  });

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late AudioPlayer _audioPlayer;
  late int currentIndex;
  late Podcast currentPodcast;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;


  bool isPlaying = true;
  bool _isSeeking = false;
  Duration currentTime = const Duration(seconds: 0);
  Duration totalTime = const Duration(minutes: 42, seconds: 17);

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    currentIndex = widget.initialIndex;
    currentPodcast = widget.podcasts[currentIndex];
    _initAudio();
  }

  void _initAudio() async {

      await _audioPlayer.setAsset(currentPodcast.audioUrl);
      _audioPlayer.play();

      _durationSubscription = _audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          setState(() => totalTime = duration);
        }
      });

      _positionSubscription = _audioPlayer.positionStream.listen((position) {
        setState(() => currentTime = position);
      });

      _audioPlayer.play();

  }

  void _playPodcastAtIndex(int index) async {
    if (index < 0 || index >= widget.podcasts.length) return; // sınır kontrolü

    setState(() {
      currentIndex = index;
      currentPodcast = widget.podcasts[currentIndex];
    });

    await _audioPlayer.setAsset(currentPodcast.audioUrl);
    _audioPlayer.play();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
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
                currentPodcast.imageUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentPodcast.title,
              style: const TextStyle(fontSize: 22,color: Colors.grey, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              currentPodcast.author,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // İlerleme Çubuğu ve Süreler
            Column(
              children: [
                // Slider (kullanıcının oynatma pozisyonunu değiştirmesi için)
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

                const SizedBox(height: 10),

                // Ekolyzer tarzı animasyonlu ilerleme çubuğu
                //Zaman kalırsa buradaki animasyonu kaldırıp Figmadaki tasarım gibi yap
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(20, (index) {
                      // Burada yüksekliği biraz animasyon gibi yapabiliriz.
                      // Örneğin currentTime ile orantılı yapalım:
                      final progressRatio = currentTime.inSeconds / (totalTime.inSeconds == 0 ? 1 : totalTime.inSeconds);
                      // Çubukların yüksekliklerini biraz hareketli yapalım:
                      final baseHeight = (index % 5 + 1) * 6.0;
                      // progressRatio ile yüksekliği ölçekleyelim, minimum 3.0 yüksekliğinde olsun
                      final height = (baseHeight * (0.3 + 0.7 * progressRatio)).clamp(3.0, baseHeight);
                      return Container(
                        width: 4,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 8),

                // Süre göstergeleri
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

            // Kontrol Butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _playPodcastAtIndex(currentIndex - 1);
                  },
                  icon: const Icon(Icons.skip_previous, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (isPlaying) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.play();
                      }
                      isPlaying = !isPlaying;
                    });
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
                    _playPodcastAtIndex(currentIndex + 1);
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
