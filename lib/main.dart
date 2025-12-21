import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

const apiKey = "6bd2d1d33c8dd7aad7116dc6adbc8406";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}

// ---------------- HOME (BOTTOM NAV) ----------------
class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;

  final pages = const [
    LocationPage(),
    SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.my_location), label: "Location"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
      ),
    );
  }
}

// ---------------- PAGE 1 : LOCATION WEATHER ----------------
class LocationPage extends StatefulWidget {
  const LocationPage({super.key});
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Map? forecastData;
  Map? currentData;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future fetch() async {
    await Geolocator.requestPermission();
    Position pos = await Geolocator.getCurrentPosition();

    final forecastUrl =
        "https://api.openweathermap.org/data/2.5/forecast?lat=${pos.latitude}&lon=${pos.longitude}&appid=$apiKey&units=metric";

    final currentUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=${pos.latitude}&lon=${pos.longitude}&appid=$apiKey&units=metric";

    final forecastRes = await http.get(Uri.parse(forecastUrl));
    final currentRes = await http.get(Uri.parse(currentUrl));

    setState(() {
      forecastData = json.decode(forecastRes.body);
      currentData = json.decode(currentRes.body);
    });
  }


  @override
  Widget build(BuildContext context) {
    if (forecastData == null || currentData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final list = forecastData!["list"];
    final totalDays = (list.length / 8).floor();

    return Column(
      children: [
        // 🔝 TOP: CURRENT LOCATION WEATHER
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade100,
          child: Column(
            children: [
              Text(
                currentData!["name"],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "${currentData!["main"]["temp"]}°C",
                style: const TextStyle(fontSize: 30),
              ),
              Text(currentData!["weather"][0]["description"]),
            ],
          ),
        ),

        // 🔽 BELOW: MULTI-DAY FORECAST (PAGINATION)
        Expanded(
          child: ListView.builder(
            itemCount: totalDays,
            itemBuilder: (context, dayIndex) {
              final item = list[dayIndex * 8];

              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Day ${dayIndex + 1}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${item["main"]["temp"]}°C",
                        style: const TextStyle(fontSize: 26),
                      ),
                      Text(item["weather"][0]["description"]),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------- PAGE 2 : SEARCH WEATHER ----------------
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();
  Map? data;

  Future fetch(String city) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    final res = await http.get(Uri.parse(url));
    setState(() => data = json.decode(res.body));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 40),

          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "City or City,Country",
            ),
            onSubmitted: fetch,
          ),

          const SizedBox(height: 30),

          if (data != null && data!["cod"] == 200)
            Column(
              children: [
                Text(
                  data!["name"],
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${data!["main"]["temp"]}°C",
                  style: const TextStyle(fontSize: 30),
                ),
                Text(data!["weather"][0]["description"]),
              ],
            ),

          if (data != null && data!["cod"] != 200)
            Text(data!["message"] ?? "City not found"),
        ],
      ),
    );
  }
}
