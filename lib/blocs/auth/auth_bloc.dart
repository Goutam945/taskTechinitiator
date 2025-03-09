import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: event.email, password: event.password);
      UserModel user = UserModel(uid: userCred.user!.uid, email: event.email, username: event.username);
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCred.user!.uid).get();
      UserModel user = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    await _auth.signOut();
    emit(AuthInitial());
  }
}
