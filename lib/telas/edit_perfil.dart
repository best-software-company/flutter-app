import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_tasks/model/usuario.dart';
import 'package:home_tasks/service/service.dart';
import 'package:home_tasks/telas/perfil.dart';

class EditPerfil extends StatefulWidget {
  @override
  _EditPerfilState createState() => _EditPerfilState();
}

class _EditPerfilState extends State<EditPerfil> {
  final _formKey = GlobalKey<FormState>();
  var _password = TextEditingController();
  var _email = TextEditingController();
  var _nome = TextEditingController();
  var _usuario = TextEditingController();
  var _data = TextEditingController();
  var _telefone = TextEditingController();
  var _perfil = TextEditingController();
  bool putUser = false;
  Usuario user;
  Future<Usuario> futureUser;
  Service service = new Service();
  
  @override
  initState(){
    super.initState();
    futureUser = service.getUser();
    futureUser.then((res){
      user = res;
      update();
    });
  }

  update() async{
    user = await futureUser;
    _email.text = user.email;
    _nome.text = user.nome;
    _usuario.text = user.idUsuario;
    _data.text = user.data;
    _telefone.text = user.telefone;
    _perfil.text = user.perfil;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Editar/Visualizar perfil'),
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
                return createEdit(context, snapshot);
              }
                
          }
        },
      ),
    );
  }

  Widget createEdit(BuildContext context, AsyncSnapshot snapshot){
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, 
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 20.0), 
              TextFormField(
                controller: _nome,
                keyboardType: TextInputType.text,
                validator: (_nome) => _nome.isEmpty ? 'Name cannot be blank':null,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Nome completo",
                ),
              ),
              SizedBox(height: 20.0), 
                TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: (_email) => _email.isEmpty ? 'Email cannot be blank':null,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Email",
                ),
              ),
              SizedBox(height: 20.0), 
              TextFormField(
                controller: _usuario,
                keyboardType: TextInputType.text,
                validator: (_usuario) => _usuario.isEmpty ? 'Usuario cannot be blank':null,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Usuario",
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _data,
                keyboardType: TextInputType.text,
                validator: (_data) => _data.isEmpty ? 'Data cannot be blank':null,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Data de nascimento",
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _telefone,
                keyboardType: TextInputType.phone,
                validator: (_telefone) => _telefone.isEmpty ? 'Telefone cannot be blank':null,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Telefone",
                ),
              ),
              SizedBox(height: 20.0), 
              TextFormField(
                controller: _perfil,
                keyboardType: TextInputType.text,
                validator: (_perfil) => _perfil.isEmpty ? 'Perfil cannot be blank':null,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Perfil",
                ),
              ),
              SizedBox(height: 20.0),
              RaisedButton(child: Text("Atualizar"), onPressed: () async {
                final form = _formKey.currentState;
                form.save();
                user.idUsuario = _usuario.text;
                //user.senha = _password.text;
                user.nome = _nome.text;
                user.email = _email.text;
                //user.genero = _genero;
                user.data = _data.text;
                user.perfil = _perfil.text;
                user.telefone = _telefone.text;

                if (form.validate()) {
                  //verifica se foi criado o usuario
                  putUser = await service.putUser(user);
                  if(putUser){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Perfil()),);
                  }
                  else{
                    Fluttertoast.showToast(
                      msg: "Erro ao atualizar usuário.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1
                    );
                  }
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}