import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:list_ad/databases/helpers/ad_helper.dart';

class DatabaseHelper {
  Database? _db;

  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database?> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'adDatabese.db');

    // try {
    return _db = await openDatabase(path,
        version: 25, onCreate: _onCreateDB, onUpgrade: _onUpgradeDB);
  }

  Future _onCreateDB(Database db, int newVersion) async {
    await db.execute(AdHelper.createScript);
  }

  Future _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute("DROP TABLE ${AdHelper.tableName};");
      await _onCreateDB(db, newVersion);
    }
  }
}
