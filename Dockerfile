FROM linuxserver/sonarr:arm32v7-latest
COPY qemu-arm-static /usr/bin
LABEL maintainer="mdhiggins <mdhiggins23@gmail.com>"

# get python3 and git, and install python libraries
RUN \
  apt-get update && \
  apt-get install -y \
    git \
    wget \
    python3 \
    python3-pip && \
# install pip, venv, and set up a virtual self contained python environment
  python3 -m pip install --user --upgrade pip && \
  python3 -m pip install --user virtualenv && \
  mkdir /usr/local/bin/sma && \
  python3 -m virtualenv /usr/local/bin/sma/env && \
  /usr/local/bin/sma/env/bin/pip install requests \
    requests[security] \
    requests-cache \
    babelfish \
    tmdbsimple \
    guessit \
    mutagen \
    subliminal \
    stevedore \
    python-dateutil \
    setuptools \
    qtfaststart && \
# download repo
  git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git /usr/local/bin/sma/sickbeard_mp4_automator && \
# create logging directory
  mkdir /var/log/sickbeard_mp4_automator && \
  touch /var/log/sickbeard_mp4_automator/index.log && \
  chgrp -R users /var/log/sickbeard_mp4_automator && \
  chmod -R g+w /var/log/sickbeard_mp4_automator && \
# ffmpeg
  wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-armhf-static.tar.xz -O /tmp/ffmpeg.tar.xz && \
  mkdir /usr/local/bin/ffmpeg && \
  tar -xJf /tmp/ffmpeg.tar.xz -C /usr/local/bin/ffmpeg --strip-components 1 && \
  chgrp -R users /usr/local/bin/ffmpeg && \
  chmod g+x /usr/local/bin/ffmpeg/ffmpeg && \
  chmod g+x /usr/local/bin/ffmpeg/ffprobe && \
# cleanup
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

EXPOSE 7878
VOLUME ["/usr/local/bin/sma/sickbeard_mp4_automator/autoProcess.ini"]
