import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlayersScreen(teamId: 1), // Example team ID
    ),
  );
}

class PlayersScreen extends StatefulWidget {
  final int teamId;

  const PlayersScreen({Key? key, required this.teamId}) : super(key: key);

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  List<Map<String, dynamic>> _playersData = [];
  List<Map<String, dynamic>> _filteredPlayersData = [];
  List<Map<String, dynamic>> _injuriesData = [];
  bool _isLoading = true;
  String _currentScreen = 'Players'; // Track the current screen
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchPlayers();
    _fetchInjuries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlayers() async {
    try {
      final response = await http.get(
        Uri.parse('https://api-american-football.p.rapidapi.com/players?season=2023&team=${widget.teamId}'),
        headers: {
          'X-RapidAPI-Key': '31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9',
          'X-RapidAPI-Host': 'api-american-football.p.rapidapi.com',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['response'];
        setState(() {
          _playersData = data.map((player) {
            return {
              'name': player['name'],
              'image': player['image'],
              'college': player['college'],
              'age': player['age'],
            };
          }).toList().cast<Map<String, dynamic>>();
          _filteredPlayersData = _playersData;
          _isLoading = false;
        });
      } else {
        print('Failed to load players: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error loading players: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchInjuries() async {
    try {
      final response = await http.get(
        Uri.parse('https://api-american-football.p.rapidapi.com/injuries?team=${widget.teamId}'),
        headers: {
          'X-RapidAPI-Key': '31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9',
          'X-RapidAPI-Host': 'api-american-football.p.rapidapi.com',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['response'];
        setState(() {
          _injuriesData = data.map((injury) {
            return {
              'name': injury['player']['name'],
              'position': injury['player']['position'],
              'image': injury['player']['image'],
              'date': injury['date'],
              'status': injury['status'],
              'description': injury['description'],
            };
          }).toList().cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        print('Failed to load injuries: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error loading injuries: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      _filteredPlayersData = _playersData
          .where((player) => player['name'].toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: const Color(0xFF002868),
          centerTitle: true,
          title: Text(
            'Team Data',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildScreenButton("Players"),
                  _buildScreenButton("Stats"),
                  _buildScreenButton("Injuries"),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _currentScreen == 'Players'
                    ? _buildPlayersList()
                    : _currentScreen == 'Stats'
                        ? _buildPlayerStatsScreen() // Display player stats screen
                        : _currentScreen == 'Injuries'
                            ? _buildInjuriesList()
                            : Container(), // Add other screens here
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersList() {
    return ListView.builder(
      itemCount: _filteredPlayersData.length,
      itemBuilder: (BuildContext context, int index) {
        final player = _filteredPlayersData[index];
        return Card(
          color: const Color(0xFF002868),
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              player['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold, // Bold player name
                color: Colors.white,
                fontSize: 16, // Larger font size
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(player['image']),
              radius: 25, // Adjust avatar size
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4), // Add vertical spacing
                Text(
                  'College: ${player['college']}',
                  style: const TextStyle(
                    color: Colors.white, // Subtitle text color
                  ),
                ),
                const SizedBox(height: 2), // Add vertical spacing
                Text(
                  'Age: ${player['age']}',
                  style: const TextStyle(
                    color: Colors.white, // Subtitle text color
                  ),
                ),
                const SizedBox(height: 8), // Add vertical spacing
              ],
            ),
            onTap: () {
              // Handle player tap event
            },
          ),
        );
      },
    );
  }

  Widget _buildInjuriesList() {
    return ListView.builder(
      itemCount: _injuriesData.length,
      itemBuilder: (BuildContext context, int index) {
        final injury = _injuriesData[index];
        return Card(
          color: const Color(0xFF002868),
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              injury['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(injury['image']),
              radius: 25, 
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4), 
                Text(
                  'Position: ${injury['position']}',
                  style: const TextStyle(
                    color: Colors.white, 
                  ),
                ),
                const SizedBox(height: 2), 
                Text(
                  'Date: ${injury['date']}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2), 
                Text(
                  'Status: ${injury['status']}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2), 
                Text(
                  'Description: ${injury['description']}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8), 
              ],
            ),
            onTap: () {
              // Handle injury tap event
            },
          ),
        );
      },
    );
  }

  Widget _buildScreenButton(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _currentScreen = title; // Update current screen on button click
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF002868),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerStatsScreen() {
    return SingleChildScrollView(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: PlayerStatsFetcher().fetchPlayerStats(widget.teamId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Map<String, dynamic>> playerStatsList = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: playerStatsList.isEmpty
                  ? const Center(child: Text('No player statistics available'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: playerStatsList.length,
                      itemBuilder: (context, index) {
                        final playerStats = playerStatsList[index];

                        return Card(
                          color: const Color(0xFF002868),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(playerStats['image']),
                                      radius: 25,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      playerStats['name'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                DataTable(
                                  columnSpacing: 20,
                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        'Statistic',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Value',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: playerStats['statistics'].map<DataRow>((stat) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            stat['statName'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            stat['statValue'] ?? '-',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            );
          }
        },
      ),
    );
  }
}

class PlayerStatsFetcher {
  Future<List<Map<String, dynamic>>> fetchPlayerStats(int teamId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api-american-football.p.rapidapi.com/players/statistics?season=2023&team=$teamId'),
        headers: {
          'X-RapidAPI-Key': '31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9',
          'X-RapidAPI-Host': 'api-american-football.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        final List<dynamic> playerDataList = decodedData['response'];

        List<Map<String, dynamic>> playerStatsList = [];

        for (var playerData in playerDataList) {
          final player = playerData['player'];
          final List<Map<String, dynamic>> statistics = [];

          for (var team in playerData['teams']) {
            for (var group in team['groups']) {
              for (var stat in group['statistics']) {
                statistics.add({
                  'statName': stat['name'],
                  'statValue': stat['value'],
                });
              }
            }
          }

          playerStatsList.add({
            'name': player['name'],
            'image': player['image'],
            'statistics': statistics,
          });
        }

        return playerStatsList;
      } else {
        throw Exception('Failed to load player stats: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error loading player stats: $error');
    }
  }
}
