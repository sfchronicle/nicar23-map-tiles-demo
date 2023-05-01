FROM maptiler/tileserver-gl
ENV PORT "8080"
USER root

# Update packages
RUN apt-get update

### Commenting out Java install, we are removing Planetiler for now
# Install OpenJDK-17
# RUN apt update && \
#     apt-get install -y openjdk-17-jdk && \
#     apt-get install -y ant && \
#     apt-get clean;

# Set JAVA_HOME
# ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64/
# RUN export JAVA_HOME

# Prep wget for getting Planetiler
RUN apt-get install -y wget

# Move pre-packaged data onto volume
ADD mbtiles /mbtiles
ADD styles /styles
ADD createconfig.js /createconfig.js

# Run custom startup script
ADD bootstrap.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh
ENTRYPOINT ["/bootstrap.sh"]

