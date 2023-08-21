import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/drawer/drawer.dart';
import '../widgets/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// Current User
  final currentUser = FirebaseAuth.instance.currentUser!;

// Text Controller
  TextEditingController postController = TextEditingController();

// Post Message Method
  void postMessage() {
    // only post if there is something in the textfield
    if (postController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('user_posts').add({
        'UserEmail': currentUser.email,
        'Message': postController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    // clear text field after posting
    postController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'chatter',
          style: GoogleFonts.rammettoOne(color: Colors.white, fontSize: 24),
        ),
      ),
// Body
      drawer: const DrawerMenu(),
      body: Column(
        children: [
// Chatter Area (where all posts show up)
          Expanded(
            child: StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      // get the message
                      final post = snapshot.data!.docs[index];
                      // post message (message + user email)
                      return Post(
                        message: post['Message'],
                        user: post['UserEmail'],
                        postId: post.id,
                        likes: List<String>.from(post['Likes'] ?? []),
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return const Center(child: CircularProgressIndicator());
              },
              stream: FirebaseFirestore.instance
                  .collection('user_posts')
                  .orderBy('TimeStamp', descending: false)
                  .snapshots(),
            ),
          ),
// Post Text Field
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: postController,
                      decoration: InputDecoration(
                          hintText: 'What\'s on your mind?',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor))),
                    ),
                  ),
                ),

// Post Button
                IconButton(
                    onPressed: postMessage,
                    icon: Icon(Icons.arrow_circle_right,
                        color: Theme.of(context).primaryColor, size: 40))
              ],
            ),
          ),

          // Logged in user
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Center(
                child: Text(
              'Logged in as ${currentUser.email!}',
              style: const TextStyle(color: Colors.grey),
            )),
          ),
        ],
      ),
    );
  }
}
