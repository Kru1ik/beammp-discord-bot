#!/bin/bash

#* Create config file
# Get the auth key from environment variables
AUTH_KEY=$AUTHKEY
POR=$PORT
# Exit if auth key is not set
if [ -z "$AUTH_KEY" ] || [ -z "$POR" ]; then
  echo 'AUTHKEY or PORT not se, closing'
  poweroff
fi

# Create and write to ServerConfig.toml
cat > /home/beammpserver/ServerConfig.toml <<EOF
# This is the BeamMP-Server config file.
# Help & Documentation: https://wiki.beammp.com/en/home/server-maintenance
# IMPORTANT: Fill in the AuthKey with the key you got from https://keymaster.beammp.com/ on the left under "Keys"

[General]
Name = "BeamMP Server"
Port = $POR
# AuthKey has to be filled out in order to run the server
AuthKey = "$AUTH_KEY"
# Whether to log chat messages in the console / log
LogChat = true
# Add custom identifying tags to your server to make it easier to find. Format should be TagA,TagB,TagC. Note the comma separation.
Tags = "Freeroam"
Debug = false
Private = true
MaxCars = 10
MaxPlayers = 8
Map = "/levels/gridmap_v2/info.json"
Description = "BeamMP Default Description"
ResourceFolder = "Resources"

[Misc]
# Hides the periodic update message which notifies you of a new server version. You should really keep this on and always update as soon as possible. For more information visit https://wiki.beammp.com/en/home/server-maintenance#updating-the-server. An update message will always appear at startup regardless.
ImScaredOfUpdates = false
# You can turn on/off the SendErrors message you get on startup here
SendErrorsShowMessage = true
# If SendErrors is 'true', the server will send helpful info about crashes and other issues back to the BeamMP developers. This info may include your config, who is on your server at the time of the error, and similar general information. This kind of data is vital in helping us diagnose and fix issues faster. This has no impact on server performance. You can opt-out of this system by setting this to 'false'
SendErrors = true
EOF



# Start your other program
dart run ./bin/beammp_discord_bot.dart &

# Keep the container running
tail -f /dev/null
