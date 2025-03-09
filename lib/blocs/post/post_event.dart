import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddPostEvent extends PostEvent {
  final String message;
  final String username;

  AddPostEvent(this.message, this.username);
}

class FetchPostsEvent extends PostEvent {}

