import 'package:list_ad/database_helpers.dart';
import 'package:list_ad/todo.dart';
import 'package:sqflite/sqflite.dart';

class AdHelper {
  static final String tableName = 'ads';
  static final String idColumn = 'id';
  static final String tituloColumn = 'titulo';
  static final String textColumn = 'texto';
  static final String doneColumn = 'done';
  static final String imagePathColumn = 'imagePath';

  static String get createScript {
    return "CREATE TABLE ${tableName} ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "$tituloColumn TEXT NOT NULL,$textColumn TEXT NOT NULL, $doneColumn INTEGER NOT NULL, $imagePathColumn STRING);";
  }

  //Inserção de um registro
  Future<Ads?> saveAds(Ads ads) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      ads.id = await db.insert(tableName, ads.toMap());
      return ads;
    }
    return null;
  }

  //Recuperar tarrefas - Buscar todas
  Future<List<Ads>?> getAll() async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    List<Map> returnedAds = await db.query(tableName, columns: [
      idColumn,
      tituloColumn,
      textColumn,
      doneColumn,
      imagePathColumn
    ]);

    List<Ads> adss = List.empty(growable: true);
    for (Map ads in returnedAds) {
      adss.add(Ads.fromMap(ads));
    }
    return adss;
  }

  //Inserção de um registro
  Future<Ads?> getById(int id) async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    List<Map> returnedAds = await db.query(tableName,
        columns: [
          idColumn,
          tituloColumn,
          textColumn,
          doneColumn,
          imagePathColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);

    return Ads.fromMap(returnedAds.first);
  }

  // Atualizar um tarefa (todo)???
  Future<int?> editAds(Ads ads) async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    return await db.update(tableName, ads.toMap(),
        where: "$idColumn = ?", whereArgs: [ads.id]);
  }

  Future<int?> deleteAds(Ads ads) async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    return await db
        .delete(tableName, where: "$idColumn = ?", whereArgs: [ads.id]);
  }
}
