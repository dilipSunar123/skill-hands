// import 'dart:ffi';

// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// import 'skill_hands_model.dart';

// class DatabaseConnect {
//   Database? _database;

//   // create a getter and open a connection to db
//   Future<Database> get database async {
//     // location of db
//     final dbPath = await getDatabasesPath();
//     const dbName = 'skill_hands.db';

//     final path = join(dbPath, dbName);

//     _database = await openDatabase(
//       path, 
//       version: 1, 
//       onCreate: _createDB
//     );

//     return _database!;
//   }

//   Future<void> _createDB(Database db, int version) async {
//     await db.execute
//     (
//       '''
//         CREATE TABLE skill_hands(
//           id INTEGER PRIMARY KEY AUTOINCREMENT, 
//           name TEXT, 
//           contact_number TEXT, 
//           email TEXT, 
//           password TEXT
//         )
//       '''
//     );
//   }

//   Future<void> addAccount(SkillHandsModel skillHandsModel) async {
//     final db = await database;

//     await db.insert(
//       'skill_hands', 
//       skillHandsModel.toMap(),
//       conflictAlgorithm:
//         ConflictAlgorithm.replace,
//     );
//   }

//   Future<void> removeAccount(SkillHandsModel skillHandsModel) async {
//     final db = await database;

//     await db.delete(
//       'skill_hands', 
//       where: 'id = ?', 
//       whereArgs: [skillHandsModel.id],
//     );
//   }

//   Future<List<SkillHandsModel>> getSkillHands() async {
//     final db = await database;

//     List<Map<String, dynamic>> items = await db.query(
//       'skill_hands', 
//       orderBy: 'id DESC',
//     );

//     return List.generate(
//       items.length, 
//       (index) => SkillHandsModel(
//         id: items[index]['id'],
//         name: items[index]['name'], 
//         contact_number: items[index]['contact_number'], 
//         email: items[index]['email'], 
//         password: items[index]['password'])
//     );
//   }


//   // Future<List<String>> getEmailList() async {
//   //   final db = await database;

//   //   var dbClient = await db;
//   //   List<Map<String, dynamic>> res = await dbClient.query('skill_hands');

//   //   List<String> list = res.map<String>((e) => e['email'].toString()).toList();

//   //   return list;
//   // }
// }