import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/repositories/firebase_notification_handler.dart';
import 'package:ftc_application/repositories/ftc_api_client.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/repositories/user_repo.dart';
import 'package:ftc_application/route_generator.dart';
import 'package:ftc_application/blocs.dart';
import 'package:ftc_application/src/screens/MainScreens/tabs.dart';
import 'package:ftc_application/src/screens/failure_screen.dart';
import 'package:ftc_application/src/screens/signIn_page.dart';
import 'package:ftc_application/src/screens/splash_screen.dart';

void main() {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseNotifications firebaseNotifications =
      FirebaseNotifications(scaffoldKey);

  final FtcRepository ftcRepository = FtcRepository(
      ftcApiClient: FtcApiClient(firebaseMessaging: firebaseNotifications));

  final UserRepo userRepo = UserRepo(ftcRepository: ftcRepository);

  List<BlocProvider> providers = [
    BlocProvider<EventsBloc>(
      create: (context) => EventsBloc(ftcRepository: ftcRepository),
    ),
    BlocProvider<MemberBloc>(
      create: (context) => MemberBloc(ftcRepository: ftcRepository),
    ),
    BlocProvider<MemberJobsBloc>(
      create: (context) => MemberJobsBloc(ftcRepository: ftcRepository),
    ),
    BlocProvider<MemberTasksBloc>(
      create: (context) => MemberTasksBloc(ftcRepository: ftcRepository),
    ),
    BlocProvider<MemberEventsBloc>(
      create: (context) => MemberEventsBloc(ftcRepository: ftcRepository),
    ),
    BlocProvider<AdminBloc>(
      create: (context) => AdminBloc(ftcRepository: ftcRepository),
    ),
    BlocProvider<NotificationBloc>(
      create: (context) => NotificationBloc(ftcRepository: ftcRepository),
    ),
    BlocProvider<AuthenticationBloc>(
      create: (context) =>
          AuthenticationBloc(userRepo: userRepo, ftcRepository: ftcRepository)
            ..add(AppStarted()),
    ),
    BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
            userRepository: userRepo,
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context))),
  ];

  runApp(MultiBlocProvider(
    providers: providers,
    child: App(ftcRepository, scaffoldKey),
  ));
}

class App extends StatelessWidget {
  final FtcRepository ftcRepository;
  final GlobalKey<ScaffoldState> scaffoldKey;
  App(this.ftcRepository, this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FTC',
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            BlocProvider.of<AuthenticationBloc>(context).add(AppStarted());
            return SplashScreen();
          } else if (state is AuthenticationAuthenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<HomeBloc>(
                  create: (context) => HomeBloc(ftcRepository: ftcRepository),
                ),
                BlocProvider<PointsBloc>(
                  create: (context) => PointsBloc(ftcRepository: ftcRepository),
                ),
              ],
              child: TabsWidget(
                member: state.member,
                ftcRepository: ftcRepository,
                scaffoldKey: scaffoldKey,
              ),
            );
          } else if (state is AuthenticationUnauthenticated) {
            return SignInPage();
          } else if (state is LoginFailed) {
            return FailureScreen();
          } else {
            return SplashScreen();
          }
        },
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Cairo',
          primaryColor: config.Colors().mainColor(1),
          brightness: Brightness.light,
          accentColor: config.Colors().accentColor(1),
          focusColor: config.Colors().secondColor(1),
          hintColor: config.Colors().accentColor(1),
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10)))),
          textTheme: TextTheme(
            headline: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            subtitle: TextStyle(fontSize: 20, color: Colors.white),
            title: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
            subhead: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400),
          )),
    );
  }
}
