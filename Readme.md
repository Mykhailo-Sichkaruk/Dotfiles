# My Dotfiles

To setup root run: 
```bash
cd root
# Using Stow for all configurations except for logind.conf
sudo stow -v3 -t / . --ignore="wpa_supplicant.conf" --ignore="logind.conf" --ignore="/etc/lightdm/"

# Manually copy logind.conf to ensure it's properly handled by systemd
sudo cp ./etc/systemd/logind.conf /etc/systemd/logind.conf
sudo cp ./etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp ./etc/lightdm/lightdm-mini-greeter.conf /etc/lightdm/lightdm-mini-greeter.conf
sudo systemctl daemon-reload
sudo systemctl restart systemd-logind
sudo systemctl enable lock-before-hibernate.service
```

To setup home run:
> stow -v3 -t /home/__INSERT_USER_HERE__/ .

## Other
> Assuming that dotfiles have been already linked

bash trim-generations.sh 1 0 user && \
sudo bash trim-generations.sh 1 0 system && \
bash trim-generations.sh 1 0 home-manager 
