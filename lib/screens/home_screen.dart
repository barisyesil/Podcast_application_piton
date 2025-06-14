import 'package:flutter/material.dart';
import 'package:music_application_piton/models/podcast.dart';
import 'now_playing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final Size size = MediaQuery.of(context).size;
    final List<String> categories = ["Comedy", "News", "Music", "Tech", "Sports", "Education"];
    final List<Podcast> trendingPodcasts = [
      Podcast(
        title: 'Barış Özcan ile 111 Hz-episode-Her Şeyin Bir Yaşı Var mıdır_',
        author: 'Barış Özcan',
        imageUrl: 'assets/images/baris_ozcan.jpeg',
        audioUrl: 'assets/audios/baris_ozcan_111hz_1.mp3',
      ),
      Podcast(
        title: 'Ahlakın Felsefesi',
        author: 'Portal',
        imageUrl: 'assets/images/Portal.jpg',
        audioUrl: 'assets/audios/Ahlakın Felsefesi.m4a',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Spotify koyu tonu
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Panel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.menu, color: Colors.white),
                  Text(
                    "Podkes",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.notifications_none, color: Colors.white),
                ],
              ),
            ),

            // Arama Çubuğu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Ara...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Kategori Butonları
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCF9645), // Spotify yeşili
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categories[index],
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Trending Başlığı
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Trending",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Podcast Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  itemCount: trendingPodcasts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3 / 4,
                  ),
                    itemBuilder: (context, index) {
                      final podcast = trendingPodcasts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NowPlayingScreen(podcast: podcast),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color(0xFF1E1E1E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(podcast.imageUrl, height: 80, width: 80, fit: BoxFit.cover),
                              const SizedBox(height: 8),
                              Text(podcast.title,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                              Text(podcast.author,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      ),

      // Alt Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFF58C17C), // Spotify yeşili
        unselectedItemColor: Colors.white70,
        currentIndex: 0,
        onTap: (index) {
          // Sayfalar arası geçiş burada yapılabilir
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Discover"),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: "Library"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
