FROM alpine:latest

RUN apk update && apk add --no-cache \
    build-base \
    git \
    yasm \
    lame-dev \
    libogg-dev \
    libvorbis-dev \
    libvpx-dev \
    x264-dev \
    x265-dev \
    freetype-dev \
    libass-dev \
    ffmpeg

RUN git clone --depth 1 https://github.com/FFmpeg/FFmpeg.git

WORKDIR /FFmpeg

RUN ./configure --prefix=/usr/local --disable-debug --disable-doc --disable-ffplay --enable-shared
RUN make -j$(nproc) V=0
RUN make install

WORKDIR /
RUN rm -rf /FFmpeg

ENTRYPOINT ["/usr/local/bin/ffmpeg"]
