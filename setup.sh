#!/bin/bash

github_user="fredriknk"
github_repo="fnk"

read -p "Vil du sette opp eduroam? (y/n) " yn
case $yn in
    [Yy]* )
        sudo python3 eduroam-linux-NMBU.py
    ;;
    [Nn]* )
        echo "Eduroam ikke satt opp"
    ;;
	* ) echo "Please answer yes or no.";;
esac

read -p "Vil du lage ssh-nøkler og importere fra github? (y/n) " yn
case $yn in
    [Yy]* )
		sudo apt install openssh-server
                ssh-keygen -t rsa -b 3072
		ssh-import-id gh:${github_user}
		#sudo systemctl status ssh
    ;;
    [Nn]* )
        echo "ssh ikke konfigurert"
    ;;
	* ) echo "Please answer yes or no.";;
esac

read -p "Vil du sette opp standard programpakke? (y/n) " yn
case $yn in
    [Yy]* )	
    		read -p "Installerer docker, trengs til alt (y/n) " yn2
		case $yn2 in
		    [Yy]* )
			sudo apt update
			sudo apt install apt-transport-https ca-certificates curl software-properties-common
			curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
			sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
			apt-cache policy docker-ce
			sudo apt install docker-ce
			sudo apt install docker-compose
			sudo usermod -a -G docker $USER
			#sudo systemctl status docker
			;;
		    Nn ) exit;;
		esac
		
		read -p "installer neovim, den kjekkeste editoren(y/n) " yn2
		case $yn2 in
		    [Yy]* )
			sudo add-apt-repository ppa:neovim-ppa/unstable
			sudo apt-get update
			sudo apt-get install neovim
			;;
		    Nn ) exit;;
		esac
		
		read -p "intstaller glances for monitorering (y/n) " yn2
		case $yn2 in
		    [Yy]* )
			sudo apt-get install glances
			;;	
		    Nn ) exit;;
		esac
		
		read -p "installer tmux for multitasking (y/n) " yn2
		case $yn2 in
		    [Yy]* )
			sudo apt install tmux
			;;	
		    Nn ) exit;;
		esac
		
		read -p "installer highlight for cc cat (y/n) " yn2
		case $yn2 in
		    [Yy]* )
			sudo apt install highlight
			;;	
		    Nn ) exit;;
		esac
		
		read -p "installer nethogs (y/n) " yn2
		case $yn2 in
		    [Yy]* )
			sudo apt-get install nethogs
			;;	
		    Nn ) exit;;
		esac
		
		read -p "instaler kubernates (y/n) " yn2
		case $yn2 in
		    [Yy]* )
			echo "instalerer kubernates"
			sudo snap install microk8s --classic
			sudo ufw allow in on cni0 && sudo ufw allow out on cni0
			sudo ufw default allow routed
			;;	
		    Nn ) exit;;
		esac
		
		read -p "kompilerer og installerer exa for bedre filhandtering (y/n) " yn2
		case $yn2 in
		    [Yy]* )
			echo "kompilerer og installerer exa"
			sudo mkdir ~/tmp
			cd ~/tmp
			sudo apt install libgit2-dev rustc
			sudo apt-mark auto rustc
			sudo git clone https://github.com/ogham/exa --depth=1
			cd exa
			sudo cargo build --release && sudo cargo test #cargo test is optional
			sudo install target/release/exa /usr/local/bin/exa
			cd ..
			sudo rm -rf exa
			sudo apt purge --autoremove
			;;	
		    Nn ) exit;;
		esac
		
    ;;
    [Nn]* )
        echo "Ingen programmer installert"
    ;;
	* ) echo "Please answer yes or no.";;
esac

read -p "Vil du sette opp ohmyzsh zsh? (y/n) " yn
case $yn in
    [Yy]* )
        sudo apt install git-core zsh
		sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
		
		git clone https://github.com/abertsch/Menlo-for-Powerline.git
		sudo mv ./Menlo-for-Powerline/Menlo* /usr/share/fonts
		
		sudo cp ./.zshrc ~/.zshrc
		cd ~/.oh-my-zsh/custom/plugins
		git clone https://github.com/zsh-users/zsh-syntax-highlighting
		git clone https://github.com/zsh-users/zsh-autosuggestions
		
		zsh
    ;;
    [Nn]* )
        echo "zsh ikke konfigurert"
    ;;
	* ) echo "Please answer yes or no.";;
esac
