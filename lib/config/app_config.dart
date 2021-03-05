import 'package:flutter/material.dart';

class App {
  BuildContext _context;
  double _height;
  double _width;
  double _heightPadding;
  double _widthPadding;

  App(_context) {
    this._context = _context;
    MediaQueryData _queryData = MediaQuery.of(this._context);
    _height = _queryData.size.height / 100.0;
    _width = _queryData.size.width / 100.0;
    _heightPadding = _height -
        ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding =
        _width - (_queryData.padding.left + _queryData.padding.right) / 100.0;
  }

  double appHeight(double v) {
    return _height * v;
  }

  double appWidth(double v) {
    return _width * v;
  }

  double appVerticalPadding(double v) {
    return _heightPadding * v;
  }

  double appHorizontalPadding(double v) {
    return _widthPadding * v;
  }
}

class Colors {
  Color _mainColor = Color(0x9C27B0);
  Color _secondColor = Color(0xE1BEE7);
  Color _accentColor = Color(0x03A9F4);

  Color _mainDarkColor = Color(0x7B1FA2);
  Color _secondDarkColor = Color(0x03A9F4);
  Color _accentDarkColor = Color(0x03A9F4);

  Color _notWhite = Color(0xFFEDF0F2);
  Color _secondaryText = Color(0x757575);
  Color _divider = Color(0xBDBDBD);
  Color _nearlyBlack = Color(0xFF213333);

  Color nearlyBlack(double opacity) {
    return this._nearlyBlack.withOpacity(opacity);
  }

  Color divider(double opacity) {
    return this._divider.withOpacity(opacity);
  }

  Color secondaryText(double opacity) {
    return this._secondaryText.withOpacity(opacity);
  }

  Color notWhite(double opacity) {
    return this._notWhite.withOpacity(opacity);
  }

  Color mainColor(double opacity) {
    return this._mainColor.withOpacity(opacity);
  }

  Color secondColor(double opacity) {
    return this._secondColor.withOpacity(opacity);
  }

  Color accentColor(double opacity) {
    return this._accentColor.withOpacity(opacity);
  }

  Color mainDarkColor(double opacity) {
    return this._mainDarkColor.withOpacity(opacity);
  }

  Color secondDarkColor(double opacity) {
    return this._secondDarkColor.withOpacity(opacity);
  }

  Color accentDarkColor(double opacity) {
    return this._accentDarkColor.withOpacity(opacity);
  }
}
