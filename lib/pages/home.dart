import 'package:app_front/pages/homeContent';
import 'package:app_front/pages/profileContent.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'clients.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF0F0F1E), // Fond sombre
      primaryColor: Colors.red,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F0F1E),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF181828),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white54,
      ),
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),
    ProfileContent(),
    SettingsContent(),
    ClientsContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(
            color: Colors.white, // Couleur du texte
            fontWeight: FontWeight.bold, // Texte en gras
            fontSize: 20.0, // Taille de la police
            fontFamily:
                'Roboto', // Police personnalisée (assurez-vous de l'ajouter dans pubspec.yaml)
          ),
        ),
        centerTitle: true, // Centrer le titre
        backgroundColor:
            const Color(0xFF181828), // Couleur d'arrière-plan sombre
        elevation: 4, // L'ombre sous l'AppBar
        shadowColor: Colors.black, // Couleur de l'ombre
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.notifications,
                    color: Colors.white), // Icône de notifications
                onPressed: () {
                  Scaffold.of(context)
                      .openEndDrawer(); // Ouvre l'EndDrawer (Notifications)
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Action pour l'icône de paramètres
            },
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon:
                  const Icon(Icons.menu, color: Colors.white), // Icône de menu
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Ouvre le Drawer
              },
            );
          },
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF181828),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clients',
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: const Center(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.mail, color: Colors.blue),
              title: const Text('Test'),
              subtitle: const Text('5 mins ago'),
              onTap: () {
                // Action pour cette notification
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF181828),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0F0F1E)),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/user_profile_image.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  'Antonio Renders',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  '@renders.antonio',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text('Profile', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text('Déconnecter',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingsContent extends StatelessWidget {
  const SettingsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Settings Content',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
// 
// class ClientsContent extends StatelessWidget {
  // const ClientsContent({Key? key}) : super(key: key);
// 
  // @override
  // Widget build(BuildContext context) {
    // return const Center(
      // child: Text(
        // 'Clients Content',
        // style: TextStyle(color: Colors.white),
      // ),
    // );
  // }
// }
// 
// class LoginPage extends StatelessWidget {
  // const LoginPage({Key? key}) : super(key: key);
// 
  // @override
  // Widget build(BuildContext context) {
    // return Scaffold(
      // appBar: AppBar(title: const Text('Login')),
      // body: const Center(child: Text('Login Page')),
    // );
  // }
// }
// 