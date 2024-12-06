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
                ssh-keygen -t ed25519 -C "fnk@appserver.com"
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
			for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
   			# Add Docker's official GPG key:
			sudo apt-get update
			sudo apt-get install ca-certificates curl
			sudo install -m 0755 -d /etc/apt/keyrings
			sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
			sudo chmod a+r /etc/apt/keyrings/docker.asc
			
			# Add the repository to Apt sources:
			echo \
			  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
			  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
			  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
			sudo apt-get update
   			sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      			
			sudo usermod -a -G docker $USER
			#sudo systemctl status docker
			;;
		    Nn ) exit;;
		esac
		
		read -p "installer neovim, den kjekkeste editoren(y/n) " yn2
		case $yn2 in
		    [Yy]* )
			sudo apt install neovim
			;;
		    Nn ) exit;;
		esac
		
		read -p "intstaller glances for monitorering (y/n) " yn2
		case $yn2 in
		    [Yy]* )
			sudo apt install glances
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
		
		read -p "instaler eza (y/n) " yn2
		case $yn2 in
		    [Yy]* )
			echo "instalerer eza"
			sudo apt update
			sudo apt install -y gpg
			sudo mkdir -p /etc/apt/keyrings
			wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
			echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
			sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
			sudo apt update
			sudo apt install -y eza
			;;	
		    Nn ) exit;;
		esac

  		read -p "instaler crowdsec og bouncer (y/n) " yn2
		case $yn2 in
		    [Yy]* )
      			curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash
	 		apt install crowdsec
    			apt install crowdsec-firewall-bouncer-iptables
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
