import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gender_selector/gender_selector.dart';
import 'package:home_tasks/model/usuario.dart';
import 'package:home_tasks/service/service.dart';
import 'package:home_tasks/telas/tarefas.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  var _password = TextEditingController();
  var _email = TextEditingController();
  var _nome = TextEditingController();
  var _usuario = TextEditingController();
  var _data = TextEditingController();
  var _telefone = TextEditingController();
  String _genero;
  bool newUser = false;
  Usuario user = new Usuario();
  Service service = new Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Registro'),
      automaticallyImplyLeading: false,
      centerTitle: true,
      ),
      body: Center(
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
                  controller: _password,
                  keyboardType: TextInputType.text,
                  validator: (_password) => _password.isEmpty ? 'Password cannot be blank':null,
                  obscureText: true,
                  autofocus: false,
                  decoration: new InputDecoration(
                    labelText: "Senha",
                  ),
                ),
                SizedBox(height: 20.0), 
                Text('Genero'),
                SizedBox(height: 20.0), 
                GenderSelector(
                  maletxt: "", //default Male
                  femaletxt: "", //default Female
                  onChanged: (gender) {
                    _genero = gender.toString();
                    print(_genero);
                  },
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
                RaisedButton(child: Text("Registrar-se"), onPressed: () async {
                  final form = _formKey.currentState;
                  form.save();
                  user.idUsuario = _usuario.text;
                  user.senha = _password.text;
                  user.nome = _nome.text;
                  user.email = _email.text;
                  user.genero = _genero;
                  user.data = _data.text;
                  user.perfil = 'Nenhuma residencia cadastrada neste perfil';
                  user.telefone = _telefone.text;

                  if (form.validate()) {
                    //verifica se foi criado o usuario
                    newUser = await service.postUser(user);
                    if(newUser){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Tarefas()),);
                    }
                    else{
                      Fluttertoast.showToast(
                        msg: "Erro ao registrar usuário.",
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
      ),
    );
  }
}
