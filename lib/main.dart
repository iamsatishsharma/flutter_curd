import 'package:flutter/material.dart';
import 'package:flutter_curd/view/home_screen.dart';
import 'sql_helper.dart';
import './model/Persons.dart';
/*
//This class created by Satish Sharma
//Date: 07-05-2023
//Flutter Sqlite CRUD Operation works with Example code
 */
void main() {
  runApp(MyApp());
}

const darkBlueColor = Color(0xff486579); //App theme

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enter Person details - CURD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       // primaryColor: Colors.orange,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Enter Person details - CURD'),
    );
  }
}

//Add home page
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required String title}) : super(key: key);

 String get title => "Enter Person details - CURD";

  @override
  State<MyHomePage> createState() => MyHomePageState();
}
