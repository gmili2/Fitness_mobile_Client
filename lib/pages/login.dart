import 'package:app_front/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:localstorage/localstorage.dart';

Future<Database> initDatabase() async {
  String path = join(await getDatabasesPath(), 'example.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT)',
      );
    },
    version: 1,
  );
}

Future<void> insertItem(Database db, Map<String, dynamic> item) async {
  await db.insert(
    'items',
    item,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Map<String, dynamic>>> getItems(Database db) async {
  return await db.query('items');
}

final UserController controller = UserController(); // Instance du contrôleur

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/test.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Card(
            margin: EdgeInsets.all(20),
            color: Colors.black.withOpacity(
                0.6), // Ajout d'une couleur sombre semi-transparente pour contraster avec l'image
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

Future<Map<String, dynamic>> loginUsertest(
    String username, String password) async {
  try {
    final response = await controller.loginUser(username, password);
    return response;
  } catch (e) {
    throw Exception('Échec de la connexion: ${e}');
  }
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              icon: Icon(Icons.person, color: Colors.red), // Icon rouge
              labelStyle: TextStyle(color: Colors.white), // Label blanc
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red), // Bordure rouge
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              icon: Icon(Icons.lock, color: Colors.red), // Icon rouge
              labelStyle: TextStyle(color: Colors.white), // Label blanc
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red), // Bordure rouge
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await initLocalStorage();

              if (_formKey.currentState?.validate() ?? false) {
                // Form is valid, check credentials
                String username = _usernameController.text;
                String password = _passwordController.text;
                localStorage.setItem("username", username);
                localStorage.setItem("password", password);

                setState(() {
                  isLoading = true; // Change le texte du bouton à "Loading"
                });
                try {
                  final response = await loginUsertest(username, password);
                  localStorage.setItem("isLogin", "true");
                  //admin@example.com
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login successful for $username'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Redirect to Home page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Incorrect username or password.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                setState(() {
                  isLoading = false; // Change le texte du bouton à "Loading"
                });
              } else {
                // Form is not valid, highlight the fields in red
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill in all the required fields.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.red), // Couleur rouge pour le bouton
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(16.0)), // Ajustez le padding si nécessaire
            ),
            child: Container(
              width: double.infinity,
              child: Center(
                child: !isLoading
                    ? Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white, // Texte blanc
                          fontSize: 18.0, // Taille du texte
                          fontWeight:
                              FontWeight.bold, // Ajustez le poids de la police
                        ),
                      )
                    : SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
