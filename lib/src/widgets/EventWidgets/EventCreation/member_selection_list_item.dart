import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';

class MemberSelectionListItem extends StatefulWidget {
  final Member member;
  final int index;
  final Function onCheck;
  final Function unCheck;
  final bool startChosen;

  MemberSelectionListItem(
      {required this.member,
      required this.index,
      required this.onCheck,
      required this.unCheck,
      required this.startChosen});

  @override
  _MemberSelectionListItemState createState() =>
      _MemberSelectionListItemState();
}

class _MemberSelectionListItemState extends State<MemberSelectionListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController = AnimationController(
      vsync: this,
      value: 0,
      upperBound: 1,
      duration: Duration(milliseconds: 250));
  late Animation<double> _colorFadeAnim =
      Tween<double>(begin: 1.0, end: 0.5).animate(_animationController);

  @override
  void didUpdateWidget(MemberSelectionListItem oldWidget) {
    if (oldWidget.startChosen != widget.startChosen) {
      if (!widget.startChosen) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.startChosen) {
          _animationController.reverse();
          widget.unCheck(widget.member);
        } else {
          _animationController.forward();
          widget.onCheck(widget.member);
        }
      },
      child: FadeTransition(
        opacity: _colorFadeAnim,
        child: Container(
            color: widget.index.isEven
                ? config.Colors().notWhite(1)
                : Colors.white,
            child: ListTile(
              title: Text(widget.member.name,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .merge(TextStyle(fontSize: 18))),
              leading: Container(
                width: 45,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: MemberImage(
                        id: widget.member.id,
                        hasProfileImage: widget.member.hasProfileImage,
                        height: 45,
                        width: 45,
                        thumb: true,
                      ),
                    ),
                    Center(
                      child: FadeTransition(
                        opacity: _animationController,
                        child: Icon(
                          Icons.check,
                          size: 45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
