import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final Member member;

  AuthenticationAuthenticated({this.member});
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class LoginFailed extends AuthenticationState {}

