// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../blocs/auth/auth_bloc.dart';
// import '../blocs/auth/auth_event.dart';
// import '../blocs/post/post_bloc.dart';
// import '../blocs/post/post_event.dart';
// import '../blocs/post/post_state.dart';
// import '../models/user_model.dart';
//
// class HomeScreen extends StatefulWidget {
//   final UserModel user;
//   const HomeScreen({Key? key, required this.user}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _postController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<PostBloc>().add(FetchPostsEvent());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Social App'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               context.read<AuthBloc>().add(SignOutEvent());
//               Navigator.pushReplacementNamed(context, '/auth');
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _postController,
//                     decoration: InputDecoration(
//                       hintText: 'Write a post...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_postController.text.isNotEmpty) {
//                       context.read<PostBloc>().add(AddPostEvent(_postController.text, widget.user.username));
//                       _postController.clear();
//                     }
//                   },
//                   child: Text('Post'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: _buildPostList()
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPostList() {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection("posts")
//           .orderBy("timestamp", descending: true)
//           .snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//
//         return ListView(
//           children: snapshot.data!.docs.map((doc) {
//             return ListTile(
//               title: Text(doc["message"]),
//               subtitle: Text("Posted by: ${doc["username"]}"),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/post/post_bloc.dart';
import '../blocs/post/post_event.dart';
import '../models/user_model.dart';
import '../utility.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(FetchPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black theme
      appBar: AppBar(
        title: const Text(
          'Social Media',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: Colors.purpleAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Utility.showDeleteDialog(context: context, onPositiveClick: (){
                context.read<AuthBloc>().add(SignOutEvent());
              });

            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPostInput(),
          Expanded(child: _buildPostList()),
        ],
      ),
    );
  }

  // Post Input Section
  Widget _buildPostInput() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _postController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              if (_postController.text.isNotEmpty) {
                context.read<PostBloc>().add(AddPostEvent(_postController.text, widget.user.username));
                _postController.clear();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purpleAccent, Colors.pinkAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text("Post", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // Post List Section
  Widget _buildPostList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("posts")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator(color: Colors.white));

        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildPostCard(doc)).toList(),
        );
      },
    );
  }

  // Custom Post Card
  Widget _buildPostCard(QueryDocumentSnapshot doc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username and Avatar
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[800],
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  doc["username"],
                  style: const TextStyle(color: Colors.white,
                      fontSize:16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Post Message
            Text(
              doc["message"],
              style: TextStyle(color: Colors.white,fontSize:14),
            ),
            const SizedBox(height: 10),
            // Like & Comment Buttons
          ],
        ),
      ),
    );
  }
}
