FROM --platform=linux/amd64 archlinux:latest

ARG USERNAME=dev

RUN echo "DisableSandbox" >> /etc/pacman.conf \
    && pacman -Syu --noconfirm \
      age \
      base-devel \
      bitwarden-cli \
      curl \
      git \
      go \
      jq \
      openssh \
      sudo \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && useradd -m -s /bin/bash "$USERNAME"

USER $USERNAME
WORKDIR /home/$USERNAME

# Pre-build yay and pre-install AUR deps so install.sh's guards skip them at
# runtime. These layers are cached and only rebuild when this Dockerfile changes.
RUN git clone https://aur.archlinux.org/yay-bin.git /tmp/yay \
    && (cd /tmp/yay && makepkg -si --noconfirm) \
    && rm -rf /tmp/yay

# Pre-build statemate. Comment out if you're actively developing statemate and
# want install.sh to build it fresh each run instead.
#RUN git clone https://github.com/subbeh/statemate.git /tmp/statemate \
#    && (cd /tmp/statemate && make build) \
#    && sudo cp /tmp/statemate/mate /usr/local/bin/ \
#    && rm -rf /tmp/statemate
