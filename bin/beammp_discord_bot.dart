import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:beammp_discord_bot/dotenv.dart';
import 'package:beammp_discord_bot/src/beammp_config/map.dart';
import 'package:beammp_discord_bot/src/global.dart';
import 'package:beammp_discord_bot/src/start_stop.dart';
import 'package:nyxx/nyxx.dart';

import 'package:beammp_discord_bot/beammp_discord_bot.dart';






void main(List<String> arguments) async {
  var token = dotEnv["TOKEN"];

  if(token == null) {
    print("TOKEN not found");
    exit(0);
  }

  var bot = await Nyxx.connectGateway(token, GatewayIntents.allUnprivileged, options: GatewayClientOptions(
    plugins: [logging, cliIntegration, ignoreExceptions]
  ));

  var beammp = BeamMP();
  

  final registeredCommands = await bot.commands.bulkOverride([
    ApplicationCommandBuilder(name: "init", type: ApplicationCommandType.chatInput, description: "Generate initial config.json"),
    //todo start using command with attachment
    ApplicationCommandBuilder(name: "start", type: ApplicationCommandType.message),
    ApplicationCommandBuilder(name: "stop", type: ApplicationCommandType.chatInput, description: "Stop server and generate config.json"),
    ApplicationCommandBuilder(name: "config", type: ApplicationCommandType.chatInput, description: "Configure bot and BeamMP server", options: [
      //* Bot config
      CommandOptionBuilder.subCommandGroup(name: "bot", description: "Bot configuration options", options: [
        //todo select game chat channel
        //todo select log channel
        //todo select allowed roles but idk how to recover after host restart
      ]),
      //* BeamMP config
      CommandOptionBuilder.subCommandGroup(name: "beammp", description: "BeamMP configuraiton options", options: [
        CommandOptionBuilder.subCommand(name: "maxcars", description: "How many cars player can spawn", options: [
          CommandOptionBuilder.integer(name: "value", description: "default 10")
        ]),
        CommandOptionBuilder.subCommand(name: "maxplayers", description: "How many players can join server", options: [
          CommandOptionBuilder.integer(name: "value", description: "default 8")
        ]),
        CommandOptionBuilder.subCommand(name: "map", description: "Which map to use", options: [
          CommandOptionBuilder.string(name: "value", description: "gridmap_v2", hasAutocomplete: true)
        ]),
      ])
    ])
  ]);
  bot.onApplicationCommandInteraction.listen((event) async {
    switch(event.interaction.data.name) {
      case "setup":
        await permCheck(() async => await commandsInit(event.interaction), event.interaction);
      case "start":
        await permCheck(() async => await commandsStart(event.interaction, beammp), event.interaction);
        break;
      case "stop":
        await permCheck(() async => await commandsStop(event.interaction, beammp), event.interaction);
        break;
      case "config":
        await permCheck(() async {
          for(var goption in event.interaction.data.options ?? <InteractionOption>[]) {
            // subcommand group
            switch (goption.name) {
              case "bot":
                for(var option in goption.options ?? <InteractionOption>[]) {
                  // subcommand
                  switch (option.name) {
                    //? bot opotions
                  }
                }
                break;
              case "beammp":
                for(var option in goption.options ?? <InteractionOption>[]) {
                  // subcommand
                  switch (option.name) {
                    case "maxcars":
                      //todo max cars
                      break;
                    case "maxplayers":
                      //todo max player
                      break;
                    case "map":
                      await commandsMap(event.interaction, option, beammp);
                      break;
                  }
                }
                break;
            }
          }
        }, event.interaction);
        break;
    }
  });


  bot.onMessageComponentInteraction.listen((event) async {
    switch(event.interaction.data.customId) {
      case "restart":
        await restartEvent(event.interaction, beammp);
        break;
    }
  });

  bot.onApplicationCommandAutocompleteInteraction.listen((event) async {
    switch(event.interaction.data.name) {
      case "config":
        for(var goption in event.interaction.data.options ?? <InteractionOption>[]) {
            // subcommand group
            switch (goption.name) {
              case "beammp":
                for(var option in goption.options ?? <InteractionOption>[]) {
                  switch (option.name) {
                    case "map":
                      autocompleteMap(event.interaction, option);
                      break;
                  }
                }
                break;
            }
        }
      break;
    }
  });
}
