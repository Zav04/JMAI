import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

Tuple2<String, Color> getTypeDescription(int status) {
  switch (status) {
    case 1:
      return Tuple2('Multiuso', Colors.lime);
    case 2:
      return Tuple2('Importação de Veículo Automóvel', Colors.purple);
    default:
      return Tuple2('Status Desconhecido', Colors.grey);
  }
}

Tuple2<String, Color> getStatusDescription(int status) {
  switch (status) {
    case 0:
      return Tuple2('Em espera de Aprovação', Colors.grey);
    case 1:
      return Tuple2('Aprovado a espera de Pre-Avaliação', Colors.orange);
    case 2:
      return Tuple2('Pré-Avaliação Concluída', Colors.yellow);
    case 3:
      return Tuple2('Agendado', Colors.blue);
    case 4:
      return Tuple2('Finalizado', Colors.green);
    case 5:
      return Tuple2('Cancelado', Colors.red);
    case 6:
      return Tuple2('Marcação Disponivel', Colors.blue);
    case 7:
      return Tuple2('Recusado', Colors.red);
    default:
      return Tuple2('Status Desconhecido', Colors.grey);
  }
}
