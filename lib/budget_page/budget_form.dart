import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String url = "http://10.0.2.2/ems_dbcon/";

class BudgetForm extends StatefulWidget {
  const BudgetForm({super.key});

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final _budgetTypes = ["ครุภัณฑ์", "วัสดุ"]; // List of budget types
  var _selectedType; // Initial selected type

  TextEditingController budgettype = TextEditingController();
  TextEditingController budgetname = TextEditingController();
  TextEditingController budgetamount = TextEditingController();
  TextEditingController budgetyear = TextEditingController();

  Future<void> budgetForm() async {
    if (budgettype.text != '' ||
        budgetname.text != '' ||
        budgetamount.text != '' ||
        budgetyear.text != '') {
      try {
        String uri = "${url}budget_form.php";

        var res = await http.post(
          Uri.parse(uri),
          body: {
            "budgettype": _selectedType,
            "budgetname": budgetname.text,
            "budgetamount": budgetamount.text,
            "budgetyear": budgetyear.text,
          },
        );

        var response = jsonDecode(res.body);
        if (response['success'] == 'true') {
          print("Record inserted successfully");
        } else {
          print("Error inserting record");
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("please fill all the details");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // centerTitle: true,
          title: const Text("ฟอร์มงบประมาณ",
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF7E0101),
          toolbarHeight: 120,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    DropdownButtonFormField(
                      value: _selectedType, // Set initial value
                      items: _budgetTypes
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedType =
                              value as String; // Update selected type
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "ประเภทงบประมาณ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: budgetname,
                      decoration: InputDecoration(
                        labelText: "รายละเอียดงบประมาณ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: budgetamount,
                      decoration: InputDecoration(
                        labelText: "จำนวนเงิน",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: budgetyear,
                      decoration: InputDecoration(
                        labelText: "ปีงบประมาณ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              budgetForm();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'ยืนยัน',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('ยกเลิก')),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
