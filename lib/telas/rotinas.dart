import 'package:flutter/material.dart';
import 'package:home_tasks/main.dart';
import 'menu.dart';

class Rotinas extends StatefulWidget {
  @override
  _RotinasState createState() => _RotinasState();
}

class _RotinasState extends State<Rotinas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Text('Rotinas'),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.exit_to_app),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginRegister()));
              },
          ),
        ],
      ),
      body: Text('data'),
    );
  }
}