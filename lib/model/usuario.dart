// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    String idUsuario;
    String nome;
    String data;
    String genero;
    int pontos;
    String telefone;
    String senha;
    String email;
    String perfil;
    int idCasa;
    String foto;
    String token;

    Usuario({
        this.idUsuario,
        this.nome,
        this.data,
        this.genero,
        this.pontos,
        this.telefone,
        this.senha,
        this.email,
        this.perfil,
        this.idCasa,
        this.foto,
        this.token,
    });

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        idUsuario: json["idUsuario"],
        nome: json["nome"],
        data: json["data"],
        genero: json["genero"],
        pontos: json["pontos"],
        telefone: json["telefone"],
        senha: json["senha"],
        email: json["email"],
        perfil: json["perfil"],
        idCasa: json["idCasa"],
        foto: json["foto"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "idUsuario": idUsuario,
        "nome": nome,
        "data": data,
        "genero": genero,
        "pontos": pontos,
        "telefone": telefone,
        "senha": senha,
        "email": email,
        "perfil": perfil,
        "idCasa": idCasa,
        "foto": foto,
        "token": token,
    };
}
