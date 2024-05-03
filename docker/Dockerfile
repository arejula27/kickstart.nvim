FROM ubuntu:latest

RUN apt update -y
RUN apt upgrade -y

RUN apt install zsh  git neovim sudo man  curl unzip ripgrep gcc -y
RUN apt install nodejs npm python3 -y

RUN useradd --create-home --shell /bin/zsh arejula27-dev
RUN adduser arejula27-dev sudo 


RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
RUN echo "arejula27-dev:dev" | chpasswd


COPY docker/zshrc /home/arejula27-dev/.zshrc

USER arejula27-dev 

WORKDIR /home/arejula27-dev
RUN git clone https://github.com/arejula27/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
