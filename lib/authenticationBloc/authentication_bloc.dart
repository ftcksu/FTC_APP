import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/repositories/user_repo.dart';
import 'package:ftc_application/src/models/Member.dart';
import './authentication.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepo userRepo;
  final FtcRepository ftcRepository;
  AuthenticationBloc({@required this.userRepo, this.ftcRepository})
      : assert(userRepo != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepo.hasToken();
      if (hasToken) {
        try {
          yield AuthenticationLoading();
          Member member = await ftcRepository.getCurrentMember();
          print(member.id);
          yield AuthenticationAuthenticated(member: member);
        } catch (e) {
          yield* _loginFail();
        }
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepo.persistToken(event.token);
      await userRepo.persistUserCredentials(event.username, event.password);
      yield AuthenticationUninitialized();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepo.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }

  Stream<AuthenticationState> _loginFail() async* {
    yield AuthenticationLoading();
    try {
      await ftcRepository.reLogIn();
      yield AuthenticationUninitialized();
    } catch (e) {
      yield LoginFailed();
    }
  }
}
