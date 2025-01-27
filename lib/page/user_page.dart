import 'dart:convert';

import 'package:ems_condb/eqt_page/util/insert_eq.dart';
import 'package:ems_condb/login.dart';
import 'package:ems_condb/mt_page/insert_mt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  final String token;
  const UserPage({Key? key, required this.token}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<Map<String, dynamic>> _getUserData() async {
    final response = await http.get(
      Uri.parse('https://api.rmutsv.ac.th/elogin/token/${widget.token}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      throw Exception(
          'Failed to retrieve user data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //         colors: [Colors.red[300]!, Colors.red[700]!],
      //       ),
      //     ),
      //   ),
      //   title:
      //       const Text('User Profile', style: TextStyle(color: Colors.white)),
      // ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              final userData = snapshot.data!;

              // Check for expected keys before accessing
              final expectedKeys = [
                'username',
                'name',
                'email',
                'type',
                'token',
              ];
              for (var key in expectedKeys) {
                if (!userData.containsKey(key)) {
                  print('Warning: Key "$key" missing in user data');
                }
              }

              return Column(
                children: [
                  Container(
                    // color: Colors.grey[700],
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.red[300]!, Colors.red[700]!],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70, bottom: 25),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/images/user.png'),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'E-Passport: ${userData['username']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text('Name: ${userData['name']}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text('Email: ${userData['email']}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text('Type: ${userData['type']}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                // Text('Token: ${userData['token']}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // floatingActionButton: FloatingActionButton(
                  //   onPressed: () {
                  //     // Handle settings button press
                  //   },
                  //   child: Icon(Icons.settings),
                  // ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.only(left: 25),
                    margin: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle import data functionality (e.g., navigate to import screen)
                            print('Import data tapped'); // Placeholder for now
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.note_add,
                                size: 30,
                                // color: Colors.red,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Import Data',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            // Handle import data functionality (e.g., navigate to import screen)
                            print('Export data tapped'); // Placeholder for now
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.arrow_circle_up,
                                size: 30,
                                // color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Export Data',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const InsertEq()));
                            // Handle import data functionality (e.g., navigate to import screen)
                            print('Add Equipment!'); // Placeholder for now
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add_to_queue,
                                size: 30,
                                // color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'เพิ่มครุภัณฑ์',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const InsertMT()));
                            // Handle import data functionality (e.g., navigate to import screen)
                            print('Add Material!'); // Placeholder for now
                          },
                          child: const Row(
                            children: [
                              Icon(
                                // Icons.add_shopping_cart,
                                Icons.post_add,
                                size: 30,
                                // color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'เพิ่มวัสดุ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                            // Handle import data functionality (e.g., navigate to import screen)
                            print('Logout!'); // Placeholder for now
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.logout,
                                size: 30,
                                // color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              );
            }

            // Return an empty container or any other widget as a fallback
            return const SizedBox();
          }),
    );
  }
}
