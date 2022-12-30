FROM maptiler/tileserver-gl
ENV PORT "8080"
USER root

RUN apt-get update
# RUN apt-get install -y curl
# RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
# RUN apt-get install -y nodejs
# RUN npm install -g tileserver-gl

# Install OpenJDK-17
RUN apt update && \
    apt-get install -y openjdk-17-jdk && \
    apt-get install -y ant && \
    apt-get clean;

# Set JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64/
RUN export JAVA_HOME

# Prep wget for getting Planetiler
RUN apt-get install -y wget

# Move pre-packaged data onto volume
ADD mbtiles /mbtiles
ADD styles /styles
#ADD tileserver.config /config.json
ADD createconfig.js /createconfig.js

ADD bootstrap.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh
ENTRYPOINT ["/bootstrap.sh"]
# CMD ["/data/tennessee.mbtiles"]

