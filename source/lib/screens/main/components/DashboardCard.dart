import 'package:flutter/material.dart';
import 'package:JMAI/Class/DashboardCardInfo.dart';

class DashboardCard extends StatelessWidget {
  final DashboardCardInfo info;

  const DashboardCard({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(info.icon, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text(
                  info.value,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  info.title,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Text(
              '*Dados ilustrativos',
              style: TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
