import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_task/screens/auth_screen.dart';
import 'package:new_task/screens/home_screen.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_state.dart';
import 'blocs/post/post_bloc.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore.instance.collection('posts').get().then((snapshot) {
    if (snapshot.docs.isEmpty) {
      print('❌ No posts found in Firestore.');
    } else {
      for (var doc in snapshot.docs) {
        print('✅ Post Found: ${doc.data()}');
      }
    }
  }).catchError((error) {
    print('❌ Firestore Error: $error');

  });


  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => PostBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return HomeScreen(user: state.user,);
          }
          return AuthScreen();
        },
      ),
    );
  }
}
