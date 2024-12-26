import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    print("database star initial");
    if (_database != null) return _database!;

    // Initialisation de la base de données
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
final toto=await getDatabasesPath();
        print("database star initial2${toto}");

    String path = join(await getDatabasesPath(), 'my_database.db');
        print("database star initial3");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Méthode pour créer la base de données et ses tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE my_table(id INTEGER PRIMARY KEY, name TEXT)',
    );
  }

  // Exemple de méthode pour insérer des données
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('my_table', row);
  }

  // Exemple de méthode pour récupérer des données
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await database;
    return await db.query('my_table');
  }

  // Autres méthodes CRUD (Update, Delete) peuvent être ajoutées ici
}
