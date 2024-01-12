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
    double screenWidth = MediaQuery.of(context).size.width;
    double defaultPadding = screenWidth < 600 ? 10.0 : 20.0;
    int gridCount = screenWidth < 600
        ? 2
        : 4; // Colunas para dispositivos móveis ou desktop
    double fontSize = screenWidth < 600 ? 57 : 80; // Tamanho da fonte adaptável

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(user: user),
            SizedBox(height: defaultPadding),
            Text(
              'Bem Vindo à plataforma',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: Color(0xFF668239),
              ),
            ),
            Text(
              'JMAI - Juntas Médicas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: Color(0xFFD9CAA1),
              ),
            ),
            SizedBox(height: defaultPadding * 2),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCount,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
                childAspectRatio: 1.5,
              ),
              itemCount: cardData.length,
              itemBuilder: (context, index) =>
                  DashboardCard(info: cardData[index]),
            ),
          ],
        ),
      ),
    );
  }
}
