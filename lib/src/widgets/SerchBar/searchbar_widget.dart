import 'package:flutter/material.dart';
import 'package:ftc_application/config/app_config.dart' as config;

class SearchBar extends StatelessWidget {
  final Function onChanged;

  SearchBar({this.onChanged}) : assert(onChanged != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    onChanged: (String txt) {
                      onChanged(txt);
                    },
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: config.Colors().mainColor(1),
                    decoration: InputDecoration(
                      prefixIcon: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                              Icons.search,
                              size: 20,
                              color: config.Colors().accentColor(1),
                            ),
                          ),
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: "اكتب اسم العضو",
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
