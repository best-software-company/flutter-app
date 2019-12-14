import 'package:flutter/material.dart';
import 'package:home_tasks/main.dart';
import 'package:home_tasks/telas/menu.dart';

class Regras extends StatefulWidget {
  @override
  _RegrasState createState() => _RegrasState();
}

class _RegrasState extends State<Regras> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Text('Casa'),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.exit_to_app),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginRegister()));
              },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
         
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      body: Text('data')
    );
  }

  //future
  //listview
  //popup
}