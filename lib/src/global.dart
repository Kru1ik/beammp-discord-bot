import 'package:nyxx/nyxx.dart';

import 'beammp.dart';

Map<String, dynamic> config = {};

List<ButtonBuilder> restartButtons([bool enabled = true]) {
  return [ButtonBuilder(style: ButtonStyle.danger, label: "Restart", customId: "restart", isDisabled: !enabled)];
}

Future<void> restartEvent(MessageComponentInteraction interaction, BeamMP beammp) async {
  if(interaction.member!.id == interaction.message!.interaction!.user.id) {
    await interaction.acknowledge();
    await beammp.start();
    await interaction.respond(MessageUpdateBuilder(content: "Restart complete", components: [ActionRowBuilder(components: restartButtons(false))]), updateMessage: true);
  } else {
    await interaction.respond(MessageBuilder(content: "It's not your command!"), isEphemeral: true);
  }
}




Future<T?> permCheck<T>(T Function() func, ApplicationCommandInteraction interaction) async {
  if(
    interaction.member!.permissions!.isAdministrator ||
    (config["bot"]["allowedRoles"] != null && (config["bot"]["allowedRoles"] as List<int>).contains(interaction.member!.id.value))
  ) {
    return func();
  } else {
    interaction.respond(MessageBuilder(content: "You are not allowed to do this"));
    return null;
  }
}

Future<T?> memberCheck<T>(T Function() func, MessageComponentInteraction interaction) async {
  if(interaction.member!.id == interaction.message!.interaction!.user.id) {
    return func();
  } else {
    await interaction.respond(MessageBuilder(content: "It's not your command!"), isEphemeral: true);
    return null;
  }
}