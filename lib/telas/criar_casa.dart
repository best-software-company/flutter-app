import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_tasks/model/casa.dart';
import 'package:home_tasks/model/usuario.dart';
import 'package:home_tasks/service/service.dart';
import 'package:home_tasks/telas/casa.dart';
import 'package:home_tasks/telas/perfil.dart';

class CriarCasa extends StatefulWidget {

  @override
  _CriarCasaState createState() => _CriarCasaState();
}

class _CriarCasaState extends State<CriarCasa> {
  final _formKey = GlobalKey<FormState>();
  var _nome = TextEditingController();
  var _endereco = TextEditingController();
  var _aluguel = TextEditingController();
  var _descricao = TextEditingController();

  Casa home = new Casa();
  Service service = new Service();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Visualizar casa'),
      centerTitle: true,
      ),
      body: createEdit(),
    );
  }

  Widget createEdit(){
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
                keyboardType: TextInputType.text,
                validator: (_nome) => _nome.isEmpty ? 'Name cannot be blank':null,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Nome da casa",
                ),
              ),
              SizedBox(height: 20.0), 
              TextFormField(
                controller: _endereco,
                keyboardType: TextInputType.text,
                validator: (_endereco) => _endereco.isEmpty ? 'Endereço cannot be blank':null,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Endereço",
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _aluguel,
                keyboardType: TextInputType.number,
                validator: (_aluguel) => _aluguel.isEmpty ? 'Aluguel cannot be blank':null,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Aluguel",
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _descricao,
                keyboardType: TextInputType.text,
                validator: (_descricao) => _descricao.isEmpty ? 'Description cannot be blank':null,
                autofocus: false,
                decoration: new InputDecoration(
                  labelText: "Descrição",
                ),
              ),
              SizedBox(height: 20.0),
              RaisedButton(child: Text("Atualizar"), onPressed: () async {
                final form = _formKey.currentState;
                form.save();
                home.nome = _nome.text;
                home.endereco = _endereco.text;
                home.aluguel = int.parse(_aluguel.text);
                home.descricao = _descricao.text;

                if (form.validate()) {
                  //verifica se foi criado o usuario
                  bool ver = await service.postCasa(home);
                  if(ver){
                    Fluttertoast.showToast(
                      msg: "Casa criada com sucesso.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CasaTela()),);
                  }
                  else{
                    Fluttertoast.showToast(
                      msg: "Erro ao criar casa.",
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