// To parse this JSON data, do
//
//     final casa = casaFromJson(jsonString);

import 'dart:convert';

Casa casaFromJson(String str) => Casa.fromJson(json.decode(str));

String casaToJson(Casa data) => json.encode(data.toJson());

class Casa {
    int idCasa;
    String nome;
    String endereco;
    int aluguel;
    String descricao;
    dynamic foto;

    Casa({
        this.idCasa,
        this.nome,
        this.endereco,
        this.aluguel,
        this.descricao,
        this.foto,
    });

    factory Casa.fromJson(Map<String, dynamic> json) => Casa(
        idCasa: json["idCasa"],
        nome: json["nome"],
        endereco: json["endereco"],
        aluguel: json["aluguel"],
        descricao: json["descricao"],
        foto: json["foto"],
    );

    Map<String, dynamic> toJson() => {
        "idCasa": idCasa,
        "nome": nome,
        "endereco": endereco,
        "aluguel": aluguel,
        "descricao": descricao,
        "foto": foto,
    };
}
