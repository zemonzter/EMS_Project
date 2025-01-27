import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../eqt_page/util/models/dropdown_models.dart';
import 'util/dropdown_mttype.dart';
import 'util/dropdown_unit.dart';

const String url = "http://10.0.2.2/ems_dbcon/";

class InsertMT extends StatefulWidget {
  const InsertMT({super.key});

  @override
  State<InsertMT> createState() => _InsertMTState();
}

class _InsertMTState extends State<InsertMT> {
  TextEditingController mttype = TextEditingController();
  TextEditingController mtname = TextEditingController();
  TextEditingController unitid = TextEditingController();
  TextEditingController mtstock = TextEditingController();
  TextEditingController unitprice = TextEditingController();
  TextEditingController mtprice = TextEditingController();
  TextEditingController mtdate = TextEditingController();
  TextEditingController mtlink = TextEditingController();

  File? imagepath;
  String? imagename;
  String? imagedata;

  ImagePicker imagePicker = new ImagePicker();

  Future<void> insertMT() async {
    if (mttype.text != '' ||
        mtname.text != '' ||
        unitid.text != '' ||
        mtstock.text != '' ||
        unitprice.text != '' ||
        mtprice.text != '' ||
        mtdate.text != '' ||
        mtlink.text != '') {
      try {
        String uri = "${url}insert_mt.php";

        var res = await http.post(Uri.parse(uri), body: {
          "mttype": selectedMttype,
          "mtname": mtname.text,
          "unitid": selectedUnit,
          "mtstock": mtstock.text,
          "unitprice": unitprice.text,
          "mtprice": mtprice.text,
          "mtdate": mtdate.text,
          "mtlink": mtlink.text,
          "data": imagedata?.isNotEmpty == true
              ? imagedata
              : "", // Handle potential null for imagedata
          "name": imagename ?? "",
        });

        // if (res.statusCode == 200) {
        //   print(res.body);
        // } else {
        //   print("network error");
        // }
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

  Future<List<DropdownMttypeModel>> getMTType() async {
    try {
      final response = await http.get(Uri.parse("${url}view_mttype.php"));
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return DropdownMttypeModel(
              mttypeId: map["mttype_id"], mttypeName: map["mttype_name"]);
        }).toList();
      }
    } on SocketException {
      throw Exception('No Internet connection');
    }
    throw Exception("Fetch Data Error");
  }

  Future<List<DropdownUnitModel>> getUnit() async {
    try {
      final response = await http.get(Uri.parse("${url}view_unit.php"));
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return DropdownUnitModel(
              unitId: map["unit_id"], unitName: map["unit_name"]);
        }).toList();
      }
    } on SocketException {
      throw Exception('No Internet connection');
    }
    throw Exception("Fetch Data Error");
  }

  var selectedMttype;
  var selectedUnit;

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
          title:
              const Text("เพิ่มวัสดุ", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF7E0101),
          toolbarHeight: 120,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //dropdown button mt_type
                Column(
                  children: [
                    const SizedBox(height: 20),
                    FutureBuilder<List<DropdownMttypeModel>>(
                        future: getMTType(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                label: const Text("ประเภทวัสดุ"),
                              ),
                              borderRadius: BorderRadius.circular(18.0),
                              value: selectedMttype,
                              dropdownColor: Colors.deepPurple[100],
                              isExpanded: true, //ยาวเต็มหน้าจอ
                              hint: const Text("Select Item"),
                              items: snapshot.data!.map((e) {
                                return DropdownMenuItem(
                                    value: e.mttypeName.toString(),
                                    child: Text(e.mttypeName.toString()));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedMttype = value;
                                });
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else {
                            return const CircularProgressIndicator();
                          }
                        })
                  ],
                ),
                // DropdownFromAPI(), //eq_type
                const SizedBox(height: 20),
                TextFormField(
                  controller: mtname,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text("ชื่อวัสดุ"),
                  ),
                ), //user_id
                const SizedBox(height: 20),
                TextFormField(
                  controller: mtstock,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text("จำนวน"),
                  ),
                ), //eq_brand
                const SizedBox(height: 20),
                Column(
                  children: [
                    FutureBuilder<List<DropdownUnitModel>>(
                        future: getUnit(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                label: const Text("หน่วยนับ"),
                              ),
                              borderRadius: BorderRadius.circular(18.0),
                              value: selectedUnit,
                              dropdownColor: Colors.deepPurple[100],
                              isExpanded: true, //ยาวเต็มหน้าจอ
                              hint: const Text("Select Item"),
                              items: snapshot.data!.map((e) {
                                return DropdownMenuItem(
                                    value: e.unitName.toString(),
                                    child: Text(e.unitName.toString()));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedUnit = value;
                                });
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else {
                            return const CircularProgressIndicator();
                          }
                        })
                  ],
                ), //eq_model

                const SizedBox(height: 20),
                TextFormField(
                  controller: unitprice,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text("หน่วยละ"),
                  ),
                ), //price_unit

                const SizedBox(height: 20),
                TextFormField(
                  controller: mtprice,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text("จำนวนเงิน"),
                  ),
                ), //eq_serial

                const SizedBox(height: 20),
                TextFormField(
                  controller: mtdate,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text("วันที่ซื้อ"),
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
                        mtdate.text = formattedDate;
                      });
                    }
                  },
                ), //eq_date

                const SizedBox(height: 20),
                TextFormField(
                  controller: mtlink,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text("ลิงค์ข้อมูลเพิ่มเติม"),
                  ),
                ), //eq_serial

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
                    child: Text('Choose image')),

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
                          insertMT();
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
            ),
          ),
        ),
      ),
    );
  }
}
