FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential sudo && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS primetime
ARG TAGS
RUN addgroup --gid 1000 dzajac
RUN adduser --uid 1000 --gid 1000 --disabled-password dzajac
RUN adduser dzajac sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER dzajac
WORKDIR /home/dzajac

FROM primetime
COPY --chown=dzajac:dzajac . .
CMD ["sh", "setup.sh"]
