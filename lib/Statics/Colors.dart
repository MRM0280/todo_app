import 'package:flutter/material.dart';
import 'package:todo_app/Statics/Statics.dart';

class ColorsStatic {
  static Color profileColor = Colors.blueAccent;

  static Color selectedColor = Colors.blueAccent;
  static Color projectSelectedColor = Colors.blueAccent;

  static Color backgroundColor =
      Statics.theme == 'litght' ? Colors.white : Color(0xff535353);
  static Color titleColor =
      Statics.theme == 'litght' ? Colors.black : Colors.white;
  static Color underTitleColor = Statics.theme == 'litght'
      ? Colors.black.withOpacity(0.5)
      : Colors.white.withOpacity(0.5);
  static Color topPageTitleColor =
      Statics.theme == 'litght' ? Color(0xff737373) : Colors.white;
  static Color textFeildColor =
      Statics.theme == 'litght' ? Color(0xFFADADAD) : Colors.white;
}
