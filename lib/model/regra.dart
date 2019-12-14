// To parse this JSON data, do
//
//     final regra = regraFromJson(jsonString);

import 'dart:convert';

Regra regraFromJson(String str) => Regra.fromJson(json.decode(str));

String regraToJson(Regra data) => json.encode(data.toJson());

class Regra {
    int idRegra;
    String nome;
    String descricao;
    bool estado;
    String idUsuario;
    String data;
    int idCasa;
    int valor;

    Regra({
        this.idRegra,
        this.nome,
        this.descricao,
        this.estado,
        this.idUsuario,
        this.data,
        this.idCasa,
        this.valor,
    });

    factory Regra.fromJson(Map<String, dynamic> json) => Regra(
        idRegra: json["idRegra"],
        nome: json["nome"],
        descricao: json["descricao"],
        estado: json["estado"],
        idUsuario: json["idUsuario"],
        data: json["data"],
        idCasa: json["idCasa"],
        valor: json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "idRegra": idRegra,
        "nome": nome,
        "descricao": descricao,
        "estado": estado,
        "idUsuario": idUsuario,
        "data": data,
        "idCasa": idCasa,
        "valor": valor,
    };
}
