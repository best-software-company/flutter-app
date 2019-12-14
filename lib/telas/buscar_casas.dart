import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_tasks/model/casa.dart';
import 'package:home_tasks/model/usuario.dart';
import 'package:home_tasks/service/service.dart';

class SearchHomes extends StatefulWidget {
  SearchHomes({Key key, this.user}) : super(key: key);
  final Usuario user;

  @override
  _SearchHomesState createState() => _SearchHomesState();
}

class _SearchHomesState extends State<SearchHomes> {
  var _searchEdit = new TextEditingController();

  bool _isSearch = true;
  String _searchText = "";

  List<Casa> _socialListItems;
  Service service = Service();

  @override
  initState(){
    super.initState();

  }

  _SearchHomesState() {
    _searchEdit.addListener(() {
      if (_searchEdit.text.isEmpty){
        setState(() {
          _isSearch = true;
          _searchText = "";
        });
      } else {
        setState(() async {
          _isSearch = false;
          _searchText = _searchEdit.text;
          _socialListItems = await service.getHomes(_searchText);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Buscar casas"),
      ),
      body: new Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: new Column(
          children: <Widget>[
            _searchBox(),
            _isSearch ? Text('') :  _socialListItems != null ? _listView(): Text(''),
          ],
        ),
      ),
    );
  }

  Widget _searchBox() {
    return new Container(
      decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: new TextField(
        controller: _searchEdit,
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: new TextStyle(color: Colors.grey[300]),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

//card com nome, perfil e a foto
  Widget _listView() {
    return new Flexible(
      child: new ListView.builder(
        itemCount: _socialListItems.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding:EdgeInsets.fromLTRB(25,0,25,0),
                  child: ListTile(
                    title: Text('Nome: '+_socialListItems[index].nome),
                    subtitle: Text('Valor do aluguel: '+_socialListItems[index].aluguel.toString()+
                    '\nEndereço: '+_socialListItems[index].endereco+
                    '\nDescrição: '+_socialListItems[index].descricao),
                  ),
                ),
                Align(alignment: Alignment.centerRight,
                  child:FlatButton(
                    textColor: Colors.blue,
                    disabledColor: Colors.blue,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.fromLTRB(8,0,8.0,0),
                    splashColor: Colors.blue[50],
                    child: Text('Quero Morar.'), 
                    onPressed: () async {
                      this.widget.user.idCasa = _socialListItems[index].idCasa;
                      this.widget.user.perfil = 'Morador da casa '+_socialListItems[index].nome;
                      bool ver = await service.putUser(this.widget.user);
                      if(ver ==true){
                        Fluttertoast.showToast(
                          msg: "Você agora se tornou um membro desta casa.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1
                        );
                      }
                      else {
                        Fluttertoast.showToast(
                          msg: "Erro no processo.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1
                        );
                      }
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => VisualizarCasa(id:_socialListItems[index].)));
                    },
                  )
                )
              ],
            ),
          );
        }),
    );
  }

}