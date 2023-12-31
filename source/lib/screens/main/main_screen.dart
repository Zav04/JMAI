import 'package:JMAI/controllers/MenuAppController.dart';
import 'package:JMAI/screens/main/components/responsive.dart';
import 'package:JMAI/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:JMAI/screens/dashboard/requerimentos.dart';
import 'components/side_menu.dart';
import 'components/constants.dart';

class MainScreen extends StatefulWidget {
  final String? hashedId;
  final String? acountType;
  final String? token;

  const MainScreen({Key? key, this.token, this.hashedId, this.acountType})
      : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),
    Requerimentos(),
    DashboardScreen(),
    DashboardScreen(),
    DashboardScreen(),
    DashboardScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(
        onItemSelected: _onItemTapped,
        role: widget.acountType!,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(
                  onItemSelected: _onItemTapped,
                  role: widget.acountType!,
                ),
              ),
            Expanded(
              flex: 5,
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
