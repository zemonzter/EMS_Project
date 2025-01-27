import 'dart:convert';
import 'dart:io';

import 'package:ems_condb/eqt_page/util/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'models/dropdown_model.dart';

const String url = "http://10.0.2.2/ems_dbcon/";

class InsertEq extends StatefulWidget {
  const InsertEq({super.key});

  @override
  State<InsertEq> createState() => _InsertEqState();
}

class _InsertEqState extends State<InsertEq> {
  TextEditingController eqtname = TextEditingController();
  TextEditingController userid = TextEditingController();
  TextEditingController eqmodel = TextEditingController();
  TextEditingController eqbrand = TextEditingController();
  TextEditingController eqserial = TextEditingController();
  TextEditingController eqstatus = TextEditingController();
  TextEditingController eqprice = TextEditingController();
  TextEditingController eqdate = TextEditingController();
  TextEditingController eqwarran = TextEditingController();

  File? imagepath;
  String? imagename;
  String? imagedata;

  ImagePicker imagePicker = ImagePicker();

  Future<void> insertEq() async {
    if (eqtname.text != '' ||
        userid.text != '' ||
        eqmodel.text != '' ||
        eqbrand.text != '' ||
        eqserial.text != '' ||
        eqstatus.text != '' ||
        eqprice.text != '' ||
        eqdate.text != '' ||
        eqwarran.text != '') {
      try {
        String uri = "${url}insert_eq.php";

        var res = await http.post(
          Uri.parse(uri),
          body: {
            "eqtname": selectedValue,
            "userid": userid.text, //ตัวหน้าต้องตรงกับชื่อ backend
            "eqmodel": eqmodel.text,
            "eqbrand": eqbrand.text,
            "eqserial": eqserial.text,
            "eqstatus": eqstatus.text,
            "eqprice": eqprice.text,
            "eqdate": eqdate.text,
            "eqwarran": eqwarran.text,
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

  Future<List<DropdownModel>> getPost() async {
    try {
      final response = await http.get(Uri.parse("${url}view_eqt.php"));
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return DropdownModel(eqtId: map["eqt_id"], eqtName: map["eqt_name"]);
        }).toList();
      }
    } on SocketException {
      throw Exception('No Internet connection');
    }
    throw Exception("Fetch Data Error");
  }

  var selectedValue;

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
          title: const Text("เพิ่มครุภัณฑ์",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF7E0101),
          toolbarHeight: 120,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //dropdown button eq_type
                Column(
                  children: [
                    const SizedBox(height: 20),
                    FutureBuilder<List<DropdownModel>>(
                        future: getPost(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                label: const Text("ประเภทครุภัณฑ์"),
                              ),
                              borderRadius: BorderRadius.circular(18.0),
                              value: selectedValue,
                              dropdownColor: Colors.deepPurple[100],
                              isExpanded: true, //ยาวเต็มหน้าจอ
                              hint: const Text("Select Item"),
                              items: snapshot.data!.map((e) {
                                return DropdownMenuItem(
                                    value: e.eqtName.toString(),
                                    child: Text(e.eqtName.toString()));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
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
                  controller: userid,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text("ผู้ถือครอง"),
                  ),
                ), //user_id
                const SizedBox(height: 20),
                TextFormField(
                  controller: eqmodel,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text("รุ่นครุภัณฑ์"),
                  ),
                ), //eq_model
                const SizedBox(height: 20),
                TextFormField(
                  controller: eqbrand,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text("ยี่ห้อ"),
                  ),
                ), //eq_brand
                const SizedBox(height: 20),
                TextFormField(
                  controller: eqserial,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text("หมายเลขซีเรียล"),
                  ),
                ), //eq_serial
                const SizedBox(height: 20),
                TextFormField(
                  controller: eqstatus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text("สถานะ"),
                  ),
                ), //eq_status
                const SizedBox(height: 20),
                TextFormField(
                  controller: eqprice,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text("ราคา"),
                  ),
                ), //eq_price
                const SizedBox(height: 20),
                TextFormField(
                  controller: eqdate,
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
                        eqdate.text = formattedDate;
                      });
                    }
                  },
                ), //eq_date
                const SizedBox(height: 20),
                TextFormField(
                  controller: eqwarran,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text("ระยะเวลาประกัน"),
                  ),
                ), //eq_warran
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
                          insertEq();
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
