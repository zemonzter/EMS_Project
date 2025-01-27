import 'dart:convert';

import 'package:ems_condb/eqt_page/compage.dart';
import 'package:ems_condb/eqt_page/keyboardpage.dart';
import 'package:ems_condb/eqt_page/mousepage.dart';
import 'package:ems_condb/eqt_page/printerpage.dart';
import 'package:ems_condb/eqt_page/util/insert_eq.dart';
import 'package:ems_condb/util/block.dart';
import 'package:ems_condb/util/inserteqt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../eqt_page/monitorpage.dart';

const String url = "http://10.0.2.2/ems_dbcon/";

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _HomePageState();
}

class _HomePageState extends State<EquipmentPage> {
  List eqtdata = [];
  List record = [];

  Future<void> getrecord() async {
    String uri = "${url}view_eqt.php";
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
      appBar: AppBar(
        title:
            const Text("ประเภทครุภัณฑ์", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF7E0101),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InsertEq()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
          ),
          itemCount: record.length,
          itemBuilder: (context, index) {
            final String id = eqtdata[index]['eqt_id'] ?? '';
            final String name = eqtdata[index]['eqt_name'] ?? '';
            final String image = (url + record[index]["eqt_img"] ?? "");
            //final String image = (record[index]["http://10.0.2.2/test_condb/"] ?? "") + "/test_condb";

            return SafeArea(
              // child: Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.all(16.0),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlockDetail(
                          blockName: name,
                          blockImage: image,
                          onTap: () {
                            Widget targetPage;
                            if (id == '1') {
                              targetPage = const ComputerPage();
                            } else if (id == '2') {
                              targetPage = const MonitorPage();
                            } else if (id == '3') {
                              targetPage = const MousePage();
                            } else if (id == '4') {
                              targetPage = const KeyboardPage();
                            } else if (id == '5') {
                              targetPage = const PrinterPage();
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
                              MaterialPageRoute(
                                  builder: (context) => targetPage),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                  // ),
                ),
              ),
            );
          }),
    );
  }
}
