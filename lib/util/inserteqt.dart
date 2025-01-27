import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

const String url = "http://10.0.2.2/ems_dbcon/";

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  TextEditingController eqtname = TextEditingController();

  File? imagepath;
  String? imagename;
  String? imagedata;

  ImagePicker imagePicker = new ImagePicker();

  Future<void> insertType() async {
    if (eqtname.text != '') {
      try {
        String uri = "${url}insert.php";

        var res = await http.post(
          Uri.parse(uri),
          body: {
            "eqtname": eqtname.text,
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
          title: const Text('เพิ่มประเภท'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: eqtname,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  label: const Text('เพิ่มประเภท'),
                ),
              ),
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
                        insertType();
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
    );
  }
}
