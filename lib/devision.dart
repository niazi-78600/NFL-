// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:google_fonts/google_fonts.dart';

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'American Football Standings',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: StandingsScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class StandingsScreen extends StatefulWidget {
//   @override
//   _StandingsScreenState createState() => _StandingsScreenState();
// }

// class _StandingsScreenState extends State<StandingsScreen> {
//   List<String> divisions = [];
//   List<String> conferences = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     await Future.wait([fetchDivisions(), fetchConferences()]);
//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> fetchDivisions() async {
//     final url = Uri.parse('https://api-american-football.p.rapidapi.com/standings/divisions?league=2&season=2022');
//     final headers = {
//       'X-RapidAPI-Key': '31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9',
//       'X-RapidAPI-Host': 'api-american-football.p.rapidapi.com',
//     };

//     try {
//       final response = await http.get(url, headers: headers);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           divisions = List<String>.from(data['response']);
//         });
//       } else {
//         throw Exception('Failed to load divisions');
//       }
//     } catch (error) {
//       print(error);
//     }
//   }

//   Future<void> fetchConferences() async {
//     final url = Uri.parse('https://api-american-football.p.rapidapi.com/standings/conferences?league=1&season=2023');
//     final headers = {
//       'X-RapidAPI-Key': '31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9',
//       'X-RapidAPI-Host': 'api-american-football.p.rapidapi.com',
//     };

//     try {
//       final response = await http.get(url, headers: headers);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           conferences = List<String>.from(data['response']);
//         });
//       } else {
//         throw Exception('Failed to load conferences');
//       }
//     } catch (error) {
//       print(error);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.indigo,
//         title: Text(
//           'Divisions & Conferences',
//           style: GoogleFonts.roboto(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SectionTitle(title: 'Divisions', color: Colors.redAccent),
//                   StandingsList(items: divisions),
//                   SizedBox(height: 20),
//                   SectionTitle(title: 'Conferences', color: Colors.greenAccent),
//                   StandingsList(items: conferences),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// class SectionTitle extends StatelessWidget {
//   final String title;
//   final Color color;

//   const SectionTitle({
//     Key? key,
//     required this.title,
//     required this.color,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Text(
//         title,
//         style: GoogleFonts.roboto(
//           fontSize: 28,
//           fontWeight: FontWeight.bold,
//           color: color,
//         ),
//       ),
//     );
//   }
// }

// class StandingsList extends StatelessWidget {
//   final List<String> items;

//   const StandingsList({
//     Key? key,
//     required this.items,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         return Container(
//           margin: EdgeInsets.symmetric(vertical: 8.0),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.indigoAccent, Colors.indigo],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(15.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 2,
//                 blurRadius: 5,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Text(
//                 items[index][0],
//                 style: GoogleFonts.roboto(
//                   color: Colors.indigoAccent,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             title: Text(
//               items[index],
//               style: GoogleFonts.roboto(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class Devision extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'American Football Standings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StandingsScreen(), // Use the BottomNav widget
      debugShowCheckedModeBanner: false,
    );
  }
}

class StandingsScreen extends StatefulWidget {
  @override
  _StandingsScreenState createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  List<String> divisions = [];
  List<String> conferences = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.wait([fetchDivisions(), fetchConferences()]);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchDivisions() async {
    final url = Uri.parse('https://api-american-football.p.rapidapi.com/standings/divisions?league=2&season=2022');
    final headers = {
      'X-RapidAPI-Key': '31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9',
      'X-RapidAPI-Host': 'api-american-football.p.rapidapi.com',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          divisions = List<String>.from(data['response']);
        });
      } else {
        throw Exception('Failed to load divisions');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchConferences() async {
    final url = Uri.parse('https://api-american-football.p.rapidapi.com/standings/conferences?league=1&season=2023');
    final headers = {
      'X-RapidAPI-Key': '31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9',
      'X-RapidAPI-Host': 'api-american-football.p.rapidapi.com',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          conferences = List<String>.from(data['response']);
        });
      } else {
        throw Exception('Failed to load conferences');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color(0xFFF2F2F2),
      // appBar: AppBar(
      // backgroundColor: const Color(0xFF002868), 
      //   title: Text(
      //     'Divisions & Conferences',
      //     style: GoogleFonts.roboto(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      //   ),
      //   leading:const SizedBox(child: Icon(Icons.sports_football, color: Colors.white,),)
      // ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: 'Divisions', color: Color(0xFF002868)),
                    StandingsList(items: divisions),
                    const SizedBox(height: 20),
                    const SectionTitle(title: 'Conferences', color: Color(0xFF002868)),
                    StandingsList(items: conferences),
                  ],
                ),
              ),
            ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final Color color;

  const SectionTitle({Key? key, required this.title, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: GoogleFonts.merriweather(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class StandingsList extends StatelessWidget {
  final List<String> items;

  const StandingsList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            gradient:const LinearGradient(
              colors: [
                Color(0xFF002868), // Primary NFL color
                Color(0xFF002868),
               // Color(0xFFC5CAE9), // Lighter shade for background
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow:[
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                items[index][0],
                style: GoogleFonts.roboto(color: Colors.blueAccent),
              ),
            ),
            title: Text(
              items[index],
              style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
