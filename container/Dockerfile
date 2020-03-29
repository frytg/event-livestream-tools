# Start with NVidia CUDA base image
FROM nvidia/cuda:9.1-devel


# Kudos to Sebastian Ramirez <tiangolo@gmail.com> for the original nginx Dockerfile
LABEL maintainer="Daniel Freytag <sys@frytg.com>"


# Install dependent packages
RUN apt-get -y update && \
    apt-get -y --force-yes install wget autoconf automake git build-essential libass-dev libfreetype6-dev libgpac-dev \
    libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
    libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev


## BEGINN FFMPEG INSTALL with CUDA
## BEGINN FFMPEG INSTALL with CUDA

RUN git clone https://github.com/FFmpeg/nv-codec-headers /root/nv-codec-headers && \
  cd /root/nv-codec-headers &&\
  make -j2 && \
  make install -j2 && \
  cd /root && rm -rf nv-codec-headers

# Compile and install fresh ffmpeg from sources:
# See: https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
# Source: https://stackoverflow.com/questions/53944487/how-to-install-ffmpeg-in-a-docker-container
RUN echo "deb http://www.deb-multimedia.org stretch main non-free" >> /etc/apt/sources.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 5C808C2B65558117 && \
    apt-get update


RUN apt-get update -qq && apt-get -y install \
    autoconf \
    automake \
    build-essential \
    cmake \
    git-core \
    libass-dev \
    libfreetype6-dev \
    libsdl2-dev \
    libtool \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    pkg-config \
    texinfo \
    wget \
    zlib1g-dev \
    nasm \
    yasm \
    libx265-dev \
    libnuma-dev \
    libvpx-dev \
    libmp3lame-dev \
    libopus-dev \
    libx264-dev \
    libfdk-aac-dev

RUN git clone https://github.com/FFmpeg/FFmpeg /root/ffmpeg && \
    cd /root/ffmpeg && ./configure \
        --prefix="$HOME/ffmpeg_build" \
        --pkg-config-flags="--static" \
        --enable-libfdk-aac \
        --enable-cuvid \
        --enable-nvenc \
        --enable-nvdec \
        --enable-gpl \
        --enable-libass \
        --enable-libfreetype \
        --enable-libmp3lame \
        --enable-libopus \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-libx264 \
        --enable-libx265 \
        --enable-nonfree \
        --extra-cflags=-I/usr/local/cuda/include \
        --extra-cflags=-I/usr/local/include \
        --extra-ldflags=-L/usr/local/cuda/lib64 && \
    export LD_LIBRARY_PATH=/usr/lib && \
    PATH="$HOME/bin:$PATH" make -j2 && \
    make install -j2 && \
    hash -r && \
    cd /root && rm -rf ffmpeg
    # RUN mv ~/bin/ffmpeg /usr/local/bin && mv ~/bin/ffprobe /usr/local/bin && mv ~/bin/ffplay /usr/local/bin

RUN locate ffmpeg && \
    where ffmpeg && \
    which ffmpeg
RUN ffmpeg -version

## END FFMPEG INSTALL
## END FFMPEG INSTALL


# Versions of Nginx and nginx-rtmp-module to use
ENV NGINX_VERSION nginx-1.16.1
ENV NGINX_RTMP_MODULE_VERSION 1.2.1
ENV NVIDIA_DRIVER_CAPABILITIES video,compute,utility


# Install dependencies
RUN apt-get update && \
    apt-get install -y ca-certificates openssl libssl-dev software-properties-common && \
    rm -rf /var/lib/apt/lists/*


# Download and decompress Nginx
RUN mkdir -p /tmp/build/nginx && \
    cd /tmp/build/nginx && \
    wget -O ${NGINX_VERSION}.tar.gz https://nginx.org/download/${NGINX_VERSION}.tar.gz && \
    tar -zxf ${NGINX_VERSION}.tar.gz


# Download and decompress RTMP module
RUN mkdir -p /tmp/build/nginx-rtmp-module && \
    cd /tmp/build/nginx-rtmp-module && \
    wget -O nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION}.tar.gz https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    tar -zxf nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    cd nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION}


# Build and install Nginx
# The default puts everything under /usr/local/nginx, so it's needed to change
# it explicitly. Not just for order but to have it in the PATH
RUN cd /tmp/build/nginx/${NGINX_VERSION} && \
    ./configure \
        --sbin-path=/usr/local/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/var/run/nginx/nginx.pid \
        --lock-path=/var/lock/nginx/nginx.lock \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/tmp/nginx-client-body \
        --with-http_ssl_module \
        --with-threads \
        --with-ipv6 \
        --add-module=/tmp/build/nginx-rtmp-module/nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION} && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install && \
    mkdir /var/lock/nginx && \
    rm -rf /tmp/build


# Add hls tmp folder just in case
RUN mkdir -p /tmp/rec
RUN mkdir -p /tmp/rec/encoder-ingest
RUN mkdir -p /tmp/rec/encoder-output
RUN mkdir -p /tmp/rec/hls-pass
RUN mkdir -p /tmp/dash
RUN mkdir -p /tmp/hls
RUN mkdir -p /tmp/hls/encoder-output
RUN mkdir -p /tmp/hls/pass
RUN mkdir -p /tmp/log
RUN mkdir -p /tmp/log/nginx
RUN mkdir -p /tmp/log/ffmpeg


# Forward logs to Docker
RUN ln -sf /dev/stdout /tmp/log/nginx/stdout.log && \
    ln -sf /dev/stderr /tmp/log/nginx/stderr.log


# Set up config file
COPY nginx.conf /etc/nginx/nginx.conf
COPY stat.xsl /tmp/stat.xsl


# Expose ports
EXPOSE 1935
EXPOSE 8080


# Run nginx
CMD ["nginx", "-g", "daemon off;"]