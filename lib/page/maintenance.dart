import 'dart:convert';

import 'package:flutter/material.dart';
import '../mainten_page/mainten_form.dart';
import 'package:http/http.dart' as http;

const String url = "http://10.0.2.2/ems_dbcon/";

class MaintenancePage extends StatefulWidget {
  final String? token;
  const MaintenancePage({super.key, this.token});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  List bgdata = [];

  Future<void> getrecord() async {
    String uri = "${url}view_mainten.php";
    try {
      var response = await http.get(Uri.parse(uri));

      setState(() {
        bgdata = jsonDecode(response.body);
        // bgdata.sort((a, b) =>
        //     int.parse(b['mainten_id']) -
        //     int.parse(a['mainten_id'])); // Sort by year descending
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
    int maxLength = 16; //จำกัดความยาว text

    return Scaffold(
      appBar: AppBar(
        title: const Text("แจ้งซ่อม", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF7E0101),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MaintenanceForm(
                          token: widget.token,
                        )),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: bgdata.length,
        itemBuilder: (context, index) {
          String text = bgdata[index]["user_mainten"]; //ข้อความที่จะแสดง
          String displayedText =
              text.length > maxLength //ตัดคำที่เกินจำนวนที่กำหนด
                  ? text.substring(0, maxLength) +
                      "..." //ถ้าเกินจำนวนจะตัดและเติม ...
                  : text;
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bgdata[index]["eq_id"],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  bgdata[index]["mainten_detail"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              displayedText,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              bgdata[index]["mainten_date"],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "สถานะ: ${bgdata[index]["mainten_status"]}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
