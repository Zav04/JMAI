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
    double defaultPadding = 20.0;

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(user: user),
            SizedBox(height: defaultPadding * 2),
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
            ),
            SizedBox(height: defaultPadding * 10),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
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
          ],
        ),
      ),
    );
  }
}
