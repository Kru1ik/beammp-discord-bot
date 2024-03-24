import 'dart:io';

void main() {
  getBeamNGLevels();
}

void  getBeamNGLevels() {
  var files = Directory(r"E:\SteamLibrary\steamapps\common\BeamNG.drive\content\levels").listSync();
  for(var file in files) {
    print(file.path.split(r"\").last);
  }
}