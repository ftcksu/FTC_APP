import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;
import 'package:ftc_application/config/ui_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SelfSubmitCard extends StatelessWidget {
  final Function submitSelf;
  late final AnimationController animationController;
  late final Animation<double> animation;
  final bool noAnim;

  SelfSubmitCard(
      {required this.submitSelf,
      required this.animation,
      required this.animationController,
      this.noAnim = false});

  SelfSubmitCard.noAnim({
    required this.submitSelf,
    required this.noAnim,
  });

  @override
  Widget build(BuildContext context) {
    String _input = "";
    _onSubmit() {
      if (_input.length < 5) {
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
          title: 'شكرا',
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

    _submitWorkBottomSheet() {
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          style: Theme.of(context).textTheme.subtitle2,
                          autofocus: true,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          keyboardType: TextInputType.text,
                          maxLength: null,
                          maxLines: null,
                          onChanged: (string) => _input = string,
                          onSubmitted: (e) => _onSubmit(),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              UiIcons.chat,
                              color: Theme.of(context).accentColor,
                            ),
                            hintText: 'وش سويت',
                            hintStyle: TextStyle(
                              color: config.Colors().divider(1),
                            ),
                          ),
                        ),
                      ),
                      MaterialButton(
                          color: Colors.grey[800],
                          onPressed: _onSubmit,
                          child: Text(
                            'أرصد',
                            style: TextStyle(color: Colors.white),
                          ))
                    ]),
              )).closed.then((value) {
        if (_input.length > 5) {
          submitSelf(_input);
        }
      });
    }

    Widget _animatedSelf() {
      return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 50 * (1.0 - animation.value), 0.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 8.0,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'اعمالك',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Divider(
                            color: config.Colors().divider(1),
                            height: 0,
                            thickness: 1,
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: config.Colors().accentColor(1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              padding: EdgeInsets.all(8.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'أرصد لنفسك',
                                  style: new TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            onPressed: () => _submitWorkBottomSheet()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    Widget _self() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 8.0,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  'اعمالك',
                  style: Theme.of(context).textTheme.headline2,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    color: config.Colors().divider(1),
                    height: 0,
                    thickness: 1,
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: config.Colors().accentColor(1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      padding: EdgeInsets.all(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'أرصد لنفسك',
                          style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () => _submitWorkBottomSheet()),
              ],
            ),
          ),
        ),
      );
    }

    return noAnim ? _self() : _animatedSelf();
  }
}
