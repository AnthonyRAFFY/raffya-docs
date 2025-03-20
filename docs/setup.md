This documentation contains every steps necessary to setup the basics for my own Ubuntu-server 22.04

# Up-to-date installation
First, make sure the installation is fully up-to-date :

    sudo apt-get update
    sudo apt-get upgrade

  

# Zsh
Install Zsh as it will provide better customizations later

	sudo apt-get install zsh
	chsh -s /bin/zsh
  

# Color support for MobaXTerm
(Optional) Color support for MobaXTerm

	echo 'export TERM=xterm-256color' >>~/.zshrc

  

# Powerlevel10k
Powerlevel10k provides great customizations options for Zsh

	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

 A powerlevel10k setup wizard should pop up after these commands.


  

# K3S as a service
Install K3S without Traefik using the official K3S installation script.

	curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik" sh -
	
	# Import the configuration file needed for kubectl to communicate with the cluster
	mkdir ~/.kube 2> /dev/null
	sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
	sudo chown "$USER:$USER" ~/.kube/config
	chmod 600 ~/.kube/config
	echo 'export KUBECONFIG=~/.kube/config' >>~/.zshrc

  Make sure this is working by running any kubectl command. Example :
  
	kubectl get pods --all-namespaces

# Autocompletion for zsh
Add autocompletion based on your command history

	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
	echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >>~/.zshrc

  

# Better grep and ls, aliases
Title says it all.

	cat >>~/.zshrc <<EOL


	# enable color support of ls and also add handy aliases
	if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "\$(dircolors -b ~/.dircolors)" || eval "\$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
	fi
	EOL

  
# Kubecolor
Add colors for the kubectl command.
	
	wget https://github.com/hidetatz/kubecolor/releases/download/v0.0.25/kubecolor_0.0.25_Linux_x86_64.tar.gz
	sudo tar -xzf kubecolor_0.0.25_Linux_x86_64.tar.gz -C /usr/local/bin kubecolor
	sudo chown root:root /usr/local/bin/kubecolor
	sudo chmod 755 /usr/local/bin/kubecolor

# Kubectl zsh completion
If you installed K3S, this add command completion for kubectl (pods names, namespaces, etc.)

Remove

	alias kubectl=kubecolor 
	compdef kubecolor=kubectl

from the below code if you decided not to install kubecolor.
		
	cat >>~/.zshrc <<EOL
	
	
	# Zsh K8S completion
	source <(kubectl completion zsh)
	alias kubectl=kubecolor
	compdef kubecolor=kubectl
	alias k=kubectl
	alias ksvc="kubectl get svc"
	alias kpods="kubectl get pod"
	alias kpv="kubectl get pv"
	alias kpvc="kubectl get pvc"
	EOL
  

# DNS
On Ubuntu server 22.04, DNS requests are sent to 127.0.0.1:53 and handled by systemd-resolved

To specify your DNS servers, modify 
	
	/etc/systemd/resolved.conf 

and restart the service

	systemctl restart systemd-resolved.service

If you need to free up the port 53 (Custom DNS server for example), you need to disable the stub

	DNSStubListener=no

Create a file /etc/systemd/resolved.conf.d/no-stub.conf with the following contents:

	[Resolve]
	DNSStubListener=no

On older version of linux, you need to manually update the symlink
	
	/etc/resolv.conf

to

	/run/systemd/resolve/resolv.conf

as it keeps the symlink to 

	/run/systemd/resolve/stub-resolv.conf


# Miniconda
For python users, install miniconda and its Zsh integration
	
	mkdir -p ~/miniconda3
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
	bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
	rm -rf ~/miniconda3/miniconda.sh
	~/miniconda3/bin/conda init zsh