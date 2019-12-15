// To parse this JSON data, do
//
//     final rotina = rotinaFromJson(jsonString);

import 'dart:convert';

Rotina rotinaFromJson(String str) => Rotina.fromJson(json.decode(str));

String rotinaToJson(Rotina data) => json.encode(data.toJson());

class Rotina {
    int idRotina;
    String validade;
    bool alternar;
    String nome;
    String descricao;
    String idUsuario;

    Rotina({
        this.idRotina,
        this.validade,
        this.alternar,
        this.nome,
        this.descricao,
        this.idUsuario,
    });

    factory Rotina.fromJson(Map<String, dynamic> json) => Rotina(
        idRotina: json["idRotina"],
        validade: json["validade"],
        alternar: json["alternar"],
        nome: json["nome"],
        descricao: json["descricao"],
        idUsuario: json["idUsuario"],
    );

    Map<String, dynamic> toJson() => {
        "idRotina": idRotina,
        "validade": validade,
        "alternar": alternar,
        "nome": nome,
        "descricao": descricao,
        "idUsuario": idUsuario,
    };
}
