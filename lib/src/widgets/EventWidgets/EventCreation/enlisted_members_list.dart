import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';

class EnlistedMembersList extends StatelessWidget {
  final List<Member> selectedMembers;
  final Member currentMember;
  final Function deleteMember;

  EnlistedMembersList(
      {this.selectedMembers, this.currentMember, this.deleteMember});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: selectedMembers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0)
          return ListTile(
            leading: MemberImage(
              id: currentMember.id,
              hasProfileImage: currentMember.hasProfileImage,
              height: 45,
              width: 45,
              thumb: true,
            ),
            title: Text(
              currentMember.name,
              style: TextStyle(fontSize: 18),
            ),
          );
        if (currentMember.id == selectedMembers[index - 1].id)
          return Container();
        return ListTile(
          leading: MemberImage(
            id: selectedMembers[index - 1].id,
            hasProfileImage: selectedMembers[index - 1].hasProfileImage,
            height: 45,
            width: 45,
            thumb: true,
          ),
          title: Text(
            selectedMembers[index - 1].name,
            style: TextStyle(fontSize: 18),
          ),
          trailing: InkWell(
            borderRadius: BorderRadius.circular(45),
            onTap: () => deleteMember(selectedMembers[index - 1].id, index - 1),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.clear,
                color: Colors.red,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: config.Colors().divider(1),
        height: 0,
        thickness: 1,
      ),
    );
  }
}
