import 'package:flutter/material.dart';
import 'package:home_tasks/main.dart';
import 'package:home_tasks/model/usuario.dart';
import 'package:home_tasks/service/service.dart';
import 'package:home_tasks/telas/buscar_perfils.dart';
import 'package:home_tasks/telas/edit_perfil.dart';
import 'menu.dart';
import 'dart:async';

class Perfil extends StatefulWidget {

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil>  {
  Service service = Service();
  Usuario user = Usuario();

  Future<Usuario> pegarUsuario() async {
    user = await service.getUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Text('Perfil'),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.exit_to_app),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginRegister()));
              },
          ),
        ],
      ),
      body: FutureBuilder(
        future: pegarUsuario(),
        builder: (context,snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new Text('loading...');
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return createCard(context, snapshot);
          }
        },
      ),
    );
  }

  Widget createCard(BuildContext context, AsyncSnapshot snapshot) {
    user = snapshot.data;
    return ListView(
      children: <Widget>[
        //pesquisar perfils
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(
                'https://picsum.photos/250?image=9',
              ),
              Padding(
                padding:EdgeInsets.fromLTRB(25,0,25,0),
                child: ListTile(
                  title: Text('Nome: '+user.nome),
                  subtitle: Text('Perfil: '+user.perfil),
                ),
              ),
              Align(alignment: Alignment.centerRight,
                child:FlatButton(
                  textColor: Colors.blue,
                  disabledColor: Colors.blue,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.fromLTRB(8,0,8.0,0),
                  splashColor: Colors.blue[50],
                  child: Text('Visualizar/editar.'), 
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditPerfil()));
                  },
                )
              )
            ],
          ),
        ),
        FlatButton(
          textColor: Colors.blue,
          disabledColor: Colors.blue,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.fromLTRB(8,0,8.0,0),
          splashColor: Colors.blue[50],
          child: Text('Buscar outros perfils.'), 
          onPressed: () async{
           //await service.getUsers('luluzinha');
            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPerfils()));
          },
        ),
      ],
    );
  }
}