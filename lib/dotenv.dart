import 'dart:io';

//* DotEnv
final dotEnv = DotEnv()..refresh();
class DotEnv {
  final Map<String, String> _env = {};
  void refresh() {
    if(!File('.env').existsSync()) {
      print("Cannot read .env file");
      return;
    }
    for(var element in File('.env').readAsLinesSync()) {
      if(!element.startsWith("#") && element.isNotEmpty) {
        final splited = element.split('=');
        var value = splited.sublist(1).join("=");
        if((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
          value = value.substring(1, value.length-1);
        }
        _env[splited[0].trim()] = value;
      }
    }
  }
  String? operator [](String key) => Platform.environment[key] ?? _env[key];
}







/// Command Line Colors
/// 
///## DON'T FORGET [reset] ON THE END OF TEXT!!!
abstract class CLC {
  static const reset = "\x1b[0m";

  static const bright = "\x1b[1m";
  static const dim = "\x1b[2m";
  static const underscore = "\x1b[4m";
  static const blink = "\x1b[5m";
  static const reverse = "\x1b[7m";
  static const hidden = "\x1b[8m";

  static const black = "\x1b[30m";
  static const red = "\x1b[31m";
  static const green = "\x1b[32m";
  static const yellow = "\x1b[33m";
  static const blue = "\x1b[34m";
  static const magenta = "\x1b[35m";
  static const cyan = "\x1b[36m";
  static const white = "\x1b[37m";

  static const bgBlack = "\x1b[40m";
  static const bgRed = "\x1b[41m";
  static const bgGreen = "\x1b[42m";
  static const bgYellow = "\x1b[43m";
  static const bgBlue = "\x1b[44m";
  static const bgMagenta = "\x1b[45m";
  static const bgCyan = "\x1b[46m";
  static const bgWhite = "\x1b[47m";

  /// ## Color index
  /// https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg
  /// ### Text
  /// ```dart
  /// for (var i = 0; i < 256; ++i) print("\x1b[38;5;${i}mhello\x1b[0m");
  /// ```
  /// ### Backround
  /// ```dart
  /// for (var i = 0; i < 256; ++i) print("\x1b[48;5;${i}mhello\x1b[0m");
  /// ```
  static String colorIndex(String text, {int? textColor, int? backgroundColor}) {
    if(backgroundColor != null && 0 <= backgroundColor && backgroundColor < 256) text = "`\x1b[38;5;${backgroundColor}m$text";
    if(textColor != null && 0 <= textColor && textColor < 256) text = "`\x1b[38;5;${textColor}m$text";
    return text;
  }
}