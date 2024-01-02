import 'package:JMAI/controllers/MenuAppController.dart';
import 'package:JMAI/screens/main/components/responsive.dart';
import 'package:JMAI/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:JMAI/screens/Utente/requerimentos.dart';
import 'components/side_menu.dart';
import 'components/constants.dart';
import 'package:JMAI/Class/Utilizador.dart';
import 'package:JMAI/Class/Utente.dart';
import 'package:JMAI/Class/Medico.dart';
import 'package:JMAI/class/SecretarioClinico.dart';
import 'package:JMAI/screens/Admin/SignupMedico.dart';
import 'package:JMAI/screens/Admin/SignupSecretarioClinico.dart';

class MainScreen extends StatefulWidget {
  final Utilizador? user;
  final String? uid;

  const MainScreen({Key? key, this.uid, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _setupPages();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setupPages() {
    // Limpa as páginas existentes
    _pages.clear();

    // Adiciona a Dashboard para todos os usuários
    _pages.add(DashboardScreen(user: widget.user));

    verificarTipoUsuario(widget.user!);
  }

  void verificarTipoUsuario(Utilizador user) {
    if (user is Utente) {
      _pages.addAll([
        Requerimentos(user: user),
      ]);
    } else if (user is Medico) {
      _pages.addAll([
        // Páginas específicas para Medico
      ]);
    } else if (user is SecretarioClinico) {
      _pages.addAll([
        // Páginas específicas para SecretarioClinico
      ]);
    } else {
      _pages.addAll([
        SignupSecretarioClinico(user: widget.user),
        SignupMedico(user: widget.user),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(
        onItemSelected: _onItemTapped,
        user: widget.user!,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(
                  onItemSelected: _onItemTapped,
                  user: widget.user!,
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
