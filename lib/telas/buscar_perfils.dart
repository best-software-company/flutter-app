import 'package:flutter/material.dart';
import 'package:home_tasks/model/usuario.dart';
import 'package:home_tasks/service/service.dart';
import 'package:home_tasks/telas/visualizar_perfil.dart';

class SearchPerfils extends StatefulWidget {
  @override
  _SearchPerfilsState createState() => _SearchPerfilsState();
}

class _SearchPerfilsState extends State<SearchPerfils> {
  var _searchEdit = new TextEditingController();

  bool _isSearch = true;
  String _searchText = "";

  List<Usuario> _socialListItems;
  List<String> _searchListItems;
  Service service = Service();

  _SearchPerfilsState() {
    _searchEdit.addListener(() async {
      if (_searchEdit.text.isEmpty) {
        _isSearch = true;
        _searchText = "";
      } else {
        _isSearch = false;
        _searchText = _searchEdit.text;
        _socialListItems = await service.getUsers(_searchText);
      }
      setState((){});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Buscar perfils"),
      ),
      body: new Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: new Column(
          children: <Widget>[
            _searchBox(),
            _isSearch ? Text('') :  _listView(),
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
                Image.network(
                  'https://picsum.photos/250?image=9',
                ),
                Padding(
                  padding:EdgeInsets.fromLTRB(25,0,25,0),
                  child: ListTile(
                    title: Text('Nome: '+_socialListItems[index].nome),
                    subtitle: Text('Perfil: '+_socialListItems[index].perfil),
                  ),
                ),
                Align(alignment: Alignment.centerRight,
                  child:FlatButton(
                    textColor: Colors.blue,
                    disabledColor: Colors.blue,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.fromLTRB(8,0,8.0,0),
                    splashColor: Colors.blue[50],
                    child: Text('Detalhes'), 
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VisualizarPerfil(usuario : _socialListItems[index].idUsuario)));
                    },
                  )
                )
              ],
            ),
          );
        }),
    );
  }

  Widget _searchAddList() {
    return new Flexible(
      child: new ListView.builder(
          itemCount: _searchListItems.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              color: Colors.cyan[100],
              elevation: 5.0,
              child: new Container(
                margin: EdgeInsets.all(15.0),
                child: new Text("${_searchListItems[index]}"),
              ),
            );
          }),
    );
  }

}