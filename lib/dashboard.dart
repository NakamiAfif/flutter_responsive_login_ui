import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';

class Item {
  final String title;
  final String description;
  final List<String> images;

  Item(this.title, this.description, this.images);
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isRegistrationDialogOpen = false;
  List<Item> items = [];

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _openRegistrationDialog() async {
    setState(() {
      _isRegistrationDialogOpen = true;
    });

    final picker = ImagePicker();
    List<String> pickedImages = [];

    Future<void> _pickImages() async {
      List<XFile> resultList = [];
      try {
        resultList = await picker.pickMultiImage(maxWidth: 800, maxHeight: 800);
      } on PlatformException catch (e) {
        // Handle any errors
        print(e);
      }

      if (!mounted) return;

      setState(() {
        pickedImages = resultList.map((file) => file.path).toList();
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Item Registration'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Form field for capturing the title
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    // Add validation logic if needed
                  ),
                  SizedBox(height: 10),
                  // Form field for capturing the description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    // Add validation logic if needed
                  ),
                  SizedBox(height: 10),
                  // Button for choosing images
                  ElevatedButton(
                    onPressed: () {
                      _pickImages();
                    },
                    child: Text('Upload Images'),
                  ),
                  SizedBox(height: 10),
                  // Display the selected images
                  if (pickedImages.isNotEmpty)
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: pickedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.network(
                              'http://localhost/uploads/${path.basename(pickedImages[index])}',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Register'),
                  onPressed: () {
                    if (pickedImages.length == 3) {
                      String title = _titleController.text;
                      String description = _descriptionController.text;

                      Item item = Item(title, description, pickedImages);
                      registerItem(item);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Please choose 3 images.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      setState(() {
        _isRegistrationDialogOpen = false;
      });
    });
  }

  void registerItem(Item item) async {
    var url = 'http://localhost/barterit/register_item.php';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    if (item.images.length == 3) {
      for (var i = 0; i < item.images.length; i++) {
        var imageUrl = item.images[i];
        request.fields['picture[]'] = imageUrl;
      }

      request.fields['title'] = item.title;
      request.fields['description'] = item.description;

      var response = await request.send();

      if (response.statusCode == 200) {
        // Item registered successfully
        print('Item registered successfully');
        Navigator.of(context).pop();
      } else {
        // Failed to register item
        print('Failed to register item');
      }
    } else {
      // Not all three images are uploaded
      Fluttertoast.showToast(
        msg: "Please upload three images",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(
            255, 0, 0, 0), // Use the same background color as the login screen
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/signin_balls.png'),
              SizedBox(height: 20),
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: DashboardItem(
                                icon: Icons.list,
                                title: 'Item Listing',
                                onTap: () {
                                  // TODO: Implement item listing screen navigation
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: DashboardItem(
                                icon: Icons.search,
                                title: 'Search',
                                onTap: () {
                                  // TODO: Implement search screen navigation
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: DashboardItem(
                                icon: Icons.message,
                                title: 'Messaging',
                                onTap: () {
                                  // TODO: Implement messaging screen navigation
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: DashboardItem(
                                icon: Icons.star,
                                title: 'Reviews',
                                onTap: () {
                                  // TODO: Implement rating and reviews screen navigation
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 80,
                      right: 16,
                      child: FloatingActionButton(
                        backgroundColor: Color.fromARGB(255, 245, 244, 244),
                        onPressed: _openRegistrationDialog,
                        child: Icon(Icons.add, color: Colors.black),
                      ),
                    ),
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

class DashboardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  DashboardItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: Icon(icon, color: Colors.black, size: 30),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardScreen(),
  ));
}
