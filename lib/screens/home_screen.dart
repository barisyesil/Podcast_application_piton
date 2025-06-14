import 'package:flutter/material.dart';
import 'package:music_application_piton/models/podcast.dart';
import 'now_playing_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = ["All","Comedy", "Education", "Tech", "Music", "Sports", "News"];
  String selectedCategory = "";
  final TextEditingController _searchController = TextEditingController();

  final List<Podcast> allPodcasts = [
    Podcast(
      title: 'Barış Özcan ile 111 Hz-Gerçekten İyileşmeye İhtiyacın Var mı',
      author: 'Barış Özcan',
      imageUrl: 'assets/images/baris_ozcan.jpeg',
      audioUrl: 'assets/audios/Barış Özcan ile 111 Hz-episode-Gerçekten İyileşmeye İhtiyacın Var mı_ Şifa Bağımlılığı.mp3',
      category: 'Tech',
    ),
    Podcast(
      title: 'Ahlakın Felsefesi',
      author: 'Portal',
      imageUrl: 'assets/images/Portal.jpg',
      audioUrl: 'assets/audios/Ahlakın Felsefesi.m4a',
      category: 'Education',
    ),
    Podcast(
      title: 'Toksik Bir Ailede Büyümek',
      author: 'Portal',
      imageUrl: 'assets/images/Portal.jpg',
      audioUrl: 'assets/audios/Toksik Bir Ailede Büyümek.m4a',
      category: 'News',
    ),
    Podcast(
      title: 'Barış Özcan ile 111 Hz-Her Şeyin Bir Yaşı Var mıdır_',
      author: 'Barış Özcan',
      imageUrl: 'assets/images/baris_ozcan.jpeg',
      audioUrl: 'assets/audios/Barış Özcan ile 111 Hz-episode-Her Şeyin Bir Yaşı Var mıdır_.mp3',
      category: 'Education',
    ),
    Podcast(
      title: 'Podcastia Maceraları 1.0- S01E01 - Macera Başlıyor! Kötülük Tohumları!',
      author: 'Can Sungur',
      imageUrl: 'assets/images/podcastia.jpeg',
      audioUrl: 'assets/audios/Podcastia Maceraları 1.0-episode-S01E01 - Macera Başlıyor! Kötülük Tohumları!.mp3',
      category: 'Comedy',
    ),
  ];

  List<Podcast> filteredPodcasts = [];

  @override
  void initState() {
    super.initState();
    filteredPodcasts = allPodcasts;
  }

  void _filterPodcasts(String query) {
    setState(() {
      filteredPodcasts = allPodcasts.where((podcast) {
        final matchesCategory = selectedCategory == "All" || podcast.category == selectedCategory;
        final matchesSearch = podcast.title.toLowerCase().contains(query.toLowerCase()) ||
            podcast.author.toLowerCase().contains(query.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }



  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredPodcasts = allPodcasts.where((podcast) {
        final matchesCategory = category == "All" || podcast.category == category;
        final matchesSearch = podcast.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            podcast.author.toLowerCase().contains(_searchController.text.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // koyu ton (değişebilir)
      //*DRAWER Menu teması değiştirilecek!
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black54),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 40)),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Drawer kapatma
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Panel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  const Text(
                    "Podkes",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.notifications_none, color: Colors.white),
                ],
              ),
            ),
            // Arama Çubuğu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search in selected category...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: _filterPodcasts,
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
                  final category = categories[index];
                  final isSelected = category == selectedCategory;
                  return GestureDetector(
                    onTap: () => _filterByCategory(category),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFCF9645) : Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  itemCount: filteredPodcasts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final podcast = filteredPodcasts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NowPlayingScreen(
                              podcasts: filteredPodcasts,
                              initialIndex: index,
                            ),
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
                            Text(
                              podcast.title,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              podcast.author,
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFF58C17C),
        unselectedItemColor: Colors.white70,
        currentIndex: 0,
        onTap: (index) {

          //buralara zamanım kalırsa ekran tasarlayabilirim


          switch (index) {
            case 0:
              print("Discover tıklandı");
              break;
            case 1:
              print("Library tıklandı");
              break;
            case 2:
              print("Profile tıklandı");
              break;
          }
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
