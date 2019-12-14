import 'package:flutter/material.dart';
import 'package:home_tasks/model/casa.dart';
import 'package:home_tasks/service/service.dart';

class EditCasa extends StatefulWidget {
  EditCasa({Key key, this.idCasa}) : super(key: key);
  final int idCasa;

  @override
  _EditCasaState createState() => _EditCasaState();
}

class _EditCasaState extends State<EditCasa> {
  final _formKey = GlobalKey<FormState>();
  var _nome = TextEditingController();
  var _endereco = TextEditingController();
  var _aluguel = TextEditingController();
  var _descricao = TextEditingController();

  bool putUser = false;
  Future<Casa> futureCasa;
  Casa home = new Casa();
  Service service = new Service();

  @override
  initState(){
    super.initState();
    futureCasa = service.getCasa(this.widget.idCasa);
    futureCasa.then((res){
      update();
    });
  }

  update() async {
    home = await futureCasa;
    _nome.text = home.nome;
    _endereco.text = home.endereco;
    _aluguel.text = home.aluguel.toString();
    _descricao.text = home.descricao;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Visualizar casa'),
      centerTitle: true,
      ),
      body: FutureBuilder(
        future: futureCasa,
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
              /*RaisedButton(child: Text("Atualizar"), onPressed: () async {
                final form = _formKey.currentState;
                form.save();
                home.nome = _nome.text;
                home.endereco = _endereco.text;
                home.aluguel = _aluguel.text as int;
                home.descricao = _descricao.text;

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
              }),*/
            ],
          ),
        ),
      ),
    );
  }
}