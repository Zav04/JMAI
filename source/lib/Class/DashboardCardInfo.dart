import 'package:flutter/material.dart';
import 'dart:math';

class DashboardCardInfo {
  final String title;
  String
      value; // O valor agora deve ser mutável para atualizar com um número aleatório
  final IconData icon;

  DashboardCardInfo({
    required this.title,
    required this.value,
    required this.icon,
  });
}

List<DashboardCardInfo> generateRandomCardData() {
  var random = Random();
  List<DashboardCardInfo> cardData = [
    DashboardCardInfo(
      title: 'Requerimentos',
      value: (random.nextInt(100) + 1)
          .toString(), // Gera um número aleatório entre 1 e 100
      icon: Icons.description,
    ),
    DashboardCardInfo(
      title: 'Juntas Marcadas',
      value: (random.nextInt(50) + 1)
          .toString(), // Gera um número aleatório entre 1 e 50
      icon: Icons.event,
    ),
    DashboardCardInfo(
      title: 'Avaliações Hoje',
      value: (random.nextInt(20) + 1)
          .toString(), // Gera um número aleatório entre 1 e 20
      icon: Icons.today,
    ),
    DashboardCardInfo(
      title: 'Total de Utentes',
      value: (random.nextInt(1000) + 1)
          .toString(), // Gera um número aleatório entre 1 e 1000
      icon: Icons.people,
    ),
    // Adicione mais cartões conforme necessário
  ];

  return cardData;
}
