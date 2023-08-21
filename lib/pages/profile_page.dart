import 'dart:io';
import 'package:chatter/pages/home_page.dart';
import 'package:chatter/widgets/profile_text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/auth_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
// Get Current User
  final currentUser = FirebaseAuth.instance.currentUser!;

// Reference to ALL Users called usersCollection
  final usersCollection = FirebaseFirestore.instance.collection('users');

// Edit Field
  Future<void> editField(String field) async {
    // create empty string value
    String newValue = "";
    await showDialog(
      context: context,
      // dialog box when edit button is clicked
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade200,
        title: Text(
          'Edit $field',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple)),
            hintText: 'Enter new $field',
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          // assign new value to the value of 'username'
          onChanged: (value) {
            newValue = value;
          },
        ),
        // Buttons
        actions: [
          // cancel button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // save button
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: ElevatedButton(
                  onPressed: () {
                    // pop dialog with new value of edit field
                    Navigator.of(context).pop(newValue);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // update new username to Firestore ONLY if edit field has data
    if (newValue.isNotEmpty) {
      // current user from usersCollection -> update field with new value
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  // Image Picker
  imagePickDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text('Upload Image',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor))),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    profileImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: const Icon(
                  Icons.camera_alt,
                  size: 40,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              InkWell(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    profileImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: const Icon(
                  Icons.photo_library_rounded,
                  size: 40,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// Profile Pic File Image
  File? profileImage;

  // Auth Controller
  AuthController? authController;

// Init State
  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child:
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          )
        ],
        title: const Text('Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      ),

// Body
      body: StreamBuilder<DocumentSnapshot>(
        // stream -> listening for collection of 'users'
        stream: FirebaseFirestore.instance
            .collection('users')
            // find doc of currentUser.email
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          // get user data
          if (snapshot.hasData) {
            // store found data in 'userData' variable
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            // display as ListView
            return ListView(
              children: [
                // profile pic
                InkWell(
                  onTap: () {
                    imagePickDialog();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 35),
                    padding: const EdgeInsets.all(2),
                    // avatar circular border

                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: profileImage == null
                              ? const CircleAvatar(
                                  radius: 56,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 56,
                                  backgroundColor: Colors.white,
                                  backgroundImage: FileImage(
                                    profileImage!,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // User Email
                Text(
                  currentUser.email!,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

// User Details
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 20),
                  child: Text('My Details',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),

                // Username
                ProfileTextBox(
                  // display stored data from userData variable ('username)
                  text: userData['username'],
                  sectionName: 'Username',
                  onPressed: () => editField('username'),
                ),

                // display stored data from userData variable ('bio')
                ProfileTextBox(
                  // display  ('bio')
                  text: userData['bio'],
                  sectionName: 'Bio',
                  onPressed: () => editField('bio'),
                ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        onPressed: () async {
                          // show save confirmation dialog box
                          showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                  title: Text('Profile Saved',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))));
                          // Save image to firebase storage
                          String imageUrl = await authController!
                              .uploadImageToFirebaseStorage(profileImage!);
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                )
              ],
            );
            // error handlers
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }

          return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor));
        },
      ),
    );
  }
}
