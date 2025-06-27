import 'package:flutter/material.dart';

class DashboardDivider extends StatelessWidget {
  const DashboardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Divider(thickness: 1.2),
    );
  }
}
