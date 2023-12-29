import 'package:JMAI/controllers/MenuAppController.dart';
import 'package:JMAI/screens/main/components/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main/components/constants.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDesktop = Responsive.isDesktop(context);
    var isMobile = Responsive.isMobile(context);

    return Container(
      margin: EdgeInsets.only(left: isDesktop ? defaultPadding : 0),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding / (isMobile ? 2 : 1),
        vertical: defaultPadding / 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ajuste aqui
        children: [
          if (!isDesktop)
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: context.read<MenuAppController>().controlMenu,
            ),
          if (!isMobile) Spacer(),
          ProfileCard(),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  void onSelected(BuildContext context, String value) {
    switch (value) {
      case 'logout':
        // Implementar lógica de logout
        print('Logout pressed');
        break;
      // Adicionar mais casos para outros itens do menu, se necessário
      default:
        print('Unknown value: $value');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding / 2,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: bgColor, // Cor de fundo do cartão
        borderRadius:
            BorderRadius.all(Radius.circular(10)), // Bordas arredondadas
        border: Border.all(
          color: Colors.white, // Cor do rebordo
          width: 2, // Largura do rebordo
        ),
        boxShadow: [
          // Sombra para dar um efeito elevado ao cartão
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // Posição da sombra
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage("assets/images/profile_pic.png"),
          ),
          SizedBox(width: defaultPadding / 2),
          Text("Angelina Jolie"),
          SizedBox(width: defaultPadding / 2),
          PopupMenuButton<String>(
            offset: Offset(0, 50),
            onSelected: (value) => onSelected(context, value),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'logout',
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 25,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: 50,
              minHeight: 32,
            ),
            // Aplicar a mesma cor de fundo ao PopupMenuButton
            color:
                bgColor, // Defina a cor de fundo aqui para que ela se aplique ao menu inteiro
          ),
        ],
      ),
    );
  }
}
