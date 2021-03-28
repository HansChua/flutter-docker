FROM adoptopenjdk/openjdk12:jdk-12.0.2_10-ubuntu
LABEL maintainer "Michael Kuroneko <hardwarehacking@gmail.com>"
LABEL description="Flutter Develpment SDK"

USER root
ENV LANG en_US.UTF-8

# Install dependencies
RUN apt-get update && apt-get install -y git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 apt-utils apt-transport-https

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Install reviewdog
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin/

# Install dartcop (dartanalyzer wrapper)
RUN curl -fSL https://github.com/HansChua/dartcop/raw/master/src/dartcop/dartcop.py -o /usr/local/bin/dartcop \
    && chmod +x /usr/local/bin/dartcop

# Setup Flutter
RUN /usr/local/flutter/bin/flutter doctor -v \
    && rm -rfv /flutter/bin/cache/artifacts/gradle_wrapper
    # @see https://circleci.com/docs/2.0/high-uid-error/

# Setup Dart
RUN /usr/local/flutter/bin/cache/dart-sdk/bin/dart --disable-analytics

ENV PATH /usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
