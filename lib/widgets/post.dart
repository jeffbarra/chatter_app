import 'package:chatter/components/delete_button.dart';
import 'package:chatter/helper/helper_methods.dart';
import 'package:chatter/widgets/buttons/comment_button.dart';
import 'package:chatter/widgets/buttons/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/comment.dart';

class Post extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  Post({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
// Get user from Firebase
  final currentUser = FirebaseAuth.instance.currentUser!;

// Like Button - isLiked
  bool isLiked = false;

// Comment Text Controller
  final _commentTextController = TextEditingController();

// Init State
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if our current user's email is contained in the list of likes, isLiked = true
    isLiked = widget.likes.contains(currentUser.email);
  }

// Toggle 'like' button
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

// If User "Likes" Post -> Add it to Firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('user_posts').doc(widget.postId);

    if (isLiked) {
      // if the post is now liked, add the user's email to the "Likes" field (in the postMessage method)
      postRef.update({
        "Likes": FieldValue.arrayUnion(
            [currentUser.email]) // arrayUnion = "add to array"
      });
    } else {
      // if the post is now unliked, remove the user's email form the "Likes" field
      postRef.update({
        "Likes": FieldValue.arrayRemove(
            [currentUser.email]) // arrayRemove = "removes from array"
      });
    }
  }

// Add a Comment to Firestore -> create 'comments' collection
  void addComment(String commentText) {
    // adding collection called 'comments' to specific postId in 'user_posts' collection
    FirebaseFirestore.instance
        .collection('user_posts')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'CommentText': commentText,
      'CommentedBy': currentUser.email,
      'CommentTime': Timestamp.now()
    });
  }

// Show Dialog Box for Adding Comment
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade200,
        title: const Text('Add Comment',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextFormField(
          controller: _commentTextController,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Write a comment...',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // cancel button
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    // pop dialog box
                    Navigator.pop(context);
                    // clear controller
                    _commentTextController.clear();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ),

                const SizedBox(width: 10),

                // post comment button
                ElevatedButton(
                  onPressed: () {
                    // add comment on button press
                    addComment(_commentTextController.text);
                    // pop dialog box
                    Navigator.pop(context);
                    // clear controller
                    _commentTextController.clear();
                  },
                  child: const Text('Post Comment',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
// Post Tile
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Column(
            children: [
              // Profile pic, user, delete button row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // profile pic
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.deepPurple),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  // user who posted
                  Text(
                    widget.user,
                    style: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600),
                  ),
                  // Delete Post
                  DeleteButton(
                    onTap: () {
                      // Delete post confirmation dialog box
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.grey.shade200,
                          // header
                          title: const Text(
                            'Delete Post',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // content
                          content: const Text(
                            'Are you sure you want to delete this post?',
                            textAlign: TextAlign.center,
                          ),
                          // buttons
                          actions: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // cancel button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // delete button
                                  ElevatedButton(
                                    onPressed: () async {
                                      // delete the comments from firestore first
                                      // if you only delete the post, the comments will still remain

                                      // create variable called commentDocs
                                      final commentDocs =
                                          await FirebaseFirestore.instance
                                              .collection('user_posts')
                                              .doc(widget.postId)
                                              .collection('comments')
                                              .get();

                                      // delete the comments
                                      for (var doc in commentDocs.docs) {
                                        await FirebaseFirestore.instance
                                            .collection('user_posts')
                                            .doc(widget.postId)
                                            .collection('comments')
                                            .doc(doc.id)
                                            .delete()
                                            .then((value) =>
                                                print('comments deleted'))
                                            .catchError((error) =>
                                                'failed to delete comments: $error');
                                      }

                                      // then delete the post
                                      FirebaseFirestore.instance
                                          .collection('user_posts')
                                          .doc(widget.postId)
                                          .delete()
                                          .then(
                                            (value) => print('post deleted'),
                                          )
                                          .catchError(
                                            (error) => print(
                                                'failed to delete post: $error'),
                                          );

                                      // dismiss the dialog
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Post Row
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // post message
                      Text(
                        widget.message,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // like and comment buttons
              Row(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(width: 10),

                  // add number of likes
                  Text(widget.likes.length.toString()),
                  const SizedBox(width: 10),

                  // comment button
                  CommentButton(onTap: showCommentDialog),
                  const SizedBox(width: 10),

                  // add number of comments
                ],
              ),

              const SizedBox(height: 20),

              // Show Comments Under Post
              StreamBuilder<QuerySnapshot>(
                // listening for -> comments inside of user posts -> display in descending order based on comment time
                stream: FirebaseFirestore.instance
                    .collection('user_posts')
                    .doc(widget.postId)
                    .collection('comments')
                    .orderBy('CommentTime', descending: true)
                    .snapshots(),
                builder: ((context, snapshot) {
                  // show loading circle if no data
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor),
                    );
                  }

                  return ListView(
                    shrinkWrap: true, // for nested lists
                    physics: const NeverScrollableScrollPhysics(),
                    // grab snapshot data and return comments
                    children: snapshot.data!.docs.map((doc) {
                      // get comment from Firebase
                      final commentData = doc.data() as Map<String, dynamic>;

                      // return the comment
                      return Comment(
                          text: commentData['CommentText'],
                          user: commentData['CommentedBy'],
                          time: formatDate(commentData['CommentTime']));
                    }).toList(),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
