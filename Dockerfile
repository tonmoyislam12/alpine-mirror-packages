FROM alpine:latest
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
    
RUN apk update && apk add --no-cache \
    build-base git yasm libjxl \
    lame-dev libogg-dev libvorbis-dev libvpx-dev x264-dev x265-dev \
    freetype-dev libass-dev ffmpeg gnutls-dev aom-dev libbluray-dev \
    dav1d-dev libdrm-dev fontconfig-dev fribidi-dev \
    libopenmpt-dev opus-dev libplacebo-dev pulseaudio-dev \
    librist-dev soxr-dev libsrt-dev libssh-dev libtheora-dev \
    v4l-utils-dev vidstab-dev libwebp-dev libxcb-dev \
    libxml2-dev xvidcore-dev zimg-dev zeromq-dev \
    lld intel-media-driver vdpauinfo vulkan-loader


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
