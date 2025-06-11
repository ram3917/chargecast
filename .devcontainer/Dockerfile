# Use   openjdk:17-jdk Debian-based OpenJDK 17 image
FROM ubuntu:latest

# Set environment variables
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:$PATH

# Install required system packages
RUN apt-get update && \
    apt install -y -q openjdk-17-jre openjdk-17-jdk-headless && \
    apt-get install -y --no-install-recommends \
        unzip wget git curl zsh lib32z1 lib32stdc++6 \
        python3 python3-pip ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Android SDK Command-line Tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# Accept licenses and install platform tools
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Set working directory
WORKDIR /workspace

# Default shell
CMD [ "bash" ]
