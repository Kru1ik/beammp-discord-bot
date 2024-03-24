import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '/dotenv.dart';
import 'global.dart';

class BeamMP {
  Process? proc;
  Stream<String>? stdout;
  Stream<String>? stderr;

  StreamSubscription<String>? _printout;
  StreamSubscription<String>? _printerr;

  /// start server, if already running at first stop it
  Future<Process> start() async {
    var authKey = dotEnv["AUTHKEY"];
    if(authKey == null) {
      throw "AUTHKEY not set";
    }

    if(proc != null) await exit();

    var sc = config["ServerConfig"] as Map<String, dynamic>?;

    var confFile = File("./ServerConfig.toml")..createSync(recursive: true);
    confFile.writeAsStringSync(serverConfig(authKey, sc));

    try {
      proc = await Process.start("./BeamMP-Server", []);
    } on Error {// todo xd, coś z tymzrobić
      throw ArgumentError("Server file not found");
    }
    stdout = proc?.stdout.transform(utf8.decoder);
    stderr = proc?.stderr.transform(utf8.decoder);

    _printout = stdout?.listen((event) {print(event);});
    _printerr = stderr?.listen((event) {print(event);});


    return proc!;
  }

  Future<void> exit() async {
    if(proc == null) return;
    proc!.kill();

    _printout?.cancel();
    _printerr?.cancel();
  }
}










String serverConfig(String authKey, Map<String, dynamic>? sc) {
  return '''
# This is the BeamMP-Server config file.
# Help & Documentation: `https://wiki.beammp.com/en/home/server-maintenance`
# IMPORTANT: Fill in the AuthKey with the key you got from `https://keymaster.beammp.com/` on the left under "Keys"

[General]
Name = "BeamMP Server"
Port = 30814
# AuthKey has to be filled out in order to run the server
AuthKey = "$authKey"
# Whether to log chat messages in the console / log
LogChat = true
# Add custom identifying tags to your server to make it easier to find. Format should be TagA,TagB,TagC. Note the comma seperation.
Tags = "Freeroam"
Debug = false
Private = true
MaxCars = ${sc?["MaxCars"] ?? 10}
MaxPlayers = ${sc?["MaxPlayers"] ?? 8}
Map = "/levels/${sc?["Map"] ?? "gridmap_v2"}/info.json"
Description = "BeamMP Default Description"
ResourceFolder = "Resources"

[Misc]
# Hides the periodic update message which notifies you of a new server version. You should really keep this on and always update as soon as possible. For more information visit https://wiki.beammp.com/en/home/server-maintenance#updating-the-server. An update message will always appear at startup regardless.
ImScaredOfUpdates = false
# You can turn on/off the SendErrors message you get on startup here
SendErrorsShowMessage = true
# If SendErrors is `true`, the server will send helpful info about crashes and other issues back to the BeamMP developers. This info may include your config, who is on your server at the time of the error, and similar general information. This kind of data is vital in helping us diagnose and fix issues faster. This has no impact on server performance. You can opt-out of this system by setting this to `false`
SendErrors = true
''';
}