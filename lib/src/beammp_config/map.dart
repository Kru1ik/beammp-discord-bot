import 'package:beammp_discord_bot/src/global.dart';

import '../beammp.dart';
import 'package:nyxx/nyxx.dart';

Future<void> autocompleteMap(ApplicationCommandAutocompleteInteraction interaction, InteractionOption option) async {
  var options = [
    "automation_test_track",
    "autotest",
    "Cliff",
    "derby",
    "driver_training",
    "east_coast_usa",
    "garage_v2",
    "glow_city",
    "GridMap",
    "gridmap_v2",
    "hirochi_raceway",
    "Industrial",
    "italy",
    "johnson_valley",
    "jungle_rock_island",
    "showroom_v2",
    "smallgrid",
    "small_island",
    "template",
    "template_tech",
    "Utah",
    "west_coast_usa",
  ];

  await interaction.respond([
    for(var map in options) if(map.contains(option.options?.first.value ?? "")) CommandOptionChoiceBuilder(name: map, value: map)
  ]);
}

Future<void> commandsMap(ApplicationCommandInteraction interaction, InteractionOption option, BeamMP beammp) async {
  if(beammp.proc != null) {
    config["ServerConfig"]??= <String, dynamic>{};
    config["ServerConfig"]["Map"] = option.options!.first.value;
    await interaction.respond(MessageBuilder(content: "Map updated, restart to apply changes", components: [ActionRowBuilder(components: restartButtons(true))]));
  } else {
    await interaction.respond(MessageBuilder(content: "Map updated, but server not started"));
  }
}