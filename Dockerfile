FROM ubuntu:16.04

MAINTAINER Yoshiki Iguchi

# Install sudo
RUN apt-get update \
  && apt-get -y install sudo \
  && useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Install 32bit lib
RUN sudo apt-get -y install lib32stdc++6 lib32z1

# Install Java8
RUN apt-get install -y software-properties-common curl \
    && add-apt-repository -y ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y openjdk-8-jdk

# Download Android SDK
RUN sudo apt-get -y install wget \
  && cd /usr/local \
  && wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz \
  && tar zxvf android-sdk_r24.4.1-linux.tgz \
  && rm -rf /usr/local/android-sdk_r24.4.1-linux.tgz

# Install Gradle
#ENV GRADLE_VERSION 2.14.1
#RUN cd /usr/local/ \
#  && curl -L -O "http://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
#  && apt-get install -y unzip \
#  && unzip -o "gradle-${GRADLE_VERSION}-bin.zip" \
#  && ln -s "/usr/local/gradle-${GRADLE_VERSION}/bin/gradle" /usr/bin/gradle

# Environment variables
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH $ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH

# Update of Android SDK
RUN echo y | android update sdk --no-ui --all --filter \
       "android-21,android-22,android-23,android-24,android-25" \
  && echo y | android update sdk --no-ui --all --filter \
       "build-tools-21.1.2,build-tools-22.0.1,build-tools-23.0.2,build-tools-23.0.3,build-tools-24.0.3,build-tools-25.0.0" \
  && echo y | android update sdk --no-ui --all --filter \
       "extra-google-m2repository,extra-android-m2repository"

# Install Gradle
RUN apt-get install -y ruby
