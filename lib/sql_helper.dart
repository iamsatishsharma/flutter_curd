import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import './model/Persons.dart';

//This class created by Satish Sharma
//Date: 07-05-2023
//Flutter Sqlite CRUD Operation works with Example code


//It’s just a SQLHelper Class making which we do in every OOP language.
class SQLHelper {
/*
getDataBase() function takes 3 arguments and gives us a database which we again return to our future function.
String path of the Database
Version
onCreate Function
*/

  static  String _tableName = "persondetails";

  static Future<Database> getDataBase() async {
    return openDatabase(
      join(await getDatabasesPath(), "personsDatabase.db"),
      onCreate: (db, version) async {
        await db.execute(
       //   "CREATE TABLE $_tableName (id TEXT PRIMARY KEY, name TEXT, age TEXT, address TEXT, description TEXT)",
          "CREATE TABLE $_tableName (id TEXT PRIMARY KEY, name TEXT, age TEXT, address TEXT)",

        );
      },
      version: 1,
    );
  }


//============================= START CURD ===================================

//============================================================================
//Insert/Add Method
// First Insert Function Which will take values and add them inside the Database
  static Future<int> insertPerson(Person person) async {
    int userId = 0;
    Database db = await getDataBase();
    String path = await getDatabasesPath();
    print('''getDatabasesPath: ${path}''');

    await db.insert( _tableName, person.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      userId = value;
    });
    return userId;
  }


//============================================================================
//Get All Method
//After adding data then comes the part where we need data and show it into the UI.
//first there is a need for a database and then db.query method provides all the rows in the provided table inside the query() method.

  static Future<List<Person>> getAllPersons() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> personsMap = await db.query(_tableName);
    return List.generate(personsMap.length, (index) {
      return Person(
          id: personsMap[index]["id"],
          name: personsMap[index]["name"],
          age: personsMap[index]["age"],
          address: personsMap[index]["address"]);
    });
  }

//============================================================================
//Get method:
//This will return a Single user by using Where in the SQL query. For this, we need to pass the userID while calling this function.

  static Future<Person> getPerson(String userId)async{
    Database db = await getDataBase();
    List<Map<String, dynamic>> person = await db.rawQuery("SELECT * FROM $_tableName WHERE id = $userId");
    if(person.length == 1){
      return Person(
          id: person[0]["id"],
          name: person[0]["name"],
          age: person[0]["age"],
          address: person[0]["address"]);
    } else {
      return Person();
    }
  }

//============================================================================
//Update Method
//Updating a particular person needs UserId and new values in the function when calling it. Here is the function for that below.
//Need to add an Update query and give it the table and updated values where id = userId.

  static Future<void> updatePerson(String userId, String name, String age, String address) async {
    Database db = await getDataBase();
    db.rawUpdate("UPDATE $_tableName SET name = '$name', age = '$age', address = '$address' WHERE id = '$userId'");
  }

//============================================================================
//Delete method

  static Future<void> deletePerson(String userId) async {
    Database db = await getDataBase();
    await db.rawDelete("DELETE FROM $_tableName WHERE id = '$userId'");
  }

  //Now get the ID of the last row inserted:
  static Future<int> lastInsertedRowId(String userId) async {
    Database db = await getDataBase();
    await db.execute("select last_insert_rowid()");

    // The row ID is a 64-bit value - cast the Command result to an Int64.
    //Int64 LastRowID64 = (Int64)Command.ExecuteScalar();

   // int lastRowID = (int)LastRowID64;
    return 1;
  }

//
//  Command.CommandText = "select last_insert_rowid()";
//
//  // The row ID is a 64-bit value - cast the Command result to an Int64.
//  //
//  Int64 LastRowID64 = (Int64)Command.ExecuteScalar();
//
//  // Then grab the bottom 32-bits as the unique ID of the row.
//  //
//  int LastRowID = (int)LastRowID64;

//============================= END ===============================================

}


