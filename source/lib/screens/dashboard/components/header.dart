import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/controllers/MenuAppController.dart';
import 'package:JMAI/screens/main/components/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:JMAI/Class/Utente.dart';
import 'package:JMAI/Class/SecretarioClinico.dart';
import 'package:JMAI/Class/Medico.dart';
import '../../main/components/constants.dart';

class Header extends StatelessWidget {
  final Utilizador? user;
  const Header({
    Key? key,
    required this.user,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isDesktop)
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: context.read<MenuAppController>().controlMenu,
            ),
          if (!isMobile) Spacer(),
          ProfileCard(user: user),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Utilizador? user;
  const ProfileCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  void onSelected(BuildContext context, String value, String? email) {
    switch (value) {
      case 'logout':
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (Route<dynamic> route) => false,
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    String nomeCompleto;
    String imagePath;
    String? email;

    if (user is Utente) {
      nomeCompleto = (user as Utente).nomeCompleto;
      imagePath = "assets/images/utente.png";
      email = user!.email;
    } else if (user is Medico) {
      nomeCompleto = (user as Medico).nomeCompleto;
      imagePath = "assets/images/medico.png";
      email = user!.email;
    } else if (user is SecretarioClinico) {
      nomeCompleto = (user as SecretarioClinico).nomeCompleto;
      imagePath = "assets/images/secretario_clinico.png";
      email = user!.email;
    } else {
      nomeCompleto = "Administrador";
      imagePath = "assets/images/admin.png";
      email = user!.email;
    }

    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding / 2,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        border: Border.all(
          color: secondaryColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(width: defaultPadding / 2),
          Text(nomeCompleto),
          SizedBox(width: defaultPadding / 2),
          PopupMenuButton<String>(
            offset: Offset(0, 50),
            onSelected: (value) => onSelected(context, value, email),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'logout',
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
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
              minHeight: 35,
            ),
            color: bgColor,
          ),
        ],
      ),
    );
  }
}
