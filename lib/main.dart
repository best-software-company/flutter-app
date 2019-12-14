import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_tasks/service/service.dart';
import 'package:home_tasks/telas/tarefas.dart';
import 'package:home_tasks/telas/registro.dart';

void main() => runApp(LoginRegister());

class LoginRegister extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  var _password = TextEditingController();
  var _email = TextEditingController();
  String token;
  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20.0), 
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.text,
                  validator: (_email) => _email.isEmpty ? 'User cannot be blank':null,
                  autofocus: false,
                  decoration: new InputDecoration(
                    labelText: "User",
                    prefixIcon: Icon(
                        const IconData(59389, fontFamily: 'MaterialIcons')
                    ),
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
                    labelText: "Password",
                    prefixIcon: Icon(
                        const IconData(57562, fontFamily: 'MaterialIcons')
                    ),
                  ),
                ),
                SizedBox(height: 20.0), 
                RaisedButton(child: Text("LOGIN"), onPressed: () async {
                  final form = _formKey.currentState;
                  form.save();
                  if (form.validate()) {
                    token = await service.autenticar(_email.text,_password.text);
                    if(token!=null){
                      service.verificarAcesso();
                      _email.text = '';
                      _password.text = '';
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Tarefas()));
                    }
                    else{
                      Fluttertoast.showToast(
                        msg: "Wrong username or password.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1
                      );
                    }
                  }
                }),
                SizedBox(height: 20.0), 
                RaisedButton(child: Text("REGISTRO"), onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Register()),);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
