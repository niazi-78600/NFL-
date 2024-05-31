import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeagueScreen extends StatefulWidget {
  final int season;
  const LeagueScreen({Key? key, required this.season}) : super(key: key);

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> {
  late Future<List<Map<String, dynamic>>>? _futureLeagues;

  @override
  void initState() {
    super.initState();
    _futureLeagues = fetchLeagues(widget.season);
  }

  Future<List<Map<String, dynamic>>> fetchLeagues(int season) async {
    try {
      final response = await http.get(
        Uri.parse('https://api-american-football.p.rapidapi.com/leagues?season=$season'),
        headers: {
          'X-RapidAPI-Key': '31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9',
          'X-RapidAPI-Host': 'api-american-football.p.rapidapi.com',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['response'];
        return data.map((league) {
          final List<dynamic> seasonsData = league['seasons'];
          final seasonData = seasonsData.firstWhere((seasonItem) => seasonItem['year'] == season, orElse: () => null);
          if (seasonData != null) {
            return {
              'id': league['league']['id'],
              'name': league['league']['name'],
              'logo': league['league']['logo'],
              'countryName': league['country']['name'],
              'countryCode': league['country']['code'],
              'countryFlag': league['country']['flag'],
              'seasonYear': seasonData['year'],
              'seasonStart': seasonData['start'],
              'seasonEnd': seasonData['end'],
              'seasonCurrent': seasonData['current'],
              'seasonCoverage': seasonData['coverage'],
            };
          } else {
            return null;
          }
        }).where((league) => league != null).toList().cast<Map<String, dynamic>>();
      } else {
        print('Failed to load leagues: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error loading leagues: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = {
      'primaryColor': const Color(0xFF013369),  // NFL Blue
      'cardColor': const Color(0xFF013369),  // Light Grey for Card Background
      'textColor': Colors.white,  // White
      'subtextColor': Colors.white,  // Light Grey for Subtext
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.close,
        color: Colors.white,), onPressed: () {
          Navigator.of(context).pop();
          },),
        title: Text(
          
          'Leagues for Season ${widget.season}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: colorScheme['primaryColor'],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureLeagues,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No leagues found for this season.'));
          } else {
            final leagues = snapshot.data!;
            return ListView.builder(
              itemCount: leagues.length,
              itemBuilder: (context, index) {
                final league = leagues[index];
                return Card(
                  color: colorScheme['cardColor'],  // Set the card color here
                  margin: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 4,
                  child: ExpansionTile(
                    leading: league['countryFlag'] != null
                        ? SizedBox(
                            width: 50,  // Constrain the width
                            height: 50,  // Constrain the height
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                league['countryFlag'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(child: Icon(Icons.error)); // Placeholder on error
                                },
                              ),
                            ),
                          )
                        : null,
                    title: Text(
                      league['name'] ?? 'Unknown League',
                      style: TextStyle(
                        fontFamily: 'Arial', // Replace with your chosen font
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: colorScheme['textColor'],
                      ),
                    ),
                    subtitle: Text(
                      'Country: ${league['countryName'] ?? 'Unknown'}',
                      style: TextStyle(
                        color: colorScheme['subtextColor'],
                        fontSize: 14,
                      ),
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          'Season Year: ${league['seasonYear'] ?? 'Unknown'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme['textColor'],
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Season Start: ${league['seasonStart'] ?? 'Unknown'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme['textColor'],
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Season End: ${league['seasonEnd'] ?? 'Unknown'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme['textColor'],
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Current Season: ${league['seasonCurrent'] != null ? (league['seasonCurrent'] ? "Yes" : "No") : 'Unknown'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme['textColor'],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
