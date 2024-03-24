import 'dart:convert';

import 'package:nyxx/nyxx.dart';

import 'beammp.dart';
import "global.dart";

Future<void> commandsInit(ApplicationCommandInteraction interaction) async {

}



Future<void> commandsStart(ApplicationCommandInteraction interaction, BeamMP beammp) async {
  await interaction.acknowledge();
  // from message
  if(interaction.message != null) { //todo find out why message always null
    final attachment = await interaction.message?.attachments.firstOrNull?.fetch();
    if(attachment != null) {
      final maped = json.decode(String.fromCharCodes(attachment));
      config = maped;
    }
  } 
  // from command
  else {

  }


  //* Start
  await beammp.start();

  //TODO chat
  // _gameChat(interaction, beammp, chatChannel.first);

  await interaction.respond(MessageBuilder(content: "Server Started"));
}

Future<void> commandsStop(ApplicationCommandInteraction interaction, BeamMP beammp) async {

  //* Stop
  await beammp.exit();
  await interaction.respond(MessageBuilder(content: "Server stopped", attachments: [
    AttachmentBuilder(data: json.encode(config).codeUnits, fileName: "config.json")
  ]));
}



void _gameChat(Interaction interaction, BeamMP beammp, GuildTextChannel chatChannel) {
  
}