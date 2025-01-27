import 'package:ems_condb/page/home.dart';
import 'package:flutter/material.dart';

import '../page/user_page.dart';

class TabMenuPage extends StatefulWidget {
  final String token;
  const TabMenuPage({Key? key, required this.token}) : super(key: key);

  @override
  State<TabMenuPage> createState() => _TabMenuPageState();
}

class _TabMenuPageState extends State<TabMenuPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home_outlined),
              ),
              Tab(
                icon: Icon(Icons.dashboard_customize_outlined),
              ),
              Tab(
                icon: Icon(Icons.person_outline),
              ),
            ],
          ),
          body: TabBarView(
            children: [
              Center(child: HomePage(token: widget.token)),
              Center(child: Text('Dashboard')),
              Center(child: UserPage(token: widget.token)),
            ],
          ),
        ),
      ),
    );
  }
}
