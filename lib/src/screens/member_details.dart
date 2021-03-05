import 'package:flutter/material.dart';
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/MemberDetails/member_projects.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs/memberEventsBloc/bloc.dart';

class MemberDetails extends StatefulWidget {
  final BuildContext context;
  final RouteArgument routeArgument;
  Member member;
  Member currentMember;
  String _heroTag;

  MemberDetails({Key key, this.context, this.routeArgument}) {
    member = this.routeArgument.argumentsList[0] as Member;
    _heroTag = this.routeArgument.argumentsList[1] as String;
    currentMember = this.routeArgument.argumentsList[2] as Member;
  }
  @override
  _MemberDetailsState createState() => _MemberDetailsState();
}

class _MemberDetailsState extends State<MemberDetails> {
  List<Event> events;
  bool eventsLoaded = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MemberEventsBloc>(context)
        .add(GetMemberEvents(memberId: widget.member.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberEventsBloc, MemberEventsState>(
      builder: (context, eventState) {
        if (eventState is InitialMemberEventsState) {
          BlocProvider.of<MemberEventsBloc>(context)
              .add(GetMemberEvents(memberId: widget.member.id));
          return _detailsScreen();
        } else if (eventState is MemberEventsLoading) {
          return _detailsScreen();
        } else if (eventState is MemberEventsLoaded) {
          events = eventState.memberEvents;
          eventsLoaded = true;
          return _detailsScreen();
        } else {
          BlocProvider.of<MemberEventsBloc>(context)
              .add(GetMemberEvents(memberId: widget.member.id));
          return _detailsScreen();
        }
      },
    );
  }

  Widget _detailsScreen() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                centerTitle: true,
                title: Text(
                  widget.member.name,
                  style: Theme.of(context).textTheme.subtitle,
                ),
                backgroundColor: Colors.deepPurpleAccent,
                floating: true,
                snap: true,
                leading: IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(widget.context).pop(),
                ),
              )
            ];
          },
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  config.Colors().mainColor(1),
                  config.Colors().accentColor(.8),
                ],
              ),
            ),
            child: ListView(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              '/ProfileImagePreview',
                              arguments: RouteArgument(
                                  id: widget.member.id,
                                  argumentsList: [
                                    false,
                                    widget.member,
                                    widget._heroTag
                                  ])),
                          child: Hero(
                              tag: widget._heroTag + widget.routeArgument.id,
                              child: MemberImage(
                                id: widget.member.id,
                                hasProfileImage: widget.member.hasProfileImage,
                                height: 250,
                                width: 250,
                                thumb: false,
                              )),
                        ),
                      ),
                    )),
                Center(
                  child: Text(
                    widget.member.name,
                    style: Theme.of(context).textTheme.headline,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Center(
                    child: widget.member?.bio != null
                        ? Text(
                            widget.member.bio,
                            style: Theme.of(context).textTheme.subtitle,
                            textAlign: TextAlign.center,
                          )
                        : Text(''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 30),
                        child: GestureDetector(
                          onTap: () =>
                              _onWhatsAppTap(widget.member.phoneNumber),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage('assets/images/whats_app.png'),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 30),
                          child: GestureDetector(
                            onTap: () => _onPhoneTap(widget.member.phoneNumber),
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'المشاريع الي مسجل فيها',
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .merge(TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          color: config.Colors().divider(1),
                          height: 1,
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                eventsLoaded
                    ? MemberProjects(
                        events: events,
                        currentMember: widget.currentMember,
                      )
                    : Center(child: CircularProgressIndicator())
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onPhoneTap(String number) async {
    if (await canLaunch("tel:$number")) {
      await launch("tel:$number");
    } else {
      throw 'Could not launch the number"';
    }
  }

  _onWhatsAppTap(String number) async {
    String whatsAppLink = "https://wa.me/$number";
    if (await canLaunch(whatsAppLink)) {
      await launch(whatsAppLink, forceSafariVC: false);
    } else {
      throw 'Could not launch the number"';
    }
  }
}
