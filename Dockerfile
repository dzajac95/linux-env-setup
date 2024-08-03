# syntax=docker/dockerfile:1.7-labs
FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential sudo && \
    apt-get install -y python3 python3-pip python3-venv

FROM base AS primetime
ARG TAGS
RUN addgroup --gid 1000 dzajac
RUN adduser --uid 1000 --gid 1000 --disabled-password dzajac
RUN adduser dzajac sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER dzajac
WORKDIR /home/dzajac
ENV USER=dzajac
ENV HOME="/home/$USER"
ENV PATH="$PATH:$HOME/.local/bin"

FROM primetime
COPY --exclude=.git --exclude=.venv --chown=dzajac:dzajac . .
CMD ["bash", "setup.sh"]
