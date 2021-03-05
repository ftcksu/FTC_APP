import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;

class MaxMembersBottomSheet extends StatelessWidget {
  final String numberOfMaxPart;
  final String numberOfPart;
  final Function(String) onPressed;

  MaxMembersBottomSheet({this.numberOfMaxPart, this.onPressed, this.numberOfPart});

  @override
  Widget build(BuildContext context) {
    _maxBottomSheet() {
      String pendingNumber = numberOfMaxPart;
      return showBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          builder: (context) => Container(
                margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                      maxLength: 2,
                      onChanged: (string) => pendingNumber = string,
                      decoration: InputDecoration(
                        hintText: 'كم واحد ودك يشارك؟',
                        hintStyle: TextStyle(
                          color: config.Colors().divider(1),
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                      color: Colors.grey[800],
                      onPressed: () => onPressed(pendingNumber),
                      child: Text(
                        'اعتمد',
                        style: TextStyle(color: Colors.white),
                      ))
                ]),
              ));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => _maxBottomSheet(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(children: <Widget>[
                Text(
                  "الأعضاء المسجلين",
                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
                Expanded(child: Container(),),
                Icon(
                  Icons.edit,
                  color: config.Colors().accentColor(1),
                ),
                Text(
                  numberOfPart + "/" + numberOfMaxPart,
                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: config.Colors().accentColor(1)),
                ),
              ]),
              Divider(thickness: 1, color: config.Colors().accentColor(1)),
            ],
          ),
        ),
      ),
    );
  }
}
