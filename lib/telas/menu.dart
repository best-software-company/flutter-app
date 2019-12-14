import 'package:flutter/material.dart';
import 'package:home_tasks/model/usuario.dart';
import 'package:home_tasks/service/service.dart';
import 'package:home_tasks/telas/casa.dart';
import 'package:home_tasks/telas/perfil.dart';
import 'package:home_tasks/telas/rotinas.dart';
import 'package:home_tasks/telas/tarefas.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Service service = Service();
  Usuario user = Usuario();

  Future<Usuario> pegarUsuario() async {
    user = await service.getUser();
    return user;
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pegarUsuario(),
      builder: (context,snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createMenu(context, snapshot);
        }
      },
    );
  }

  Widget createMenu(BuildContext context, AsyncSnapshot snapshot){
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName:  Text(user.nome),
            accountEmail:  Text(user.email),
            currentAccountPicture:  CircleAvatar(
              backgroundColor: Color(0xffc0c6d4),
              child: Text(user.nome[0],style: TextStyle(color: Color(0xff696969)),),
            ),
          ),
            ListTile(
            title:   Text('Tarefas'),
            trailing: Icon(Icons.format_list_bulleted),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Tarefas()),);
            },
          ),
          ListTile(
            title:   Text('Rotinas'),
            trailing: Icon(Icons.calendar_today),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Rotinas()),);
            },
          ),
          ListTile(
            title:   Text('Perfil'),
            trailing: Icon(Icons.person),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Perfil()),);
            },
          ),
          ListTile(
            title:   Text('Casa'),
            trailing: Icon(Icons.home),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CasaTela()),);
            },
          ),
          ListTile(
            title:   Text('Regras'),
            trailing: Icon(Icons.receipt),
            onTap: () {
              
            },
          ),
          ListTile(
            title:   Text('Contas'),
            trailing: Icon(Icons.payment),
            onTap: () {
              
            },
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  MenuItem(this.title, this.page);

  final String title;
  final StatefulWidget page;
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;
  const MenuItemWidget(this.item);

  Widget _buildMenu(MenuItem menuItem, context) {
    return ListTile(
      title: Text(menuItem.title),
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) => menuItem.page,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMenu(this.item, context);
  }
}