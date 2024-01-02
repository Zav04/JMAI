import 'package:JMAI/Class/Utilizador.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:JMAI/screens/main/components/constants.dart';

class SideMenu extends StatelessWidget {
  final Function(int) onItemSelected;
  final Utilizador user;

  const SideMenu({
    required this.onItemSelected,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> menuItems = [
      DrawerHeader(
        child: SvgPicture.asset("assets/images/logo-no-background.svg"),
      ),
      // Itens comuns a todas as roles
      DrawerListTile(
        title: "Dashboard",
        svgSrc: "assets/icons/menu_dashboard.svg",
        press: () => onItemSelected(0),
      ),
    ];

    switch (user.role) {
      case 'Admin':
        menuItems.addAll([
          DrawerListTile(
            title: "Registar Secretario Clinico",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () => onItemSelected(1),
          ),
          DrawerListTile(
            title: "Registar Médico",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () => onItemSelected(2),
          ),
        ]);
        break;
      case 'Utente':
        menuItems.addAll([
          DrawerListTile(
            title: "Requerimentos",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () => onItemSelected(1),
          ),
          DrawerListTile(
            title: "Editar Perfil",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () => onItemSelected(2),
          ),
        ]);
        break;
      case 'SecretarioClinico':
        menuItems.addAll([
          DrawerListTile(
            title: "Validação de Requerimentos",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () => onItemSelected(1),
          ),
        ]);

        break;
      case 'Medico':
        menuItems.addAll([
          DrawerListTile(
            title: "Pre-Avaliação de Requerimentos",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () => onItemSelected(1),
          ),
        ]);
        break;
      default:
    }

    return Drawer(
      child: Container(
        color: bgColor,
        child: ListView(
          children: menuItems,
        ),
      ),
    );
  }
}

class DrawerListTile extends StatefulWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  _DrawerListTileState createState() => _DrawerListTileState();
}

class _DrawerListTileState extends State<DrawerListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered ? secondaryColor : bgColor,
        child: ListTile(
          onTap: widget.press,
          horizontalTitleGap: 0.0,
          leading: SvgPicture.asset(
            widget.svgSrc,
            color: _isHovered ? Colors.grey[700] : Colors.black,
            height: 16,
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              color: _isHovered ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
