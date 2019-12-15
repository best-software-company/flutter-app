import 'dart:async';
import 'dart:convert';
import 'package:home_tasks/model/regra.dart';
import 'package:home_tasks/model/rotina.dart';
import 'package:home_tasks/model/tarefa.dart';
import 'package:home_tasks/model/usuario.dart';
import 'package:home_tasks/model/casa.dart';
import 'package:http/http.dart' as http;

class Service {

  http.Client client = http.Client();
  static Map token;
  static Usuario user = new Usuario();
  static String id = '';


  Future<String> autenticar(String idUser,String senha) async {
    
    String login = idUser+':'+senha;
    String credentials = base64.encode(utf8.encode(login));
    final response = await client.post("http://35.247.234.136/hometasks/api/v1/login/",headers: <String, String>{'Authorization' : 'Basic '+credentials});    
    if(response.statusCode==200){
      token=json.decode(response.body);
      id = idUser;
      return token.values.toString();
    }
    return null;
  }

  Future<bool> postUser(Usuario usuario) async {
    final response = await client.post("http://35.247.234.136/hometasks/api/v1/users/",headers: {'Content-type': 'application/json'},body: json.encode(usuario));    
    if(response.statusCode==201){
      return true;
    }
    return false;
  }

  Future<bool> putUser(Usuario usuario) async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.put("http://35.247.234.136/hometasks/api/v1/users/",headers: {'token': tk,'Content-type': 'application/json'},body: json.encode(usuario));    
    if(response.statusCode==204){
      
      return true;
    }
    return false;
  }

  String verificarAcesso(){
    return token.values.toString();
  }
  String verificarId(){
    if(token.values.toString()!=null)
      return id;
      return 'ta errado';
  }

  Future<Usuario> getUser() async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.get("http://35.247.234.136/hometasks/api/v1/users/"+verificarId(),headers: {'token': tk,'Content-type': 'application/json','Accept': 'application/json'});    
    if(response.statusCode==200){
      Map serverUser = json.decode(response.body);
      user = Usuario.fromJson(serverUser);      
      return user;    
    }
    return null;
  }

  Future<List<Usuario>> getUsers(String id) async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.get("http://35.247.234.136/hometasks/api/v1/users/list/"+id,headers: {'token': tk,'Content-type': 'application/json','Accept': 'application/json'});    
    if(response.statusCode==200){
      List<Usuario> users = List();
      var serverUser = json.decode(response.body);
      for(int i=0;i<serverUser.length;i++){
        users.add(Usuario.fromJson(serverUser[i]));
      }
      return users;    
    }
    return null;
  }

  Future<List<Usuario>> getUsersCasa() async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.get("http://35.247.234.136/hometasks/api/v1/users/home/",headers: {'token': tk,'Content-type': 'application/json','Accept': 'application/json'});    
    if(response.statusCode==200){
      List<Usuario> users = List();
      var serverUser = json.decode(response.body);
      for(int i=0;i<serverUser.length;i++){
        users.add(Usuario.fromJson(serverUser[i]));
      }
      return users;    
    }
    return null;
  }

  Future<bool> postCasa(Casa casa) async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.post("http://35.247.234.136/hometasks/api/v1/home/",headers: {'token': tk,'Content-type': 'application/json'},body: json.encode(casa));    
    if(response.statusCode==201){
      return true;
    }
    return false;
  }

  Future<bool> putCasa(Casa casa) async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.put("http://35.247.234.136/hometasks/api/v1/home/",headers: {'token': tk,'Content-type': 'application/json'},body: json.encode(casa));    
    if(response.statusCode==204){
      
      return true;
    }
    return false;
  }

  Future<Casa> getCasa(int id) async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.get("http://35.247.234.136/hometasks/api/v1/home/"+id.toString(),headers: {'token': tk,'Content-type': 'application/json','Accept': 'application/json'});    
    if(response.statusCode==200){
      Map serverHome = json.decode(response.body);
      Casa home = Casa.fromJson(serverHome);      
      return home;    
    }
    return null;
  }

  Future<List<Casa>> getHomes(String id) async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.get("http://35.247.234.136/hometasks/api/v1/home/list/"+id,headers: {'token': tk,'Content-type': 'application/json','Accept': 'application/json'});    
    if(response.statusCode==200){
      List<Casa> homes = List();
      var serverHome = json.decode(response.body);
      for(int i=0;i<serverHome.length;i++){
        homes.add(Casa.fromJson(serverHome[i]));
      }
      return homes;    
    }
    return null;
  }

  Future<bool> postTarefa(Tarefa tarefa) async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.post("http://35.247.234.136/hometasks/api/v1/tasks/",headers: {'token': tk,'Content-type': 'application/json','Accept': 'application/json'},body: json.encode(tarefa));    
    if(response.statusCode==201){
      return true;
    }
    return false;
  }

  Future<List<Tarefa>> getTasks(String estado) async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.get("http://35.247.234.136/hometasks/api/v1/tasks/"+estado,headers: {'token': tk,'Content-type': 'application/json','Accept': 'application/json'});    
    if(response.statusCode==200){
      List<Tarefa> tasks = List();
      var servertask = json.decode(response.body);
      for(int i=0;i<servertask.length;i++){
        tasks.add(Tarefa.fromJson(servertask[i]));
      }
      return tasks;    
    }
    return null;
  }

  Future<bool> putTarefa(Tarefa tarefa) async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.put("http://35.247.234.136/hometasks/api/v1/tasks/",headers: {'token': tk,'Content-type': 'application/json','Accept': 'application/json'},body: json.encode(tarefa));    
    if(response.statusCode==204){
      return true;
    }
    return false;
  }

  Future<bool> postRule(Regra regra) async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.post("http://35.247.234.136/hometasks/api/v1/rules/",headers: {'token': tk,'Content-type': 'application/json','Accept': 'application/json'},body: json.encode(regra));    
    if(response.statusCode==201){
      return true;
    }
    return false;
  }

  Future<List<Regra>> getRules() async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.get("http://35.247.234.136/hometasks/api/v1/rules/",headers: {'token': tk,'Content-type': 'application/json','Accept': 'application/json'});    
    if(response.statusCode==200){
      List<Regra> rules = List();
      var serverRule = json.decode(response.body);
      for(int i=0;i<serverRule.length;i++){
        rules.add(Regra.fromJson(serverRule[i]));
      }
      return rules;    
    }
    return null;
  }

  Future<bool> putRules(Regra regra) async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    print(regra.toJson());
    final response = await client.put("http://35.247.234.136/hometasks/api/v1/rules/",headers: {'token': tk,'Content-type': 'application/json','Accept': 'application/json'},body: json.encode(regra));    
    if(response.statusCode==204){
      return true;
    }
    return false;
  }

  Future<bool> postRotine(Rotina rotina) async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    print(rotina.toJson());
    final response = await client.post("http://35.247.234.136/hometasks/api/v1/routines/",headers: {'token': tk,'Content-type': 'application/json','Accept': 'application/json'},body: json.encode(rotina));    
    print(response.statusCode);
    if(response.statusCode==201){
      return true;
    }
    return false;
  }

  Future<List<Rotina>> getRotinas() async {
    String tk = verificarAcesso();
    tk = tk.substring(1, tk.length-1);
    final response = await client.get("http://35.247.234.136/hometasks/api/v1/routines/",headers: {'token': tk,'Content-type': 'application/json','Accept': 'application/json'});    
    print(response.statusCode);
    if(response.statusCode==200){
      List<Rotina> rotinas = List();
      var serverRotina = json.decode(response.body);
      for(int i=0;i<serverRotina.length;i++){
        rotinas.add(Rotina.fromJson(serverRotina[i]));
      }
      return rotinas;    
    }
    return null;
  }

}