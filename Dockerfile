FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Update + base tools
RUN apt-get update && apt-get install -y \
  git curl unzip wget zip build-essential \
  openjdk-17-jdk python3 python3-pip \
  libssl-dev libclang-dev cmake pkg-config \
  && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Kotlin (CLI)
RUN curl -s https://get.sdkman.io | bash \
  && bash -c "source ~/.sdkman/bin/sdkman-init.sh && sdk install kotlin"

# Gradle (optional: specify version)
RUN wget https://services.gradle.org/distributions/gradle-8.7-bin.zip -P /tmp \
  && unzip -d /opt/gradle /tmp/gradle-8.7-bin.zip \
  && ln -s /opt/gradle/gradle-8.7/bin/gradle /usr/bin/gradle

# Rust + Android targets
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y \
  && ~/.cargo/bin/rustup target add aarch64-linux-android armv7-linux-androideabi \
  && ~/.cargo/bin/cargo install cargo-ndk

ENV PATH="/root/.cargo/bin:$PATH"

# Android SDK
ENV ANDROID_SDK_ROOT=/opt/android-sdk
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools \
  && cd $ANDROID_SDK_ROOT/cmdline-tools \
  && wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
  && unzip commandlinetools-linux-*.zip -d latest \
  && yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --sdk_root=$ANDROID_SDK_ROOT \
     "platform-tools" "platforms;android-33" "build-tools;33.0.2" "ndk;25.2.9519653"

ENV PATH="$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"

WORKDIR /chargecast

CMD ["/bin/bash"]
