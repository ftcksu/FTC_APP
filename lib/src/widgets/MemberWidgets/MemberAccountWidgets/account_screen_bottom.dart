import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftc_application/blocs/memberBloc/bloc.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/config/ui_icons.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AccountScreenBottom extends StatelessWidget {
  final Member member;
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _newPassFocusNode = FocusNode();

  AccountScreenBottom({this.member}) : assert(member != null);

  @override
  Widget build(BuildContext context) {
    String _wisdom = "";
    String _wisdomForAll = "";
    String _password = "";
    String _passwordConfirmation = "";
    bool passAccept = false;

    _onPasswordChange() {
      if (_password.trim() != _passwordConfirmation.trim() ||
          _password.isEmpty) {
        Alert(
          context: context,
          title: 'الباسوردات ماتتشابه/فازيه ياحلو',
          buttons: [
            DialogButton(
              child: Text(
                "اسف فيصل",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ).show();
      } else {
        Alert(
          context: context,
          title: 'تم التغير صانكيو',
          buttons: [
            DialogButton(
              child: Text(
                "عفوا",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                passAccept = true;
                Navigator.pop(context);
              },
            )
          ],
        ).show().then((onValue) {
          if (passAccept) {
            Map<String, String> payload = {"password": _password.trim()};
            BlocProvider.of<MemberBloc>(context).add(
              UpdateMember(payload: payload),
            );
            passAccept = false;
          }
        });
      }
    }

    _passwordChangeSheet() {
      return showBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        builder: (context) => Container(
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  obscureText: true,
                  autofocus: true,
                  focusNode: _passFocusNode,
                  maxLength: 25,
                  style: Theme.of(context).textTheme.subhead,
                  keyboardType: TextInputType.text,
                  onChanged: (string) => _password = string,
                  onSubmitted: (e) {
                    _passFocusNode.unfocus();
                    _newPassFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    hintText: 'كلمة المرور',
                    hintStyle: TextStyle(
                      color: config.Colors().divider(1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Theme.of(context).accentColor.withOpacity(0.2),
                    )),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                    prefixIcon: Icon(
                      UiIcons.padlock_1,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  focusNode: _newPassFocusNode,
                  obscureText: true,
                  maxLength: 25,
                  onChanged: (string) => _passwordConfirmation = string,
                  onSubmitted: (e) {
                    _newPassFocusNode.unfocus();
                    _onPasswordChange();
                  },
                  style: Theme.of(context).textTheme.subhead,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'تاكيد كلمة المرور',
                    hintStyle: TextStyle(
                      color: config.Colors().divider(1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Theme.of(context).accentColor.withOpacity(0.2),
                    )),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                    prefixIcon: Icon(
                      UiIcons.padlock_1,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
              MaterialButton(
                color: Colors.grey[800],
                onPressed: () => _onPasswordChange(),
                child: Text(
                  'غير',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      );
    }

    _onWisdom() {
      Alert(
        context: context,
        title: 'شكرا للفلسفه',
        buttons: [
          DialogButton(
            child: Text(
              "عفوا",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show().then((onValue) {
        Navigator.pop(context);
      });
    }

    _wisdomBottomSheet() {
      return showBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        builder: (context) => Container(
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  autofocus: true,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  keyboardType: TextInputType.text,
                  maxLength: 45,
                  maxLines: 1,
                  onChanged: (string) => _wisdom = string,
                  onSubmitted: (e) => _onWisdom(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      UiIcons.chat,
                      color: Theme.of(context).accentColor,
                    ),
                    hintText: 'تفلسف',
                    hintStyle: TextStyle(
                      color: config.Colors().divider(1),
                    ),
                  ),
                ),
              ),
              MaterialButton(
                color: Colors.grey[800],
                onPressed: _onWisdom,
                child: Text(
                  'تفلسف',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ).closed.then((value) {
        if (_wisdom.trim().isNotEmpty) {
          Map<String, dynamic> payload = {"bio": _wisdom.trim()};
          BlocProvider.of<MemberBloc>(context).add(
            UpdateMember(payload: payload),
          );
        }
      });
    }

    _onWisdomForAll() {
      if (_wisdomForAll.length < 5) {
        Alert(
          context: context,
          title: 'اكتب اكثر من كم حرف لوسمحت',
          buttons: [
            DialogButton(
              child: Text(
                "اسف فيصل",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ).show();
      } else {
        Alert(
          context: context,
          title: 'شكرا للفلسفه',
          buttons: [
            DialogButton(
              child: Text(
                "عفوا",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ).show().then((onValue) {
          Navigator.pop(context);
        });
      }
    }

    _wisdomForAllBottomSheet() {
      return showBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        builder: (context) => Container(
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    autofocus: true,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.text,
                    maxLength: 65,
                    maxLines: null,
                    onChanged: (string) => _wisdomForAll = string,
                    onSubmitted: (e) => _onWisdomForAll(),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        UiIcons.chat,
                        color: Theme.of(context).accentColor,
                      ),
                      hintText: 'تفلسف',
                      hintStyle: TextStyle(
                        color: config.Colors().divider(1),
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  color: Colors.grey[800],
                  onPressed: _onWisdomForAll,
                  child: Text(
                    'تفلسف',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ]),
        ),
      ).closed.then((value) {
        if (_wisdomForAll.length > 5) {
          Map<String, dynamic> payload = {
            "message": _wisdomForAll,
            "user": {"id": member.id}
          };
          BlocProvider.of<MemberBloc>(context).add(
            ChangeMOTD(payload: payload),
          );
        }
      });
    }

    Widget password() {
      return GestureDetector(
        onTap: () => _passwordChangeSheet(),
        child: ListTile(
          leading: Icon(
            Icons.lock,
            color: Colors.white,
            size: 28,
          ),
          title: Text(
            "تغير كلمة السر",
            style: Theme.of(context).textTheme.title.merge(
                  TextStyle(color: Colors.white),
                ),
          ),
          subtitle: Text('موب عاجبتك كلمة سرك؟ غيرها',
              style: Theme.of(context).textTheme.subtitle.merge(
                    TextStyle(fontSize: 14),
                  )),
          trailing: Icon(Icons.edit, color: Colors.white),
        ),
      );
    }

    Widget wisdom() {
      return GestureDetector(
        onTap: () => _wisdomBottomSheet(),
        child: ListTile(
          leading: Icon(
            Icons.child_care,
            color: Colors.white,
            size: 28,
          ),
          title: Text(
            "فلسفتك",
            style: Theme.of(context).textTheme.title.merge(
                  TextStyle(color: Colors.white),
                ),
          ),
          subtitle: Text(
            'وش ودك تفيد الناس فيه اليوم؟',
            style: Theme.of(context).textTheme.subtitle.merge(
                  TextStyle(fontSize: 14),
                ),
          ),
          trailing: Icon(Icons.edit, color: Colors.white),
        ),
      );
    }

    Widget wisdomForAll() {
      return GestureDetector(
        onTap: () => _wisdomForAllBottomSheet(),
        child: ListTile(
          leading: Icon(
            Icons.child_friendly,
            color: Colors.white,
            size: 28,
          ),
          title: Text(
            "كلام مايهمك",
            style: Theme.of(context).textTheme.title.merge(
                  TextStyle(color: Colors.white),
                ),
          ),
          subtitle: Text('وش ودك تفيد الكل فيه اليوم؟',
              style: Theme.of(context).textTheme.subtitle.merge(
                    TextStyle(fontSize: 14),
                  )),
          trailing: Icon(Icons.edit, color: Colors.white),
        ),
      );
    }

    Widget imageHistory() {
      return GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/MemberImageHistory'),
        child: ListTile(
          leading: Icon(
            Icons.image,
            color: Colors.white,
            size: 28,
          ),
          title: Text(
            "صورك الحلوه",
            style: Theme.of(context).textTheme.title.merge(
                  TextStyle(color: Colors.white),
                ),
          ),
          subtitle: Text('رجع وحده من صورك المولعه',
              style: Theme.of(context).textTheme.subtitle.merge(
                    TextStyle(fontSize: 14),
                  )),
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: password(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: wisdom(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: wisdomForAll(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: imageHistory(),
        )
      ],
    );
  }
}
