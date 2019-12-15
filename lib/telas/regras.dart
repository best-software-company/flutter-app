import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_tasks/main.dart';
import 'package:home_tasks/model/regra.dart';
import 'package:home_tasks/model/usuario.dart';
import 'package:home_tasks/service/service.dart';
import 'package:home_tasks/telas/menu.dart';

class Regras extends StatefulWidget {
  @override
  _RegrasState createState() => _RegrasState();
}

class _RegrasState extends State<Regras> {
  Service service = new Service();
  List<Regra> rules = List();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var nome = TextEditingController();
  var descricao = TextEditingController();
  var data = TextEditingController();
  var valor =  TextEditingController();
  Usuario user = new Usuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Text('Regras'),
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
         criarTarefa(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      body: new RefreshIndicator(
        child: carrega(),
        onRefresh: _handleRefresh,
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    //atualiza
      regras();
      setState((){});
    return null;
  }

  Widget carrega(){
    return FutureBuilder(
    future: service.getUser(),
      builder: (context,snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              this.user = snapshot.data;
              return regras();
            }
        }
      },
    );
  }

  Widget regras(){
    return FutureBuilder(
      future: service.getRules(),
      builder: (context,snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              rules = snapshot.data;
              //lista de card
              return rules != null ? listRules() : Text('Não há regras a serem exibidas.');
            }
        }
      },
    );
  }

  Widget listRules(){
    return ListView.builder (
      itemCount: rules.length,
      itemBuilder: (BuildContext ctxt, int index) {
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding:EdgeInsets.fromLTRB(25,0,25,0),
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding:EdgeInsets.fromLTRB(25,0,25,0),
                    child: Text('Nome: '+rules[index].nome,style: TextStyle(fontSize: 15),)),
                  Padding(
                    padding:EdgeInsets.fromLTRB(25,0,25,0),
                    child: Text('Descrição: '+rules[index].descricao,style: TextStyle(fontSize: 13))),
                  Padding(
                    padding:EdgeInsets.fromLTRB(25,0,25,0),
                    child: Text('Última atualização por: '+rules[index].idUsuario,style: TextStyle(fontSize: 13))),
                  Padding(
                    padding:EdgeInsets.fromLTRB(25,0,25,0),
                    child: Text('Data: '+rules[index].data,style: TextStyle(fontSize: 13))),
                  Padding(
                    padding:EdgeInsets.fromLTRB(25,0,25,0),
                    child: Text('Valor da multa: '+rules[index].valor.toString(),style: TextStyle(fontSize: 13))),
                  rules[index].estado==true ? Padding(
                    padding:EdgeInsets.fromLTRB(25,0,25,0),
                    child: Text('Regra aprovada',style: TextStyle(fontSize: 13))) :
                    Padding(
                      padding:EdgeInsets.fromLTRB(25,0,25,0),
                      child: Text('Regra em análise',style: TextStyle(fontSize: 13)))
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Align(alignment: Alignment.centerRight,
                  child: FlatButton(
                    textColor: Colors.blue,
                    disabledColor: Colors.blue,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.fromLTRB(8,0,8.0,0),
                    splashColor: Colors.blue[50],
                    child: Text('Editar'), 
                    onPressed: () async {
                      //chama outra função
                      setRules(rules[index]);
                      editarRegra(context, rules[index]);
                    },
                  )
                ),
                this.user.perfil=='responsavel' && rules[index].estado==false ? Align(alignment: Alignment.centerRight,
                  child: FlatButton(
                    textColor: Colors.blue,
                    disabledColor: Colors.blue,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.fromLTRB(8,0,8.0,0),
                    splashColor: Colors.blue[50],
                    child: Text('Aprovar'), 
                    onPressed: () async {
                      
                      rules[index].estado = true;
                      bool ver = await service.putRules(rules[index]);
                      if(ver == true) {
                        Fluttertoast.showToast(
                          msg: "Regra aprovada com sucesso",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1
                        );
                        _handleRefresh();
                      }
                      else{
                        Fluttertoast.showToast(
                          msg: "Regra não pode ser aprovada",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1
                        );
                      }
                    },
                  )
                ): Text(''),
              ],
            )
            
            ],
          ),
        );
      }
    );
  }

  setRules(Regra regra){
    nome.text = regra.nome;
    descricao.text = regra.descricao;
    data.text = regra.data;
    valor.text = regra.valor.toString();
  }

  criarTarefa(BuildContext context) { 
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(child:AlertDialog(
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Adicionar regra'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nome,
                    keyboardType: TextInputType.text,
                    validator: (nome) => nome.isEmpty ? 'Name cannot be blank':null,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Nome da regra: ',
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: descricao,
                    keyboardType: TextInputType.text,
                    validator: (descricao) => descricao.isEmpty ? 'Description cannot be blank':null,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Descrição: ',
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: data,
                    keyboardType: TextInputType.phone,
                    validator: (data) => data.isEmpty ? 'Date cannot be blank':null,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Data: ',
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: valor,
                    keyboardType: TextInputType.number,
                    validator: (valor) => valor.isEmpty ? 'Price cannot be blank':null,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Valor: ',
                    )
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text("Criar"),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Regra regra = new Regra();
                            regra.nome = nome.text;
                            regra.descricao = descricao.text;
                            regra.estado = true;
                            regra.data = data.text;
                            regra.valor = int.parse(valor.text.toString());
                            bool ver = await service.postRule(regra);
                            if(ver == true) {
                              Fluttertoast.showToast(
                                msg: "Regra criada com sucesso",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1
                              );
                              nome.text = '';
                              descricao.text = '';
                              data.text = '';
                              valor.text = '';
                              _handleRefresh();
                              Navigator.of(context).pop();
                            }
                            else{
                              Fluttertoast.showToast(
                                msg: "Regra não pode ser criada",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1
                              );
                            }
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
      },
    );
  }

  editarRegra(BuildContext context, Regra regraEdit) { 
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(child:AlertDialog(
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Editar regra'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nome,
                    keyboardType: TextInputType.text,
                    validator: (nome) => nome.isEmpty ? 'Name cannot be blank':null,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Nome: ',
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: descricao,
                    keyboardType: TextInputType.text,
                    validator: (descricao) => descricao.isEmpty ? 'Description cannot be blank':null,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Descrição: ',
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: data,
                    keyboardType: TextInputType.phone,
                    validator: (data) => data.isEmpty ? 'Date cannot be blank':null,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Data: ',
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: valor,
                    keyboardType: TextInputType.number,
                    validator: (valor) => valor.isEmpty ? 'Price cannot be blank':null,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Valor: ',
                    )
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text("Editar"),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Regra rule = new Regra();
                            rule.idRegra = regraEdit.idRegra;
                            rule.idUsuario = regraEdit.idUsuario;
                            rule.estado = regraEdit.estado;
                            rule.idCasa = regraEdit.idCasa;
                            rule.nome = nome.text;
                            rule.descricao = descricao.text;
                            rule.data = data.text;
                            rule.valor = int.parse(valor.text.toString());
                            bool ver = await service.putRules(rule);
                            if(ver == true) {
                              Fluttertoast.showToast(
                                msg: "Regra editada com sucesso",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1
                              );
                              nome.text = '';
                              descricao.text = '';
                              data.text = '';
                              valor.text = '';
                              _handleRefresh();
                              Navigator.of(context).pop();
                            }
                            else{
                              Fluttertoast.showToast(
                                msg: "Regra não pode ser editada",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1
                              );
                            }
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                )
                
              ],
            ),
          ),
        ));
      },
    );
  }
  //popup
}