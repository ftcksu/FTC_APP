import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/route_argument.dart';
import 'package:ftc_application/src/widgets/EventWidgets/EventCreation/member_selection_list_item.dart';
import 'package:ftc_application/src/widgets/EventWidgets/EventCreation/member_selection_horz_list_item.dart';
import 'package:ftc_application/src/widgets/SerchBar/searchbar_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EventMemberSelection extends StatefulWidget {
  final RouteArgument routeArgument;
  Member currentMember;
  List<Member> members;
  int maxUsers;
  List<Member> _selectedMembers = [];

  //use this when cancelling the selection
  List<Member> initialMembers = [];

  EventMemberSelection({this.routeArgument}) {
    currentMember = routeArgument.argumentsList[0] as Member;
    maxUsers = routeArgument.argumentsList[1] as int;
    members = routeArgument.argumentsList[2] as List<Member>;
    _selectedMembers =
        new List<Member>.from(routeArgument.argumentsList[3] as List<Member>);
    if (_selectedMembers == null) _selectedMembers = [];
    //clone the selected members list
    initialMembers = new List<Member>.from(_selectedMembers);
  }

  @override
  _EventMemberSelectionState createState() =>
      _EventMemberSelectionState(_selectedMembers);
}

class _EventMemberSelectionState extends State<EventMemberSelection> {
  List<Member> _newData;

  List<Member> selectedMembers;

  _EventMemberSelectionState(this.selectedMembers);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Alert(
          closeFunction: () {},
          context: context,
          title: 'نحفظ التفييرات؟',
          buttons: [
            DialogButton(
              child: Text(
                "اي",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, selectedMembers);
              },
            ),
            DialogButton(
              child: Text(
                "لا",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, widget.initialMembers);
              },
            )
          ],
        ).show();
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Container(
            color: config.Colors().notWhite(1),
            child: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                leading: GestureDetector(
                    onTap: () => Navigator.pop(context, widget.initialMembers),
                    child: Icon(Icons.keyboard_backspace)),
                actions: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, selectedMembers),
                      child: Icon(
                        Icons.check,
                      ),
                    ),
                  )
                ],
                floating: true,
                backgroundColor: Colors.deepPurpleAccent,
                centerTitle: true,
                elevation: 8,
                title: Text(
                  'اختر الاعضاء',
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      SearchBar(onChanged: _onChanged),
                    ],
                  );
                }, childCount: 1),
              ),
              _memberSelectionHorizontalList(),
              _memberSelectionList()
            ]),
          ),
        ),
      ),
    );
  }

  Widget _memberSelectionHorizontalList() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          curve: Curves.ease,
          height: selectedMembers.length > 1 ? 50.0 : 0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10, // selectedMembers.length,
            itemBuilder: (context, index) {
              //this is temp
              if (index >= selectedMembers.length) return Container();
              if (selectedMembers[index].id == widget.currentMember.id)
                return Container();
              return MemberSelectionHorzListItem(
                  selectedMembers[index], _unCheck);
            },
          ),
        ),
      ),
    );
  }

  Widget _memberSelectionList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          Member m = _newData != null && _newData.length != 0
              ? _newData[index]
              : widget.members[index];
          bool startChosen = selectedMembers.contains(m);
          return MemberSelectionListItem(
            index: index,
            member: m,
            onCheck: _onCheck,
            unCheck: _unCheck,
            startChosen: startChosen,
          );
        },
        childCount: _newData != null && _newData.length != 0
            ? _newData.length
            : widget.members.length,
      ),
    );
  }

  bool _onCheck(Member member) {
    if (selectedMembers.length >= widget.maxUsers) {
      Alert(
        context: context,
        title: 'وصلت ماكس عدد الاعضاء',
        buttons: [
          DialogButton(
            child: Text(
              "اسف",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
      return false;
    } else if (selectedMembers
        .any((selectedMember) => selectedMember.id == member.id)) {
      Alert(
        context: context,
        title: 'العضو مشارك الريدي',
        buttons: [
          DialogButton(
            child: Text(
              "اسف",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
      return false;
    } else {
      setState(() {
        selectedMembers.add(member);
      });
      return true;
    }
  }

  _unCheck(Member member) {
    setState(() {
      selectedMembers.remove(member);
    });
  }

  _onChanged(String value) {
    setState(() {
      _newData = widget.members
          .where((member) =>
              member.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
}
