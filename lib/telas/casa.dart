import 'package:flutter/material.dart';
import 'package:home_tasks/main.dart';
import 'package:home_tasks/model/usuario.dart';
import 'package:home_tasks/model/casa.dart';
import 'package:home_tasks/service/service.dart';
import 'package:home_tasks/telas/buscar_casas.dart';
import 'package:home_tasks/telas/criar_casa.dart';
import 'package:home_tasks/telas/edit_casa.dart';
import 'menu.dart';
import 'dart:async';

class CasaTela extends StatefulWidget {
  @override
  _CasaTelaState createState() => _CasaTelaState();
}

class _CasaTelaState extends State<CasaTela>  {
  Service service = Service();
  Usuario user = Usuario();
  Casa casa = Casa();
  bool _home = false;
  String idCasa;

  Future<void> pegarUsuario() async {
    user = await service.getUser();
    if(user.idCasa==0) _home = false;
    else{
      _home = true;
      casa = await service.getCasa(user.idCasa);
      idCasa = user.idCasa.toString();
    } 
  }

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
                return _home ? createCard(context, snapshot) : semCasa(context, snapshot);
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
                  title: Text('Nome: '+casa.endereco),
                  subtitle: Text('Descrição: '+casa.descricao),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditCasa(idCasa: int.parse(this.idCasa),)));
                  },
                )
              )
            ],
          ),
        ),
        flatButton(context, snapshot),
      ],
    );
  }

  Widget semCasa(BuildContext context, AsyncSnapshot snapshot){
    return ListView(
      children: <Widget>[
        Align(alignment: Alignment.centerRight,
          child:FlatButton(
            textColor: Colors.blue,
            disabledColor: Colors.blue,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.fromLTRB(8,0,8.0,0),
            splashColor: Colors.blue[50],
            child: Text('Criar uma casa.'), 
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CriarCasa()));
            },
          )
        ),
        flatButton(context, snapshot),
      ],
    );
  }

  Widget flatButton(BuildContext context, AsyncSnapshot snapshot){
    return FlatButton(
      textColor: Colors.blue,
      disabledColor: Colors.blue,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.fromLTRB(8,0,8.0,0),
      splashColor: Colors.blue[50],
      child: Text('Buscar outras casas.'), 
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchHomes(user: user)));
      },
    );
  }
}