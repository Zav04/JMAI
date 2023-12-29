import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:JMAI/screens/main/components/constants.dart';

class SideMenu extends StatelessWidget {
  final Function(int) onItemSelected;
  const SideMenu({
    required this.onItemSelected,
    Key? key,
  }) : super(key: key);

//TODO FALTA MANDAR PARA AS PAGINAS CERTAS DEPOIS
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: bgColor,
        child: ListView(
          children: [
            DrawerHeader(
              child: SvgPicture.asset("assets/images/logo-no-background.svg"),
            ),
            DrawerListTile(
              title: "Dashboard",
              svgSrc: "assets/icons/menu_dashboard.svg",
              press: () => onItemSelected(0),
            ),
            DrawerListTile(
              title: "Requerimentos",
              svgSrc: "assets/icons/menu_tran.svg",
              press: () => onItemSelected(1),
            ),
            DrawerListTile(
              title: "Task",
              svgSrc: "assets/icons/menu_task.svg",
              press: () => onItemSelected(2),
            ),
            DrawerListTile(
              title: "Documents",
              svgSrc: "assets/icons/menu_doc.svg",
              press: () => onItemSelected(3),
            ),
            DrawerListTile(
              title: "Store",
              svgSrc: "assets/icons/menu_store.svg",
              press: () => onItemSelected(4),
            ),
            DrawerListTile(
              title: "Notification",
              svgSrc: "assets/icons/menu_notification.svg",
              press: () => onItemSelected(5),
            ),
            DrawerListTile(
              title: "Profile",
              svgSrc: "assets/icons/menu_profile.svg",
              press: () => onItemSelected(6),
            ),
            DrawerListTile(
              title: "Settings",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () => onItemSelected(7),
            ),
          ],
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
        color: _isHovered
            ? secondaryColor
            : bgColor, // Cor do retângulo ao passar o mouse
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
