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
  Set<String> likedWeapons = {};

  void toggleLike(String weaponName) {
    setState(() {
      if (likedWeapons.contains(weaponName)) {
        likedWeapons.remove(weaponName);
      } else {
        likedWeapons.add(weaponName);
      }
    });
  }


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
        page = ArmsPage(likedWeapons: likedWeapons, onLikeToggle: toggleLike);
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
      appBar: AppBar(title: Text("Accueil")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/hero.webp", width: 300),
              SizedBox(height: 20),
              Text(
                "Bienvenue sur cette application",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Vous allez pouvoir découvrir sur cette application les différentes armes utilisées dans l'univers Star Wars",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class ArmsPage extends StatefulWidget {
  final Set<String> likedWeapons;
  final Function(String) onLikeToggle;

  const ArmsPage({Key? key, required this.likedWeapons, required this.onLikeToggle}) : super(key: key);

  @override
  State<ArmsPage> createState() => _ArmsPageState();
}

class _ArmsPageState extends State<ArmsPage> {
  List<Weapon> allWeapons = [];
  String selectedCategory = 'sabre';
  bool showOnlyLiked = false; 

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

  void showWeaponDetails(Weapon weapon) {
    showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: Text(weapon.name, style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(weapon.image, width: 200, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text("Description: ${weapon.description}", style: TextStyle(fontSize: 14, color: Colors.black)),
            const SizedBox(height: 5),
            Text("Première Apparition: ${weapon.apparition}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 5),
            Text("Utilisé par: ${weapon.utilisateur}", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Fermer"),
        ),
      ],
    );
  },
);

  }

  @override
  Widget build(BuildContext context) {
    List<Weapon> filteredWeapons = allWeapons
        .where((w) => w.category == selectedCategory)
        .toList();

    if (showOnlyLiked) {
      filteredWeapons =
          filteredWeapons.where((w) => widget.likedWeapons.contains(w.name)).toList();
    }

    return Scaffold(
      body: Column(
        children: [
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
              selectedColor: Colors.yellow, 
              color: Colors.white,
              children: const [
                Padding(padding: EdgeInsets.all(8.0), child: Text('Sabres')),
                Padding(padding: EdgeInsets.all(8.0), child: Text('Blasters')),
                Padding(padding: EdgeInsets.all(8.0), child: Text('Vaisseaux')),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Afficher les favoris", style: TextStyle(fontSize: 16)),
                Switch(
                  value: showOnlyLiked,
                  onChanged: (value) {
                    setState(() {
                      showOnlyLiked = value;
                    });
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: filteredWeapons.isEmpty
                ? const Center(
                    child: Text(
                      "Aucune arme trouvée.",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredWeapons.length,
                    itemBuilder: (context, index) {
                      final weapon = filteredWeapons[index];
                      final isLiked = widget.likedWeapons.contains(weapon.name);

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
                          subtitle: Text(
                            weapon.description.length > 40
                                ? weapon.description.substring(0, 40) + '...'  
                                : weapon.description, 
                            overflow: TextOverflow.ellipsis, 
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : null,
                            ),
                            onPressed: () {
                              widget.onLikeToggle(weapon.name);
                            },
                          ),
                          onTap: () {
                            showWeaponDetails(weapon);
                          },
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
      appBar: AppBar(title: Text("À propos")),
      body: Center( // Ajout de Center pour centrer verticalement
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Permet d'éviter un espace trop grand
          children: [
            Text(
              "À propos de l'application",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Cette application a été codée par Yoda en Flutter. Elle vous permet de découvrir les différentes armes utilisées dans l'univers Star Wars.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
    );
  }
}



