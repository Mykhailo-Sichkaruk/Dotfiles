# My Dotfiles

To setup root run: 
```bash
cd root
sudo stow -v3 -t / . --ignore="wpa_supplicant.conf" --ignore="/etc/lightdm/"

sudo cp ./etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp ./etc/lightdm/lightdm-mini-greeter.conf /etc/lightdm/lightdm-mini-greeter.conf
sudo systemctl daemon-reload
sudo systemctl enable lock-before-hibernate.service
```

To setup home run:
> stow -v3 -t /home/__INSERT_USER_HERE__/ .

## Other
> Assuming that dotfiles have been already linked

bash trim-generations.sh 1 0 user && \
sudo bash trim-generations.sh 1 0 system && \
bash trim-generations.sh 1 0 home-manager 
