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
    ffmpeg \
    gnutls-dev \
    libaom-dev \
    libbluray-dev \
    libdav1d-dev \
    libdrm-dev \
    fontconfig-dev \
    libfreetype-dev \
    libfribidi-dev \
    libmp3lame-dev \
    openmpt-dev \
    opus-dev \
    libplacebo-dev \
    pulseaudio-dev \
    librist-dev \
    soxr-dev \
    libsrt-dev \
    libssh-dev \
    libtheora-dev \
    libv4l-dev \
    vidstab-dev \
    libvorbis-dev \
    libvpx-dev \
    libwebp-dev \
    libx264-dev \
    libx265-dev \
    libxcb-dev \
    libxml2-dev \
    libxvidcore-dev \
    zimg-dev \
    zeromq-dev \
    lld \
    vaapi-driver-intel \
    vdpauinfo \
    vulkan-loader

RUN git clone --depth 1 https://github.com/FFmpeg/FFmpeg.git

WORKDIR /FFmpeg

RUN ./configure --prefix=/usr/local --disable-debug --disable-doc --disable-ffplay --enable-shared \
    --disable-librtmp --disable-lzma --disable-static --disable-stripping --enable-avfilter \
    --enable-gnutls --enable-gpl --enable-libaom --enable-libass --enable-libbluray --enable-libdav1d \
    --enable-libdrm --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libmp3lame \
    --enable-libopenmpt --enable-libopus --enable-libplacebo --enable-libpulse --enable-librist --enable-libsoxr \
    --enable-libsrt --enable-libssh --enable-libtheora --enable-libv4l2 --enable-libvidstab --enable-libvorbis \
    --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxcb --enable-libxml2 \
    --enable-libxvid --enable-libzimg --enable-libzmq --enable-lto --enable-pic --enable-postproc \
    --enable-pthreads --enable-shared --enable-vaapi --enable-vdpau --enable-vulkan --enable-libjxl \
    --enable-libsvtav1 --enable-libvpl
RUN make -s -j$(nproc)
RUN make install

WORKDIR /
RUN rm -rf /FFmpeg

ENTRYPOINT ["/usr/local/bin/ffmpeg"]
