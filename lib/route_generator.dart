import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/screens/AdminScreens/event_jobs_submit_points_screen.dart';
import 'package:ftc_application/src/screens/MemberSpecificScreens/member_image_history.dart';
import 'package:ftc_application/src/screens/MemberSpecificScreens/previous_work_tasks.dart';
import 'package:ftc_application/src/screens/EventSpecificScreens/event_creation_member_selection.dart';
import 'package:ftc_application/src/screens/EventSpecificScreens/event_creation_screen.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/screens/AdminScreens/approve_images.dart';
import 'package:ftc_application/src/screens/AdminScreens/submit_points_anyone.dart';
import 'package:ftc_application/src/screens/AdminScreens/submit_points_anyone_member.dart';
import 'package:ftc_application/src/screens/EventSpecificScreens/event_jobs_screen.dart';
import 'package:ftc_application/src/screens/profile_image_preview.dart';
import 'package:ftc_application/src/screens/signIn_page.dart';
import 'package:ftc_application/src/screens/splash_screen.dart';
import 'package:ftc_application/src/screens/MemberSpecificScreens/member_account_screen.dart';
import 'package:ftc_application/src/screens/member_details.dart';
import 'package:ftc_application/src/screens/EventSpecificScreens/event_details.dart';
import 'package:ftc_application/src/screens/MemberSpecificScreens/previous_work_screen.dart';
import 'package:ftc_application/src/screens/AdminScreens/send_notification_screen.dart';
import 'package:ftc_application/src/screens/AdminScreens/member_tasks_submit_points_screen.dart';
import 'package:ftc_application/src/screens/AdminScreens/events_submit_points_screen.dart';
import 'package:ftc_application/src/screens/MemberSpecificScreens/submit_work_screen.dart';
import 'package:ftc_application/src/screens/EventSpecificScreens/event_management_screen.dart';
import 'package:ftc_application/src/screens/EventSpecificScreens/event_tasks_submit.dart';
import 'package:ftc_application/src/screens/MainScreens/tabs.dart';

import 'blocs/imageApprovalBloc/image_approval_bloc.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => TabsWidget());

      case '/SplashScreen':
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case '/SignIn':
        return MaterialPageRoute(builder: (_) => SignInPage());

      case '/SubmitWork':
        return MaterialPageRoute(builder: (_) => SubmitPointsScreen());

      case '/SendNotifications':
        return MaterialPageRoute(builder: (_) => SendNotificationScreen());

      case '/ApproveImages':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      ImageApprovalBloc(ftcRepository: FtcRepository.instance),
                  child: ApproveImages(),
                ));

      case '/Account':
        return MaterialPageRoute(builder: (_) => MemberAccountScreen());

      case '/WorkRecord':
        return MaterialPageRoute(builder: (_) => PreviousWorkScreen(_));

      case '/SubmitMyWork':
        return MaterialPageRoute(builder: (_) => SubmitWorkScreen());

      case '/MemberDetails':
        return MaterialPageRoute(
            builder: (_) => MemberDetails(
                context: _, routeArgument: args as RouteArgument));

      case '/EventDetails':
        return MaterialPageRoute(
            builder: (_) => EventDetails(routeArgument: args as RouteArgument));

      case '/EventManagement':
        return MaterialPageRoute(builder: (_) => EventManagement());

      case '/EventTasksSubmit':
        return MaterialPageRoute(
            builder: (_) =>
                EventTasksSubmit(routeArgument: args as RouteArgument));

      case '/EventJobsApprovalScreen':
        return MaterialPageRoute(
            builder: (_) =>
                EventJobsApprovalScreen(routeArgument: args as RouteArgument));

      case '/EventJobs':
        return MaterialPageRoute(
            builder: (_) =>
                EventJobsScreen(routeArgument: args as RouteArgument));

      case '/MemberTasks':
        return MaterialPageRoute(
            builder: (_) =>
                SubmitPointsMemberScreen(routeArgument: args as RouteArgument));

      case '/EventCreationScreen':
        return MaterialPageRoute(
            builder: (_) =>
                EventCreationScreen(routeArgument: args as RouteArgument));

      case '/EventMemberSelection':
        return MaterialPageRoute(
            builder: (_) =>
                EventMemberSelection(routeArgument: args as RouteArgument),
            fullscreenDialog: true);

      case '/SubmitPointsAnyone':
        return MaterialPageRoute(builder: (_) => SubmitPointsAnyone());

      case '/MemberImageHistory':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) =>
                    ImageApprovalBloc(ftcRepository: FtcRepository.instance),
                child: MemberImageHistory()));

      case '/ProfileImagePreview':
        return MaterialPageRoute(
            builder: (_) =>
                ProfileImagePreview(routeArgument: args as RouteArgument));

      case '/SubmitPointsAnyoneMemberScreen':
        return MaterialPageRoute(
            builder: (_) => SubmitPointsAnyoneMemberScreen(
                routeArgument: args as RouteArgument));
      case '/PreviousWorkTasksScreen':
        return MaterialPageRoute(
            builder: (_) =>
                PreviousWorkTasks(routeArgument: args as RouteArgument));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
