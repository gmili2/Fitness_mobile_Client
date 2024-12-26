import 'dart:math';
import 'dart:convert';
import 'package:app_front/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async'; // Import the dart:async library
import 'pages/home.dart'; // Import the HomePage class from the separate file
import 'db/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:localstorage/localstorage.dart';

void main() async {
  await initLocalStorage();

  WidgetsFlutterBinding.ensureInitialized();
  bool hasInternetConnection = await _checkInternetConnection();

  runApp(MyApp(hasInternetConnection: hasInternetConnection));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

final UserController controller = UserController(); // Instance du contrôleur

class _SplashScreenState extends State<SplashScreen> {
  @override
  Future<void> _loadData() async {
    bool isLogin = false;
    String? isLoginLocal = localStorage.getItem('isLogin');
    String username = localStorage.getItem("username") ?? '';
    String password = localStorage.getItem("password") ?? '';
    try {
      final response = await controller.loginUser(username, password);
      localStorage.setItem("access_token", response['access_token']);
      isLogin = true;
      final responseMe = await controller.me();
      print("response mee hahah${responseMe}");
      localStorage.setItem("user", jsonEncode(responseMe));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => isLogin ? HomePage() : LoginPage()),
      );
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Couleur de l'arrière-plan rouge
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Afficher le logo noir depuis une URL avec NetworkImage
            Image(
              image: NetworkImage(
                  'https://img.freepik.com/photos-premium/salle-sport-sombre-lumieres-rouges-fond-noir_876956-1224.jp2g'), // Remplacez par l'URL de votre logo noir
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Your Fitness',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> _checkInternetConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  print("connectivityResult");
  print(connectivityResult);
  return connectivityResult != ConnectivityResult.none;
}

class MyApp extends StatelessWidget {
  final bool hasInternetConnection;

  const MyApp({Key? key, required this.hasInternetConnection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen());
  }
}

class NoInternetConnectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: NoInternetConnectionWidget(
          onRefresh: () async {
            bool hasInternetConnection = await _checkInternetConnection();
            if (hasInternetConnection) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          },
        ),
      ),
    );
  }
}

class NoInternetConnectionWidget extends StatelessWidget {
  final VoidCallback onRefresh;

  const NoInternetConnectionWidget({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('No Internet Connection'),
        ElevatedButton(
          onPressed: onRefresh,
          child: Text('Refresh'),
        ),
      ],
    );
  }
}
