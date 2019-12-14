import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_tasks/model/usuario.dart';
import 'package:home_tasks/service/service.dart';
import 'package:home_tasks/telas/perfil.dart';

class VisualizarPerfil extends StatefulWidget {
  VisualizarPerfil({Key key, this.usuario}) : super(key: key);
  final String usuario;

  @override
  _VisualizarPerfilState createState() => _VisualizarPerfilState();
}

class _VisualizarPerfilState extends State<VisualizarPerfil> {
  final _formKey = GlobalKey<FormState>();
  var _email = TextEditingController();
  var _nome = TextEditingController();
  var _usuario = TextEditingController();
  var _data = TextEditingController();
  var _telefone = TextEditingController();
  var _perfil = TextEditingController();
  String _genero;

  bool putUser = false;
  List<Usuario> user;
  Future<List<Usuario>> futureUser;
  Service service = new Service();

  @override
  initState(){
    super.initState();
    futureUser = service.getUsers(this.widget.usuario);
  }

  update() async{
    user = await futureUser;
    
    _email.text = user[0].email;
    _nome.text = user[0].nome;
    _usuario.text = user[0].idUsuario;
    _data.text = user[0].data;
    _telefone.text = user[0].telefone;
    _perfil.text = user[0].perfil;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Visualizar perfil'),
      centerTitle: true,
      ),
      body: FutureBuilder(
        future: futureUser,
        builder: (context,snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new Text('loading...');
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else {
                update();
                
                return createView(context, snapshot);
              }
                
          }
        },
      ),
    );
  }

  Widget createView(BuildContext context, AsyncSnapshot snapshot){
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, 
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0), 
              TextFormField(
                controller: _nome,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Nome completo",
                ),
              ),
              SizedBox(height: 20.0), 
                TextFormField(
                controller: _email,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Email",
                ),
              ),
              SizedBox(height: 20.0), 
              TextFormField(
                controller: _usuario,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Usuario",
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _data,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Data de nascimento",
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _telefone,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Telefone",
                ),
              ),
              SizedBox(height: 20.0), 
              TextFormField(
                controller: _perfil,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Perfil",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}