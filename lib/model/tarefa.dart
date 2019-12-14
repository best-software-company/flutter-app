// To parse this JSON data, do
//
//     final tarefa = tarefaFromJson(jsonString);

import 'dart:convert';

Tarefa tarefaFromJson(String str) => Tarefa.fromJson(json.decode(str));

String tarefaToJson(Tarefa data) => json.encode(data.toJson());

class Tarefa {
  int idTarefa;
    String nome;
    String descricao;
    String idResponsavel;
    String estado;
    String data;
    int valor;

    Tarefa({
        this.idTarefa,
        this.nome,
        this.descricao,
        this.idResponsavel,
        this.estado,
        this.data,
        this.valor,
    });

    factory Tarefa.fromJson(Map<String, dynamic> json) => Tarefa(
        idTarefa: json['idTarefa'],
        nome: json["nome"],
        descricao: json["descricao"],
        idResponsavel: json["idResponsavel"],
        estado: json["estado"],
        data: json["data"],
        valor: json["valor"],
    );

    Map<String, dynamic> toJson() => {
        'idTarefa':idTarefa,
        "nome": nome,
        "descricao": descricao,
        "idResponsavel": idResponsavel,
        "estado": estado,
        "data": data,
        "valor": valor,
    };
}
