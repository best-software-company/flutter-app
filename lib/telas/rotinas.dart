import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_tasks/main.dart';
import 'package:home_tasks/model/rotina.dart';
import 'package:home_tasks/service/service.dart';
import 'menu.dart';

class Rotinas extends StatefulWidget {
  @override
  _RotinasState createState() => _RotinasState();
}

class _RotinasState extends State<Rotinas> {
  Service service = new Service();
  List<Rotina> rotinas = List();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var nome = TextEditingController();
  var descricao = TextEditingController();
  var data = TextEditingController();
  var valor =  TextEditingController();

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
         criarRotina(context);
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
      carrega();
      setState((){});
    return null;
  }

  Widget carrega(){
    return FutureBuilder(
    future: service.getRotinas(),
      builder: (context,snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              this.rotinas = snapshot.data;
              return this.rotinas!=null ? listRules(): Text('Sem rotinas a serem exibidas.');
            }
        }
      },
    );
  }
  
  Widget listRules(){
    return ListView.builder (
      itemCount: rotinas.length,
      itemBuilder: (BuildContext ctxt, int index) {
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding:EdgeInsets.fromLTRB(25,10,25,10),
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding:EdgeInsets.fromLTRB(25,10,25,10),
                    child: Text('Nome: '+rotinas[index].nome,style: TextStyle(fontSize: 15),)),
                  Padding(
                    padding:EdgeInsets.fromLTRB(25,10,25,10),
                    child: Text('Descrição: '+rotinas[index].descricao,style: TextStyle(fontSize: 13))),
                  Padding(
                    padding:EdgeInsets.fromLTRB(25,10,25,10),
                    child: Text('Validade: '+rotinas[index].validade,style: TextStyle(fontSize: 15),)),
                  rotinas[index].alternar == true ? Padding(
                    padding:EdgeInsets.fromLTRB(25,10,25,10),
                    child: Text('Alternar',style: TextStyle(fontSize: 13))) :
                    Padding(
                    padding:EdgeInsets.fromLTRB(25,10,25,10),
                    child: Text('Não Alternar',style: TextStyle(fontSize: 13))),
                ],
              ),
            ),
            ],
          ),
        );
      }
    );
  }

  criarRotina(BuildContext context) { 
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
                  child: Text('Criar rotina'),
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
                      labelText: 'Validade: ',
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
                            Rotina roti = new Rotina();
                            roti.nome = nome.text;
                            roti.descricao = descricao.text;
                            roti.validade =  data.text;
                            roti.alternar = true;
                            bool ver = await service.postRotine(roti);
                            if(ver == true) {
                              Fluttertoast.showToast(
                                msg: "Rotina criada com sucesso",
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
                                msg: "Rotina não pode ser criada",
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
}