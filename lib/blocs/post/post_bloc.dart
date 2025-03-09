import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_task/blocs/post/post_event.dart';
import 'package:new_task/blocs/post/post_state.dart';
import '../../models/post_model.dart';


class PostBloc extends Bloc<PostEvent, PostState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PostBloc() : super(PostLoading()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<AddPostEvent>(_onAddPost);
  }

  void _onFetchPosts(FetchPostsEvent event, Emitter<PostState> emit) async {
    emit(PostLoading());

    try {
      await _firestore.collection('posts')
          .orderBy('timestamp', descending: true)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isEmpty) {
          emit(PostLoaded([]));
        } else {
          List<PostModel> posts = snapshot.docs.map((doc) {
            return PostModel.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();
          emit(PostLoaded(posts));
        }
      });
    } catch (e) {
      emit(PostError("Firestore Error: ${e.toString()}"));
    }
  }


  Future<void> _onAddPost(AddPostEvent event, Emitter<PostState> emit) async {
    try {
      final post = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: event.message,
        username: event.username,
        timestamp: DateTime.now(),
      );

      await _firestore.collection('posts').doc(post.id).set(post.toJson());
    } catch (e) {
      emit(PostError("Firestore Error: ${e.toString()}"));
    }
  }



}
