import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'weapon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Star W'Arms",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.yellow, fontSize: 24),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];


  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = ArmsPage();
        break;
      case 2:
        page = AboutPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

   
    return Scaffold(
      appBar: AppBar(
        title: const Text("Star W'Arms"),
      ),
      body: Center(
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.animation),
            label: 'Arms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'About',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.yellow,
        onTap: _onItemTapped,
      ),
    );
  }
}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Pour centrer la colonne verticalement
          children: [
            Text("Coucou"),
          ],
        ),
      ),
    );
  }
}
class ArmsPage extends StatefulWidget {
  @override
  State<ArmsPage> createState() => _ArmsPageState();
}

class _ArmsPageState extends State<ArmsPage> {
  List<Weapon> allWeapons = [];
  String selectedCategory = 'sabre';

  @override
  void initState() {
    super.initState();
    loadWeapons();
  }

  Future<void> loadWeapons() async {
    final String response = await rootBundle.loadString('assets/weapons.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      allWeapons = data.map((e) => Weapon.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Weapon> filteredWeapons =
        allWeapons.where((w) => w.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Armes Star Wars"),
      ),
      body: Column(
        children: [
          // Catégories avec TabBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              isSelected: [
                selectedCategory == 'sabre',
                selectedCategory == 'blaster',
                selectedCategory == 'vaisseaux',
              ],
              onPressed: (index) {
                setState(() {
                  selectedCategory = ['sabre', 'blaster', 'vaisseaux'][index];
                });
              },
              children: const [
                Padding(padding: EdgeInsets.all(8.0), child: Text('Sabres')),
                Padding(padding: EdgeInsets.all(8.0), child: Text('Blasters')),
                Padding(padding: EdgeInsets.all(8.0), child: Text('Vaisseaux')),
              ],
            ),
          ),

          // Liste des armes
          Expanded(
            child: ListView.builder(
              itemCount: filteredWeapons.length,
              itemBuilder: (context, index) {
                final weapon = filteredWeapons[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(
                      weapon.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      weapon.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(weapon.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${weapon.name} liké !')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Pour centrer la colonne verticalement
          children: [
            Text("C'est mwaaa"),
          ],
        ),
      ),
    );
  }
}



