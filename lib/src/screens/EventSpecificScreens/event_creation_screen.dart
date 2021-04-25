import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:ftc_application/blocs/eventsBloc/bloc.dart';
import 'package:ftc_application/blocs/memberBloc/bloc.dart';
import 'package:ftc_application/blocs/memberEventsBloc/bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/config/ui_icons.dart';
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/EventWidgets/EventCreation/enlisted_members_list.dart';
import 'package:ftc_application/src/widgets/EventWidgets/EventCreation/max_part_widget.dart';
import 'package:ftc_application/src/widgets/loading_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EventCreationScreen extends StatefulWidget {
  final RouteArgument routeArgument;

  EventCreationScreen({this.routeArgument});

  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  String eventName, eventDescription, whatsAppLink, locationLink;
  int numberOfMaxParticipants;
  DateTime eventDate;
  bool sendNotification = false;
  List<Member> members, selectedMembers = [];
  Event event;
  bool editing;
  Member currentMember;

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _whatsFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _setRouteArgument();
    _initialDispatch();
    _onPageEnter();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, memberState) {
        if (memberState is InitialMemberState) {
          _initialDispatch();
          return LoadingWidget();
        } else if (memberState is GetEventCreationLoading) {
          return LoadingWidget();
        } else if (memberState is GetEventCreationLoaded) {
          _setMembers(memberState.argument);
          return _eventCreationScreen();
        } else {
          _initialDispatch();
          return LoadingWidget();
        }
      },
    );
  }

  void _initialDispatch() {
    if (editing) {
      BlocProvider.of<MemberBloc>(context)
          .add(GetEventCreation(eventId: event.id));
    } else {
      BlocProvider.of<MemberBloc>(context).add(GetEventCreation());
    }
  }

  Widget _eventCreationScreen() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          centerTitle: true,
          elevation: 8,
          title: Text(
            editing ? 'عدل فعاليتك الحلوه' : 'زبط فعاليتك الحلوه',
          ),
        ),
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
          child: Card(
            margin: EdgeInsets.all(12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: config.Colors().notWhite(1),
            elevation: 8,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 25),
                //EventName
                _easyTextFieldFactory(
                    35,
                    eventName,
                    TextInputType.text,
                    (string) => eventName = string,
                    'وش ناوي تسمي الفعالية؟',
                    _titleFocus,
                    _descriptionFocus),
                //EventDescription
                _easyTextFieldFactory(
                    120,
                    eventDescription,
                    TextInputType.text,
                    (string) => eventDescription = string,
                    'وش وصف الفعالية؟',
                    _descriptionFocus,
                    _whatsFocus),

                //EventWhatsApp
                _easyTextFieldFactory(
                    null,
                    whatsAppLink,
                    TextInputType.url,
                    (string) => whatsAppLink = string,
                    'رابط قروب الواتس؟',
                    _whatsFocus,
                    null,
                    onSubmit: () => _selectDate(context)),

                //EventDate/Location
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          onPressed: () => _selectDate(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  UiIcons.calendar,
                                  color: Colors.white,
                                ),
                              ),
                              Wrap(
                                children: <Widget>[
                                  Text(
                                    eventDate
                                        .toIso8601String()
                                        .split("T")[0]
                                        .replaceAll("-", "."),
                                    style: new TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        flex: 4,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(
                                    UiIcons.map,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "الموقع",
                                  style: new TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            onPressed: () {
                              showPlacePicker();
                            }),
                        flex: 4,
                      )
                    ],
                  ),
                ),

                //members
                MaxMembersBottomSheet(
                    numberOfPart: selectedMembers.length.toString(),
                    numberOfMaxPart: numberOfMaxParticipants.toString(),
                    onPressed: _onMaxPartSubmit),
                EnlistedMembersList(
                  selectedMembers: selectedMembers,
                  currentMember: currentMember,
                  deleteMember: _deleteMember,
                ),

                InkWell(
                  child: ListTile(
                    leading: Container(
                      width: 45,
                      height: 45,
                      child: Icon(
                        Icons.group,
                        color: Colors.white,
                        size: 35,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius:
                              BorderRadius.all(Radius.circular(22.5))),
                    ),
                    title: Text(
                      "عدل المسجلين",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .merge(TextStyle(fontSize: 18)),
                    ),
                  ),
                  onTap: _memberSelection,
                ),
                editing
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CheckboxListTile(
                          title: Text(
                            'تبي ترسل تنبيه للكل؟',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .merge(TextStyle(fontSize: 18)),
                          ),
                          value: sendNotification,
                          onChanged: (bool value) {
                            if (value) {
                              setState(() {
                                sendNotification = value;
                              });
                            } else {
                              setState(() {
                                sendNotification = value;
                              });
                            }
                          },
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: editing && event.finished
                            ? Colors.grey
                            : Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        padding: EdgeInsets.all(16.0),
                      ),
                      child: Text(
                        editing ? 'عدل الفعالية' : 'اضف الفعالية',
                        style: new TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      onPressed: _validateAndSubmitEvent),
                ),
                _returnEventButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _returnEventButton() {
    if (editing && event.finished) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              padding: EdgeInsets.all(16.0),
            ),
            child: Text(
              'رجع الفعالية',
              style: new TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            onPressed: () {
              Alert(
                context: context,
                title: 'متاكد بترجع الفعالية؟',
                desc: 'يمكن احد مارصد اعماله او نسى يرصد الرئيس',
                buttons: [
                  DialogButton(
                    child: Text(
                      "ايه",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      _returnEvent();
                      Navigator.pop(context);
                    },
                  ),
                  DialogButton(
                    child: Text(
                      "اسف لا",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ).show();
            }),
      );
    } else {
      return Container();
    }
  }

  _deleteMember(int memberId, int index) {
    Alert(
      context: context,
      title: 'متأكد بتحذفه؟',
      buttons: [
        DialogButton(
          child: Text(
            "ايه",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            if (editing)
              BlocProvider.of<EventsBloc>(context).add(
                  RemoveMemberFromEvent(eventId: event.id, memberId: memberId));
            setState(() {
              selectedMembers.removeAt(index);
            });
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text(
            "اسف لأ",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ).show();
  }

  void _addEvent() {
    if (editing) {
      Event newEvent = Event(
          title: eventName,
          description: eventDescription,
          whatsAppLink: whatsAppLink,
          maxUsers: numberOfMaxParticipants,
          date: eventDate,
          leader: currentMember,
          location: locationLink);

      BlocProvider.of<EventsBloc>(context).add(
          UpdateEvent(eventId: event.id, payload: newEvent.toJsonNoMembers()));

      BlocProvider.of<EventsBloc>(context).add(
          AddNewMembersToEvent(eventId: event.id, newMembers: selectedMembers));
    } else {
      Event newEvent = Event(
          title: eventName,
          description: eventDescription,
          whatsAppLink: whatsAppLink,
          maxUsers: numberOfMaxParticipants,
          date: eventDate,
          leader: currentMember,
          location: locationLink);

      if (selectedMembers.isEmpty) {
        BlocProvider.of<EventsBloc>(context).add(AddEvent(
            payload: newEvent.toJson(), notification: sendNotification));
      } else {
        BlocProvider.of<EventsBloc>(context).add(AddEventWithMembers(
            payload: newEvent.toJson(),
            members: selectedMembers,
            notification: sendNotification));
      }
    }
  }

  _onPageEnter() {
    if (editing) {
      eventName = event.title;
      eventDescription = event.description;
      whatsAppLink = event.whatsAppLink;
      numberOfMaxParticipants = event.maxUsers;
      eventDate = event.date;
    } else {
      eventName = "";
      eventDescription = "";
      whatsAppLink = "";
      locationLink = "";
      numberOfMaxParticipants = 0;
      eventDate = DateTime.now();
    }
  }

  _memberSelection() async {
    List<Member> newSelectedMembers = await Navigator.of(context).pushNamed(
        "/EventMemberSelection",
        arguments: RouteArgument(argumentsList: [
          currentMember,
          numberOfMaxParticipants,
          members,
          selectedMembers
        ])) as List<Member>;
    if (editing) {
      List<Member> removedMembers = selectedMembers
          .where((element) => !newSelectedMembers.contains(element))
          .toList();
      removedMembers.forEach((element) {
        BlocProvider.of<EventsBloc>(context).add(
            RemoveMemberFromEvent(eventId: event.id, memberId: element.id));
      });
    }
    setState(() {
      selectedMembers = newSelectedMembers;
    });
  }

  _returnEvent() {
    BlocProvider.of<EventsBloc>(context)
        .add(ChangeEventStatus(eventId: event.id, status: false));

    BlocProvider.of<MemberEventsBloc>(context)
        .add(RefreshCurrentMemberEvents());

    Navigator.of(context).pop();
  }

  _setMembers(RouteArgument argument) {
    members = argument.argumentsList[0];
    members.removeWhere((member) => member.id == currentMember.id);
    if (editing) {
      if (selectedMembers == null || selectedMembers.length <= 1)
        selectedMembers = argument.argumentsList[1];
    }
    //is this fishy? yes it never is will or has been 0
    if (numberOfMaxParticipants == 0) {
      numberOfMaxParticipants = members.length;
      selectedMembers = [currentMember];
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: eventDate,
        firstDate: eventDate,
        lastDate: DateTime(2069));
    if (picked != null && picked != eventDate)
      setState(() {
        eventDate = picked;
      });
  }

  _onMaxPartSubmit(String num) {
    int part = 0;
    try {
      part = int.parse(num);
    } on Exception {
      _easyAlert("لا تسوي نفسك هكر مان", context);
      return;
    }
    if (part < selectedMembers.length || part == 0) {
      _easyAlert("ماينفع يكون اقل من الي مشاركين بالفعالية", context);
    } else {
      setState(() {
        numberOfMaxParticipants = part;
      });
      Navigator.pop(context);
    }
  }

  Widget _easyTextFieldFactory(
      int maxLength,
      String initialValue,
      TextInputType keyboardType,
      Function(String) onChanged,
      String hintText,
      FocusNode focusNode,
      FocusNode nextFocusNode,
      {onSubmit}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextFormField(
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .merge(TextStyle(fontSize: 18)),
        maxLength: maxLength,
        initialValue: initialValue,
        maxLines: null,
        keyboardType: keyboardType,
        onChanged: onChanged,
        textInputAction: TextInputAction.next,
        focusNode: focusNode,
        onFieldSubmitted: (value) {
          focusNode.unfocus();
          if (nextFocusNode != null) nextFocusNode.requestFocus();
          if (onSubmit != null) onSubmit();
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyText2,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: config.Colors().accentColor(1))),
        ),
      ),
    );
  }

  Future<bool> _easyAlert(title, context, {extraOnPressed, btnText = "اسف"}) {
    return Alert(
      context: context,
      title: title,
      buttons: [
        DialogButton(
          child: Text(
            btnText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            if (extraOnPressed != null) extraOnPressed();
          },
        ),
      ],
    ).show();
  }

  void _validateAndSubmitEvent() {
    if (editing && event.finished) {
      return null;
    }
    if (eventName.isEmpty || eventDescription.length < 15) {
      _easyAlert("لازم يكون عندك اسم او كثر وصف", context);
    } else if (whatsAppLink.isNotEmpty &&
        !whatsAppLink.contains('chat.whatsapp.com')) {
      _easyAlert("جروب الواتس غلط", context);
    } else {
      _easyAlert(editing ? 'عدلنا الفعالية' : 'اضفنا الفعالية', context,
              btnText: "تمام", extraOnPressed: _addEvent)
          .whenComplete(() => Navigator.pop(context));
    }
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              FlutterConfig.get('GOOGLE_CLOUD_KEY'),
              displayLocation: LatLng(24.723389, 46.619855),
            )));

    result != null
        ? locationLink =
            'https://maps.google.com/?ll=${result.latLng.latitude},${result.latLng.longitude}'
        : locationLink = '';

    print(locationLink);
  }

  _setRouteArgument() {
    editing = widget.routeArgument.argumentsList[0];
    currentMember = widget.routeArgument.argumentsList[1];
    if (editing) {
      event = widget.routeArgument.argumentsList[2];
    }
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _whatsFocus.dispose();
    super.dispose();
  }
}
