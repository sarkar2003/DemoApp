import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class SaveHelper {
  Database? _database;
  List<Map> dataset = [];

  get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initialize();
    return _database;
  }

  Future initialize() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + './SAVE.db';

    var datadb = await openDatabase(path, version: 1, onCreate: _create);

    return datadb;
  }

  Future _create(Database db, int version) async {
    await db.execute('''
    CREATE TABLE SAVE(id INTEGER PRIMARY KEY ,
    DATA JSON NOT NULL,
    IMAGE JSON NOT NULL);
''');
  }

  Future insert(data, imagebits) async {
    Database db = await database;

    var response = await db.insert("SAVE", {"DATA": data, "IMAGE": imagebits});

    print(response);
    return response;
  }

  Future update(id, data, imagebits) async {
    Database db = await database;

    var response = await db.update("SAVE", {"DATA": data, "IMAGE": imagebits},
        where: 'id=?', whereArgs: [id]);

    var response2 = await db.rawQuery('SELECT * FROM SAVE');
    print(response2);
    print("i am here");

    print(response);
    return response;
  }

  Future readdata() async {
    Database db = await database;

    var response = await db.rawQuery('SELECT * FROM SAVE');
    // print(response.toString() + "yes");
    if (response != null) {
      dataset = response;
      // print(dataset);
    } else {
      dataset = [];
    }

    return response;
  }

  Future deletedata(id) async {
    Database db = await database;
    return await db.delete("SAVE", where: 'id=?', whereArgs: [id]);
  }
}
