import 'package:flutter/material.dart';

import 'widget/main_content.dart';
import 'widget/nav_item.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Row(
        children: [
          SideNav(),
          Expanded(child: MainContent()),
        ],
      ),
    );
  }
}
