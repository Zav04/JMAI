import 'package:JMAI/Class/Utilizador.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:JMAI/screens/main/components/constants.dart';

class SideMenu extends StatefulWidget {
  final Function(int) onItemSelected;
  final Utilizador user;

  const SideMenu({
    required this.onItemSelected,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int selectedItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> menuItems = [
      DrawerHeader(
        child: SvgPicture.asset("assets/images/logo-no-background.svg"),
      ),
      DrawerListTile(
        title: "Dashboard",
        svgSrc: "assets/icons/menu_dashboard.svg",
        press: () {
          setState(() {
            selectedItemIndex = 0;
          });
          widget.onItemSelected(0);
        },
        isSelected: selectedItemIndex == 0,
      ),
    ];

    switch (widget.user.role) {
      case 'Admin':
        menuItems.addAll([
          DrawerListTile(
            title: "Registar Secretario Clinico",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              setState(() {
                selectedItemIndex = 1;
              });
              widget.onItemSelected(1);
            },
            isSelected: selectedItemIndex == 1,
          ),
          DrawerListTile(
            title: "Registar Médico",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              setState(() {
                selectedItemIndex = 2;
              });
              widget.onItemSelected(2);
            },
            isSelected: selectedItemIndex == 2,
          ),
        ]);
        break;
      case 'Utente':
        menuItems.addAll([
          DrawerListTile(
            title: "Requerimentos",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              setState(() {
                selectedItemIndex = 1;
              });
              widget.onItemSelected(1);
            },
            isSelected: selectedItemIndex == 1,
          ),
          DrawerListTile(
            title: "Editar Perfil",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              setState(() {
                selectedItemIndex = 2;
              });
              widget.onItemSelected(2);
            },
            isSelected: selectedItemIndex == 2,
          ),
        ]);
        break;
      case 'SecretarioClinico':
        menuItems.addAll([
          DrawerListTile(
            title: "Validação de Requerimentos",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              setState(() {
                selectedItemIndex = 1;
              });
              widget.onItemSelected(1);
            },
            isSelected: selectedItemIndex == 1,
          ),
        ]);

        break;
      case 'Medico':
        menuItems.addAll([
          DrawerListTile(
            title: "Pre-Avaliação de Requerimentos",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              setState(() {
                selectedItemIndex = 1;
              });
              widget.onItemSelected(1);
            },
            isSelected: selectedItemIndex == 1,
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
  final String title, svgSrc;
  final VoidCallback press;
  final bool isSelected;

  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.isSelected,
  }) : super(key: key);

  @override
  _DrawerListTileState createState() => _DrawerListTileState();
}

class _DrawerListTileState extends State<DrawerListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.isSelected
        ? selectedColor
        : (_isHovered ? secondaryColor : bgColor);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: backgroundColor,
        child: ListTile(
          onTap: widget.press,
          horizontalTitleGap: 0.0,
          leading: SvgPicture.asset(
            widget.svgSrc,
            color: _isHovered ? Colors.blue : Colors.black,
            height: 16,
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              color: _isHovered ? Colors.blueAccent : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
