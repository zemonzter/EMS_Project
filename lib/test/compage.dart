import 'dart:convert';

import 'package:ems_condb/eqt_page/util/showproduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'util/insert_eq.dart';

const String url = "http://10.0.2.2/ems_dbcon/";

class ComputerPage extends StatefulWidget {
  const ComputerPage({super.key});

  @override
  State<ComputerPage> createState() => _ComputerPageState();
}

class _ComputerPageState extends State<ComputerPage> {
  List eqdata = [];
  List filteredData = []; // List for filtered search results
  String searchText = ''; // Store user's search query

  Future<void> getrecord() async {
    String uri = "${url}view_eq.php";
    try {
      var response = await http.get(Uri.parse(uri));
      setState(() {
        eqdata = jsonDecode(response.body);
        filteredData = eqdata; // Initially, show all data
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getrecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เครื่องคอมพิวเตอร์'),
        backgroundColor: const Color(0xFFFFB74B),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const InsertEq()),
              // );
            },
            icon: const Icon(Icons.add),
          ),
          // Search bar
          // IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    //filter search results
                    setState(() {
                      searchText = value;
                      filteredData = eqdata
                          .where((item) =>
                              item['eq_brand']
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase()) ||
                              item['eq_model']
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase()))
                          .toList();
                    });
                  },
                  decoration: InputDecoration(
                    // fillColor: Colors.yellow[100],
                    // filled: true,
                    // hintText: 'ค้นหา...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 10),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Divider(
                // Add a Divider below the TextFormField
                color: Colors.grey[600], // Adjust color as needed
                height: 1.0, // Adjust thickness as needed
                thickness: 1.0, //ความหนา
                indent: 16.0, //ระยะห่างจากซ้าย
                endIndent: 16.0, //ระยะห่างจากขวา
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final filteredData = this.filteredData[index];
                final String id = filteredData['eq_id'] ?? '';
                final String brand = filteredData['eq_brand'] ?? '';
                final String name = filteredData['eq_model'] ?? '';
                final String image = (url + filteredData["eq_img"] ?? "");
                final String user = filteredData['user_id'] ?? '';

                return SafeArea(
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
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
