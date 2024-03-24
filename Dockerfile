# Use Ubuntu as base image
FROM ubuntu:latest
# Update package lists and install liblua5.3
RUN apt-get update && \
    apt-get install -y liblua5.3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install dart
RUN apt-get update && apt-get install apt-transport-https && \
    wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg  --dearmor -o /usr/share/keyrings/dart.gpg && \
    echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list && \
    apt-get update && apt-get install dart


# Set the working directory
WORKDIR /home/beammpserver
# At this point, you need to have the BeamMP-Server file inside the Docker context and copy it into the image.
# If you have a direct download link, you could use `wget` to download it instead of the COPY command.
COPY * /home/beammpserver/

# OR, for an example with wget (replace `your_direct_download_link` with the actual URL):
# RUN wget -O BeamMP-Server your_direct_download_link
# Make the server executable
RUN chmod +x BeamMP-Server

# Expose port 30814 for your other application
EXPOSE 30814

# Set entrypoint
ENTRYPOINT ["dart", "run", "./bin/beammp_discord_bot.dart"]
