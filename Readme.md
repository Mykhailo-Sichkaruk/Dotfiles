# My Dotfiles

To setup root run: 
```bash
cd root
# Using Stow for all configurations except for logind.conf
sudo stow -v3 -t / . --ignore="wpa_supplicant.conf" --ignore="logind.conf"

# Manually copy logind.conf to ensure it's properly handled by systemd
sudo cp ./etc/systemd/logind.conf /etc/systemd/logind.conf
sudo systemctl daemon-reload
sudo systemctl restart systemd-logind
sudo systemctl enable lock-before-hibernate.service
```

To setup home run:
> stow -v3 -t /home/__INSERT_USER_HERE__/ .

## Other
> Assuming that dotfiles have been already linked

