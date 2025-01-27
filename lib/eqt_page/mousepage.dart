import 'dart:convert';

import 'package:ems_condb/eqt_page/util/showproduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'util/insert_eq.dart';

const String url = "http://10.0.2.2/ems_dbcon/";

class MousePage extends StatefulWidget {
  const MousePage({super.key});

  @override
  State<MousePage> createState() => _MousePageState();
}

class _MousePageState extends State<MousePage> {
  List eqdata = [];
  List record = [];

  Future<void> getrecord() async {
    String uri = "${url}view_eq.php";
    try {
      var response = await http.get(Uri.parse(uri));

      setState(() {
        eqdata = jsonDecode(response.body);
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
        title: const Text('เม้าส์'),
        backgroundColor: const Color(0xFFFFB74B),
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
          itemCount: eqdata
              .where((data) => data['eq_type'] == 'เม้าส์')
              .length, // Filter by eqt_id
          itemBuilder: (context, index) {
            final filteredData = eqdata
                .where((data) => data['eq_type'] == 'เม้าส์')
                .toList()[index]; // Filtered data
            final String id = filteredData['eq_id'] ?? '';
            final String brand = filteredData['eq_brand'] ?? '';
            final String name = filteredData['eq_model'] ?? '';

            final String image = (url + filteredData["eq_img"] ?? "");
            final String user = filteredData['user_id'] ?? '';
            //final String image = (record[index]["http://10.0.2.2/test_condb/"] ?? "") + "/test_condb";

            return SafeArea(
              // child: Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Showproduct(
                          brand: brand,
                          blockName: name,
                          blockImage: image,
                          blockHN: id,
                          user: user,
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
