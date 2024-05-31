import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nfl/fetchplayers.dart';
import 'builders.dart';
import 'teams.dart';
import 'splash.dart';
import 'nfl_news_fetcher.dart';
import 'devision.dart';
import 'standing_screen.dart';
import 'stats.dart';
import 'upcoming_matches.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await MobileAds.instance.initialize();
  } catch (e) {
    print('Error initializing MobileAds: $e');
  }
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _index = 0;
  int _selectedWeek = 1;
  bool _isFetchingData = false;
  List<Map<String, dynamic>> _teamsData = [];
  List<Map<String, dynamic>> _playersData = [];
  List<Map<String, dynamic>> _filteredPlayersData = [];
  List<Map<String, dynamic>> _newsList = [];
  List<Map<String, dynamic>> _upcomingMatches = [];
  final List _seasonsData = [];
  List topPlayersImge = [
    'https://media.api-sports.io/american-football/players/1197.png',
    'https://media.api-sports.io/american-football/players/2319.png',
    'https://media.api-sports.io/american-football/players/830.png',
    'https://media.api-sports.io/american-football/players/1013.png',
    'https://media.api-sports.io/american-football/players/1215.png',
  ];
  List topPlayersName = [
    'Patrick Mahomes',
    'Justin Jefferson',
    'Jalen Hurts',
    'Nick Bosa',
    'Travis Kelce'
  ];
  final TeamFetcher _teamFetcher = TeamFetcher();
  final NFLNewsFetcher _newsFetcher = NFLNewsFetcher();
  final TextEditingController _searchController = TextEditingController();

  Brightness _brightness = Brightness.light;

  bool _enableNotifications = true;
  bool _enableSound = true;
  ScrollController _scrollController = ScrollController();
  Color _appBarColor = const Color(0xFF002868); // Default app bar color
  Color _containerColor = const Color(0xFFF2F2F2); // Default container color

  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Use your own ad unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          _interstitialAd.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _isInterstitialAdLoaded = false;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchTeams();
    _fetchNews();
    _fetchUpcomingMatches(_selectedWeek);
    _scrollController.addListener(_scrollListener);
    _loadBannerAd();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bannerAd.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
      _fetchUpcomingMatches(_selectedWeek);
      _fetchNews();
    }
  }

  Future<void> _fetchNews() async {
    try {
      final newsData = await _newsFetcher.fetchNFLNews();
      setState(() {
        _newsList = newsData;
      });
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  Future<void> _fetchUpcomingMatches(int week) async {
     setState(() {
    _isFetchingData = true; // Set fetching state to true
  });
    try {
      final upcomingMatches = await UpcomingMatchesFetcher.fetchUpcomingMatches(week);
      setState(() {
        _upcomingMatches = upcomingMatches;
        _isFetchingData = false;
      });
    } catch (e) {
      print('Error fetching upcoming matches: $e');
    }
  }
void _launchURL(String url) async {
  try {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } catch (e) {
    print('Error launching URL: $e');
  }
}

  Future<void> _fetchTeams() async {
    final teams = await _teamFetcher.fetchTeams();
    setState(() {
      _teamsData = teams;
    });
  }

  void _filterPlayers(String query) {
    setState(() {
      _filteredPlayersData = _playersData
          .where((player) =>
              player['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _navigateToPlayersScreen(int teamId, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayersScreen(teamId: teamId),
      ),
    );
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }
  void _showInterstitialAd() {
    if (_isInterstitialAdLoaded) {
      _interstitialAd.show();
      _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _navigateToTeamsScreen();
          _loadInterstitialAd(); // Load another interstitial ad
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _navigateToTeamsScreen();
          _loadInterstitialAd(); // Load another interstitial ad
        },
      );
    } else {
      _navigateToTeamsScreen();
    }
  }
  void _navigateToTeamsScreen() {
    _fetchTeams();
  }

  @override
  Widget build(BuildContext context) {
    List<String> screenTitles = [
      'Home',
      'Teams',
      'Divisions & Conferences',
      'Standings',
      'Unknown Content',
    ];
    String currentTitle = screenTitles[_index];
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFF002868),
          title: Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('images/logoo.png'),
                radius: 20,
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Center(
                  child: Text(
                    currentTitle,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                _showSettingsDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _getSelectedWidget(),
            ),
          ),

          if (_isBannerAdLoaded)
            Container(
              color: Colors.transparent,
              child: AdWidget(ad: _bannerAd),
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              alignment: Alignment.center,
            ),
          SizedBox(height: 10),
        ],

      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CurvedNavigationBar(
            index: _index,
            height: 50,
            items: const <Widget>[
              Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              ),
              Icon(Icons.people, size: 30, color: Colors.white),
              Icon(Icons.sports_football, size: 30, color: Colors.white),
              Icon(Icons.emoji_events, size: 30, color: Colors.white),
            ],
            color: const Color(0xFF002868),
            buttonBackgroundColor: const Color(0xFF002868),
            backgroundColor: const Color(0xFFF2F2F2),
            animationCurve: Curves.easeInOut,
            onTap: (int newIndex) {
              setState(() {
                _index = newIndex;
                if (_index == 1) {
                  _showInterstitialAd();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget? _getSelectedWidget() {
    switch (_index) {
      case 0:
        return _isFetchingData ? const Center(child: CircularProgressIndicator())
    : SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Upcoming Matches',
                  style: GoogleFonts.roboto(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF002868),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(18, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedWeek = index + 1;
                            _fetchUpcomingMatches(_selectedWeek);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: _selectedWeek == index + 1
                                ? const Color(0xFF002868)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Week ${index + 1}',
                              style: GoogleFonts.roboto(
                                color: _selectedWeek == index + 1
                                    ? Colors.white
                                    : const Color(0xFF002868),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _upcomingMatches.length,
                  itemBuilder: (context, index) {
                    final match = _upcomingMatches[index];
                    return Card(
                      color: const Color(0xFF002868),
                      child: Container(
                        width: 250,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  match['homeTeamLogo'],
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  match['homeTeamName'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Image.network(
                                  match['awayTeamLogo'],
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  match['awayTeamName'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Date: ${match['date']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Time: ${match['time']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Top Players',
                  style: GoogleFonts.roboto(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF002868),
                  ),
                ),
              ),
              Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final playerImage = topPlayersImge[index];
                    final playerName = topPlayersName[index];
                    return Card(
                      color: const Color(0xFF002868),
                      child: Container(
                        width: 130,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(playerImage),
                              radius: 30,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              playerName,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Latest News',
                  style: GoogleFonts.roboto(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF002868),
                  ),
                ),
              ),
              Container(
                height: 400,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _newsList.length,
                  itemBuilder: (context, index) {
                    final newsItem = _newsList[index];
                    return GestureDetector(
                      onTap: () => _launchURL(newsItem['link'] ?? ''),
                      child: Card(
                        color: const Color(0xFF002868),
                        child: Container(
                          width: 300,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              newsItem['image'] != null
                                  ? Image.network(
                                      newsItem['image'],
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(),
                              const SizedBox(height: 8),
                              Text(
                                newsItem['title'] ?? 'News Headline',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        newsItem['description'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        newsItem['published'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      case 1:
        return TeamListBuilder.buildTeamsList(
            _teamsData, _navigateToPlayersScreen);
      case 2:
        return Devision();
      case 3:
        return NFLStandingsScreen();
      default:
        return const Center(
          child: Text('Unknown Content'),
        );
    }
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Enable Notifications'),
                value: _enableNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _enableNotifications = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Enable Sound'),
                value: _enableSound,
                onChanged: (bool value) {
                  setState(() {
                    _enableSound = value;
                  });
                },
              ),
              ListTile(
                title: const Text('Brightness'),
                trailing: DropdownButton<Brightness>(
                  value: _brightness,
                  items: const [
                    DropdownMenuItem(
                      value: Brightness.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: Brightness.dark,
                      child: Text('Dark'),
                    ),
                  ],
                  onChanged: (Brightness? value) {
                    if (value != null) {
                      setState(() {
                        _brightness = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
