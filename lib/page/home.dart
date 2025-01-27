import 'dart:convert';

import 'package:ems_condb/page/equipment.dart';
import 'package:ems_condb/page/maintenance.dart';
import 'package:ems_condb/util/block.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'budget.dart';
import 'material.dart';

const String url = "http://10.0.2.2/ems_dbcon/";
// const String url = "http://localhost/ems_dbcon/";

class HomePage extends StatefulWidget {
  final String? token;
  const HomePage({super.key, this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List eqtdata = [];
  List record = [];

  Future<void> getrecord() async {
    String uri = "${url}home.php";
    try {
      var response = await http.get(Uri.parse(uri));

      setState(() {
        eqtdata = jsonDecode(response.body);
        record = jsonDecode(response.body);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getrecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 100,
          ),
        ),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
          ),
          itemCount: eqtdata.length,
          itemBuilder: (context, index) {
            final String id = eqtdata[index]['home_id'] ?? '';
            final String name = eqtdata[index]['home_name'] ?? '';
            final String image = (url + record[index]["home_img"] ?? "");

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Block container with two rows
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                    ),
                    BlockDetail(
                      blockName: name,
                      blockImage: image,
                      onTap: () {
                        Widget targetPage;
                        if (id == '1') {
                          targetPage = const EquipmentPage();
                        } else if (id == '2') {
                          // targetPage = MaterialPage();
                          targetPage = const MaterialsPage();
                        } else if (id == '3') {
                          // targetPage = MaterialPage();
                          targetPage = MaintenancePage(token: widget.token);
                        } else if (id == '4') {
                          // targetPage = MaterialPage();
                          targetPage = const BudgetPage();
                        } else {
                          // Handle unexpected home_id values (optional)
                          print('Unexpected home_id: $id');
                          targetPage = const Scaffold(
                            body: Center(
                              child: Text('Invalid Page'),
                            ),
                          );
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => targetPage),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
