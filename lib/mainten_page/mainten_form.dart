import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

const String url = "http://10.0.2.2/ems_dbcon/";
const String api = "https://api.rmutsv.ac.th/elogin/token/";

class MaintenanceForm extends StatefulWidget {
  final String? token;
  const MaintenanceForm({super.key, required this.token});

  @override
  State<MaintenanceForm> createState() => _MaintenanceFormState();
}

class _MaintenanceFormState extends State<MaintenanceForm> {
  TextEditingController eqid = TextEditingController();
  TextEditingController maintendate = TextEditingController();
  TextEditingController maintendetail = TextEditingController();
  String? user_mainten;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? imagepath;
  String? imagename;
  String? imagedata;

  ImagePicker imagePicker = ImagePicker();

  Future<Map<String, dynamic>> _getUserData() async {
    final response = await http.get(Uri.parse(api + widget.token!));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      throw Exception(
          'Failed to retrieve user data. Status code: ${response.statusCode}');
    }
  }

  Future<void> maintenForm() async {
    // final _formKey = FormState.of(context);
    if (_formKey.currentState!.validate()) {
      // if (eqid.text != '' || maintendate.text != '' || maintendetail.text != '') {
      try {
        String uri = "${url}mainten_form.php";

        final userData = await _getUserData();

        var res = await http.post(
          Uri.parse(uri),
          body: {
            "eqid": eqid.text,
            "maintendate": maintendate.text,
            "maintendetail": maintendetail.text,
            "usermainten": "${userData['name']}",
            "data": imagedata?.isNotEmpty == true
                ? imagedata
                : "", // Handle potential null for imagedata
            "name": imagename ?? "", // Handle potential null for imagename
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

  Future<void> getImage() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imagepath = File(getimage!.path);
      imagename = getimage.path.split('/').last;
      imagedata = base64Encode(imagepath!.readAsBytesSync());
      print(imagepath);
      print(imagename);
      print(imagedata);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("แจ้งซ่อม", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF7E0101),
          toolbarHeight: 120,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: eqid,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          label: const Text("เลขครุภัณฑ์"),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'กรุณากรอกข้อมูลเลขครุภัณฑ์';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: maintendate,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          label: const Text("วันที่แจ้งซ่อม"),
                        ),
                        onTap: () async {
                          DateTime? datetime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100));

                          if (datetime != null) {
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(datetime);

                            setState(() {
                              maintendate.text = formattedDate;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: maintendetail,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          label: const Text("อาการ/ปัญหา"),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'กรุณากรอกข้อมูลอาการ/ปัญหา';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      FutureBuilder<Map<String, dynamic>>(
                          future: _getUserData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasData) {
                              final userData = snapshot.data!;

                              final expectedKeys = [
                                'name',
                              ];
                              for (var key in expectedKeys) {
                                if (!userData.containsKey(key)) {
                                  print(
                                      'Warning: Key "$key" missing in user data');
                                }
                              }

                              return TextFormField(
                                // controller: user_mainten,

                                enabled: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  label:
                                      Text('ผู้แจ้งซ่อม: ${userData['name']}'),
                                ),
                              );
                            }

                            // Default return statement
                            return const SizedBox.shrink();
                          }),
                      const SizedBox(height: 20),
                      imagepath != null
                          ? Image.file(imagepath!)
                          : Image.asset('assets/images/default.jpg'),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            getImage();
                          },
                          child: const Text('Choose image')),
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
                                maintenForm();
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                }
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
      ),
    );
  }
}
