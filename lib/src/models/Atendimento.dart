//import 'package:json_annotation/json_annotation.dart';

//@JsonSerializable()
class Atendimento {
  String codUsuario;
  DateTime dataSolicitacao;
  String codPonto;
  int status;
  String codAprovador;
  String comentario;
  int tipo;
  int satisfacao;
  double precoTotal;

  Map<String, dynamic> toJson() => {
        'codUsuario': codUsuario,
        'dataSolicitacao': dataSolicitacao,
        'codPonto': codPonto,
        'status': status,
        'codAprovador': codAprovador,
        'comentario': comentario,
        'tipo': tipo,
        'satisfacao': satisfacao,
        'precoTotal': precoTotal,
      };
}
