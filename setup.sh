#!/bin/bash

github_user="fredriknk"
github_repo="fnk"

read -p "Vil du sette opp eduroam? (y/n) " answer
case ${answer:0:1} in
    y|Y )
        sudo python3 eduroam-linux-NMBU.py
    ;;
    * )
        echo "Eduroam ikke satt opp"
    ;;
esac

read -p "Vil du lage ssh-nøkler og importere fra github? (y/n) " answer
case ${answer:0:1} in
    y|Y )
		sudo apt install openssh-server
		
        ssh-keygen -t rsa -b 3072
		ssh-import-id gh:${github_user}
		sudo systemctl status ssh
    ;;
    * )
        echo "ssh ikke konfigurert"
    ;;
esac

read -p "Vil du sette opp ohmyzsh zsh? (y/n) " answer
case ${answer:0:1} in
    y|Y )
        sudo apt install git-core zsh
		sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
		sudo apt install fonts-powerline

		cd ~/.oh-my-zsh/custom/plugins
		git clone https://github.com/zsh-users/zsh-syntax-highlighting
		git clone https://github.com/zsh-users/zsh-autosuggestions


		curl https://raw.githubusercontent.com/${github_user}/${github_repo}/main/.zshrc > ~/.zshrc
    ;;
    * )
        echo "zsh ikke konfigurert"
    ;;
esac

read -p "Vil du sette opp standard programpakke? (y/n) " answer
case ${answer:0:1} in
    y|Y )
		echo "Installerer docker, trengs til alt"
		sudo apt update
		sudo apt install apt-transport-https ca-certificates curl software-properties-common
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
		apt-cache policy docker-ce
		sudo apt install docker-ce
		sudo systemctl status docker
		
		echo "installerer neovim, den kjekkeste editoren"
		sudo add-apt-repository ppa:neovim-ppa/unstable
		sudo apt-get update
		sudo apt-get install neovim
		
		echo "intstallerer glances for monitorering"
		sudo apt-get install glances
		
		echo "installer tmux for multitasking"
		sudo apt install tmux
		
		echo "installerer nethogs"
		sudo apt-get install nethogs
		
		echo "instalerer kubernates"
		sudo snap install microk8s --classic
		sudo ufw allow in on cni0 && sudo ufw allow out on cni0
		sudo ufw default allow routed
		
		
    ;;
    * )
        echo "ssh ikke konfigurert"
    ;;
esac



sudo apt update


sudo apt install openssh-server
sudo systemctl status ssh
sudo ufw allow ssh

