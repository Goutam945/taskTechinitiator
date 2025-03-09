import 'package:equatable/equatable.dart' show Equatable;

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final String email, password, username;
  SignUpEvent(this.email, this.password, this.username);
}

class SignInEvent extends AuthEvent {
  final String email, password;
  SignInEvent(this.email, this.password);
}

class SignOutEvent extends AuthEvent {}
