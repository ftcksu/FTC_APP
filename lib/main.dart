import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';
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
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseNotifications firebaseNotifications =
      FirebaseNotifications(scaffoldKey: scaffoldKey);

  final FtcRepository ftcRepository = FtcRepository(
      ftcApiClient: FtcApiClient(firebaseMessaging: firebaseNotifications));

  getIt.registerSingleton<UserRepo>(UserRepo(ftcRepository: ftcRepository),
      signalsReady: true);

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
      create: (context) => AuthenticationBloc(
          userRepo: getIt<UserRepo>(), ftcRepository: ftcRepository)
        ..add(AppStarted()),
    ),
    BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
            userRepository: getIt<UserRepo>(),
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
                    create: (context) =>
                        PointsBloc(ftcRepository: ftcRepository),
                  ),
                ],
                child: TabsWidget(
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
            headline1: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            headline2: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
            subtitle1: TextStyle(fontSize: 20, color: Colors.white),
            subtitle2: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: config.Colors().accentColor(1),
            ),
          ),
        ));
  }
}
