# Use Ubuntu as base image
FROM ubuntu:latest
# Update package lists and install liblua5.3
RUN apt-get update && \
    apt-get install -y liblua5.3 && \
    apt-get clean

# GPG and WGET
RUN apt-get install -y gpg && \
    apt-get install -y wget

# Install dart
RUN apt-get install -y apt-transport-https && \
    wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg  --dearmor -o /usr/share/keyrings/dart.gpg && \
    echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list && \
    apt-get update && apt-get -y install dart


RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the working directory
WORKDIR /home/beammpserver

COPY . .

# OR, for an example with wget (replace `your_direct_download_link` with the actual URL):
# RUN wget -O BeamMP-Server your_direct_download_link
# Make the server executable
RUN chmod +x BeamMP-Server

RUN dart pub get

# Expose port 30814 for your other application
EXPOSE 30814

# Set entrypoint
# ENTRYPOINT ["dart", "run", "./bin/beammp_discord_bot.dart"]
ENTRYPOINT [ "./entrypoint.sh" ]
