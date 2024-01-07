import 'package:JMAI/Class/Utilizador.dart';
import 'package:flutter/material.dart';
import 'package:JMAI/screens/dashboard/components/header.dart';
import 'package:JMAI/screens/main/components/DashboardCard.dart';
import 'package:JMAI/Class/DashboardCardInfo.dart';

class DashboardScreen extends StatelessWidget {
  final Utilizador? user;
  const DashboardScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DashboardCardInfo> cardData = generateRandomCardData();
    // Substitua 'defaultPadding' pelo valor do seu padding padrão
    double defaultPadding = 20.0;

    // Substitua 'logoImage' pelo seu AssetImage ou NetworkImage conforme necessário

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(user: user),
            SizedBox(
                height: defaultPadding *
                    2), // Aumenta o espaço entre o logo e os cartões
            Text(
              'Bem Vindo à plataforma',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 80,
                color: Color(0xFF668239),
              ),
            ),
            Text(
              'JMAI - Juntas Médicas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 80,
                color: Color(0xFFD9CAA1),
              ),
              // Estilos de texto e outras propriedades...
            ),

            SizedBox(
                height: defaultPadding *
                    10), // Aumenta o espaço entre o texto e os cartões
            // Aqui você pode começar a adicionar os cartões do novo dashboard
            GridView.builder(
              physics:
                  NeverScrollableScrollPhysics(), // Para evitar rolagem dentro da GridView
              shrinkWrap:
                  true, // Para limitar a GridView ao espaço ocupado pelos seus filhos
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
                childAspectRatio: 1.5,
              ),
              itemCount: cardData.length,
              itemBuilder: (context, index) =>
                  DashboardCard(info: cardData[index]),
            ),
            // Outros widgets podem seguir aqui...
          ],
        ),
      ),
    );
  }
}
