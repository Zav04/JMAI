import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final String title, svgSrc;
  final int index;
  final Function(int) onItemSelected;

  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.index,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onItemSelected(index),
    );
  }
}
