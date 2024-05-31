
import 'package:flutter/material.dart';
import 'package:nfl/fetchplayers.dart';
import 'package:google_fonts/google_fonts.dart';
class TeamListBuilder {
  static Widget buildTeamsList(List<Map<String, dynamic>> teamsData, Function(int, int) onTeamTap) {
    if (teamsData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(), 
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10),
        child: ListView.builder(
          itemCount: teamsData.length,
          itemBuilder: (BuildContext context, int index) {
            final team = teamsData[index];
            if (team['coach']==null || team['coach'].isEmpty ||team['logo']==null)
            { return const SizedBox.shrink();}
            return Card(
              color: const Color(0xFF002868),
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  team['name'],
                  style:  GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w500, 
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coach: ${team['coach']}',
                      style: const TextStyle(
                        color: Colors.white, 
                      ),
                    ),
                    Text(
                      'Established: ${team['established']}',
                      style: const TextStyle(
                        color: Colors.white, 
                      ),
                    ),
                  ],
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(team['logo']),
                  radius: 25, 
                ),
                trailing: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                onTap: () {
                  onTeamTap(
                    team['id'], index,
                  ); 
                },
              ),
            );
          },
        ),
      );
    }
  }
}


class PlayerListBuilder {
  static Widget buildPlayersList(List<Map<String, dynamic>> playersData) {
    if (playersData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
          // appBar: AppBar(
            
          //   title: const Text (
          //     'Players Data',
          //   style: TextStyle(fontWeight: FontWeight.bold)
          //   ),
          // ),
          body: ListView.builder(
            itemCount: playersData.length,
            itemBuilder: (BuildContext context, int index) {
              final player = playersData[index];
              return Card(
                color: const Color(0xFF002868),
                elevation: 3, 
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    player['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, // Bold player name
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
                        style: TextStyle(
                          color: Colors.grey[600], // Subtitle text color
                        ),
                      ),
                      const SizedBox(height: 2), // Add vertical spacing
                      Text(
                        'Age: ${player['age']}',
                        style: TextStyle(
                          color: Colors.grey[600], // Subtitle text color
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
          ),
        ),
      );
    }
  }
}

class LeagueDetailsPage extends StatelessWidget {
  final Map<String, dynamic> league;

  const LeagueDetailsPage({Key? key, required this.league}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('League Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${league['name']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Country: ${league['countryName']} (${league['countryCode']})'),
            const SizedBox(height: 8),
            Text('Season: ${league['seasonYear']}'),
            const SizedBox(height: 8),
            Text('Start Date: ${league['seasonStart']}'),
            const SizedBox(height: 8),
            Text('End Date: ${league['seasonEnd']}'),
            const SizedBox(height: 8),
            Text('Current: ${league['seasonCurrent']}'),
            const SizedBox(height: 8),
            Text('Coverage: ${league['seasonCoverage']}'),
            const SizedBox(height: 8),
            // Add more details here as needed
          ],
        ),
      ),
    );
  }
}




