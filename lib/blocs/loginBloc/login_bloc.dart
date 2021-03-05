import 'dart:async';
import 'package:ftc_application/blocs/loginBloc/login.dart';
import 'package:ftc_application/repositories/user_repo.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:ftc_application/authenticationBloc/authentication.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepo userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      final String token = await userRepository.authenticate(
        username: event.username,
        password: event.password,
      );

      if (token == 'Incorrect username or password' ||
          token == 'Oops Something Went Wrong') {
        yield LoginFailure(error: token);
      } else {
        authenticationBloc.add(LoggedIn(
            token: token, username: event.username, password: event.password));
        yield LoginFinished();
      }
    }
  }
}
