import 'package:flutter/material.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/widgets/MemberWidgets/member_image.dart';

class MemberSelectionHorzListItem extends StatefulWidget {
  final Member member;
  final Function uncheck;
  const MemberSelectionHorzListItem(this.member, this.uncheck, {Key key}) : super(key: key);

  @override
  _MemberSelectionHorzListItemState createState() => _MemberSelectionHorzListItemState();
}

class _MemberSelectionHorzListItemState extends State<MemberSelectionHorzListItem> with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  Animation<double> _anim;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 150));
    _anim = Tween<double>(begin:0.0,end:1.0).animate(_animationController);
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () => widget.uncheck(widget.member),
        child: AnimatedBuilder(
          animation: _anim,
          builder: (context, child) => Padding(
            padding: EdgeInsets.all((45 - _anim.value * 45)/2),
            child: Stack(
              children: <Widget>[
                Center(
                  child: MemberImage(
                    id: widget.member.id,
                    hasProfileImage: widget.member.hasProfileImage,
                    height: _anim.value * 45,
                    width: _anim.value * 45,
                    thumb: false,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
