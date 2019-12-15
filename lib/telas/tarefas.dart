import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_tasks/main.dart';
import 'package:home_tasks/model/tarefa.dart';
import 'package:home_tasks/service/service.dart';
import 'menu.dart';

class Tarefas extends StatefulWidget {
  @override
  _TarefasState createState() => _TarefasState();
}

class _TarefasState extends State<Tarefas>{
  Service service = Service();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var nome = TextEditingController();
  var descricao = TextEditingController();
  var idResponsavel = TextEditingController();
  String estado;
  var data = TextEditingController();
  var valor =  TextEditingController();
  Tarefa createTask = Tarefa();
  List<Tarefa> tasks = List();
  List<Tarefa> abertas = List();
  List<Tarefa> finalizadas = List();
  int i = 0;


  Future<List<Tarefa>> pegarTarefas(String estado) async {
    tasks = await service.getTasks(estado);
    if(tasks==null){
      return null;
    }
    return tasks;
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    //atualiza
      if(this.i == 1) tarefas('aberta',1);
      else tarefas('finalizada',2);
      setState((){});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        drawer: Menu(),
        appBar: AppBar(
          title: Text('Tarefas'),
          centerTitle: true,
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.exit_to_app),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginRegister()));
                },
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Text('Tarefas abertas'),
              Text('Tarefas finalizadas')
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          criarTarefa(context, "Criar nova tarefa.");
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
        body:  TabBarView(
          children: [
            new RefreshIndicator(
        child:
            tarefas('aberta',1),onRefresh: _handleRefresh,
      ),
            new RefreshIndicator(
        child:
            tarefas('finalizada',2),onRefresh: _handleRefresh,),
          ],
        ),
        
      )
    );
  }

  criarTarefa(BuildContext context, String title) { 
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
                  child: Text('Adicionar tarefa'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nome,
                    keyboardType: TextInputType.text,
                    validator: (nome) => nome.isEmpty ? 'Name cannot be blank':null,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Nome da tarefa: ',
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
                    controller: idResponsavel,
                    keyboardType: TextInputType.text,
                    validator: (idResponsavel) => idResponsavel.isEmpty ? 'User cannot be blank':null,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Usuario: ',
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
                            createTask.nome = nome.text;
                            createTask.descricao = descricao.text;
                            createTask.idResponsavel = idResponsavel.text;
                            createTask.estado = 'aberta';
                            createTask.data = data.text;
                            createTask.valor = int.parse(valor.text.toString());
                            bool ver = await service.postTarefa(createTask);
                            if(ver == true) {
                              Fluttertoast.showToast(
                                msg: "Tarefa criada com sucesso",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1
                              );
                              nome.text = '';
                              descricao.text = '';
                              idResponsavel.text = '';
                              data.text = '';
                              valor.text = '';
                              Navigator.of(context).pop();
                            }
                            else{
                              Fluttertoast.showToast(
                                msg: "Tarefa não pode ser criada",
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

  Widget listTasks(){
    return new ListView.builder (
      itemCount: tasks.length,
      itemBuilder: (BuildContext ctxt, int index) {
      return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding:EdgeInsets.fromLTRB(25,0,25,0),
                child: ListTile(
                  title: Text('Nome: '+tasks[index].nome),
                  subtitle: Text('Descrição: '+tasks[index].descricao),
                ),
              ),
              tasks[index].estado == 'aberta' ? finishButton(tasks[index]) : Text(''),
            ],
          ),
        );
      }
    );
  }

  Widget finishButton(Tarefa taref){
    return Row(
      children: <Widget>[
        Align(alignment: Alignment.centerRight,
          child:FlatButton(
            textColor: Colors.blue,
            disabledColor: Colors.blue,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.fromLTRB(8,0,8.0,0),
            splashColor: Colors.blue[50],
            child: Text('finalizar'), 
            onPressed: () async {
              Tarefa tarefa = new Tarefa();
              tarefa.idTarefa = taref.idTarefa;
              tarefa.estado = 'finalizada';
              bool ver = await service.putTarefa(tarefa);
              if(ver ==true){
                Fluttertoast.showToast(
                  msg: "Tarefa finalizada.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1
                );
                _handleRefresh();
              }
              else {
                Fluttertoast.showToast(
                  msg: "Erro no processo.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1
                );
              }
            },
          )
        ),
        Align(alignment: Alignment.centerRight,
          child:FlatButton(
            textColor: Colors.blue,
            disabledColor: Colors.blue,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.fromLTRB(8,0,8.0,0),
            splashColor: Colors.blue[50],
            child: Text('editar'), 
            onPressed: () async {
              setTasks(taref);
              editarTarefa(context,'Editar Tarefa', taref.idTarefa);
            },
          )
        ),
    ],);
    
  }
  
  setTasks(Tarefa tarefa){
    nome.text = tarefa.nome;
    descricao.text = tarefa.descricao;
    idResponsavel.text = tarefa.idResponsavel;
    data.text = tarefa.data;
    valor.text = tarefa.valor.toString();
  }

  editarTarefa(BuildContext context,String title, int id) { 
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
                  child: Text('Editar tarefa'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nome,
                    keyboardType: TextInputType.text,
                    validator: (nome) => nome.isEmpty ? 'Name cannot be blank':null,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Nome da tarefa: ',
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
                    controller: idResponsavel,
                    keyboardType: TextInputType.text,
                    validator: (idResponsavel) => idResponsavel.isEmpty ? 'User cannot be blank':null,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Usuario: ',
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
                            Tarefa tarefa = new Tarefa();
                            tarefa.idTarefa = id;
                            tarefa.nome = nome.text;
                            tarefa.descricao = descricao.text;
                            tarefa.idResponsavel = idResponsavel.text;
                            tarefa.estado = 'aberta';
                            tarefa.data = data.text;
                            tarefa.valor = int.parse(valor.text.toString());
                            bool ver = await service.putTarefa(tarefa);
                            if(ver == true) {
                              Fluttertoast.showToast(
                                msg: "Tarefa alterada com sucesso",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1
                              );
                              nome.text = '';
                              descricao.text = '';
                              idResponsavel.text = '';
                              data.text = '';
                              valor.text = '';
                              _handleRefresh();
                              Navigator.of(context).pop();
                            }
                            else{
                              Fluttertoast.showToast(
                                msg: "Tarefa não pode ser editada",
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

  Widget tarefas(String estado, int x){
    return FutureBuilder(
      future: service.getTasks(estado),
      builder: (context,snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              this.i = x;
              tasks = snapshot.data;
              //lista de card
              return tasks != null ? listTasks() : Text('');
            }
        }
      },
    );
  }
}