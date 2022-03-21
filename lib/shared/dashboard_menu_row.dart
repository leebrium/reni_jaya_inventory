import 'package:flutter/material.dart';
import 'package:reni_jaya_inventory/shared/label_below_icon.dart';

class DashboardMenuRow extends StatelessWidget {
  final List<LabelBelowIcon> listMenu;

  const DashboardMenuRow({
    required Key key,
    required this.listMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: List.generate(listMenu.length, (index) {
          return listMenu[index];
        }),
      ),
    );
  }
}