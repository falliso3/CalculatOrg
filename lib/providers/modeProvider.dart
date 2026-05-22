import 'package:flutter/material.dart';

enum CalcMode {
  standard,
  scientific,
  programmer,
  unitConverter,
  currencyConverter,
}

//Maps each mode to a display name and icon
const Map<CalcMode, (String, IconData)> calcModeInfo = {
  CalcMode.standard: ('Standard', Icons.calculate_outlined),
  CalcMode.scientific: ('Scientific', Icons.science_outlined),
  CalcMode.programmer: ('Programmer', Icons.code),
  CalcMode.unitConverter: ('Unit Converter', Icons.straighten_outlined),
  CalcMode.currencyConverter: ('Currency', Icons.currency_exchange_outlined),
};

class ModeProvider extends ChangeNotifier {
  CalcMode _mode = CalcMode.standard;

  CalcMode get mode => _mode;

  void setMode(CalcMode mode) {
    _mode = mode;
    notifyListeners();
  }
}
