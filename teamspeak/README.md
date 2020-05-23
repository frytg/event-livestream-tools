# WORK IN PROGRESS

## Setup

### Setup machine

1. Setup network (use region like VM)
2. Reserve IP
3. Setup VM: E2-micro, Debian 9, region like IP
4. Connect via SSH gcloud command, make sure to be root

### Install teamspeak

Run update

```shell
apt-get update && apt-get upgrade && apt-get install bzip2
```

Add user

```shell
adduser --disabled-login teamspeak
```

Press Enter a lot, then go to home directory

```shell
cd /home/teamspeak
```

Go to Download page and find the URL for the latest 64bit linux bundle: [teamspeak.com/en/downloads/](https://www.teamspeak.com/en/downloads/#server)  

```shell
wget $YOUR_URL
```

Unzip it

```shell
tar $FILE_NAME
```

Go inside the folder, double check using `ls` if unsure

```shell
cd teamspeak3-server_linux_amd64 && mv * /home/teamspeak && cd .. && rm -rf $FILE_NAME
```

Accept the terms (if you do...)

```shell
touch /home/teamspeak/.ts3server_license_accepted
```

Make teamspeak startup on launch

```shell
sudo nano /lib/systemd/system/teamspeak.service
```

with something like this

```shell
[Unit]
Description=TS3S
After=network.target
[Service]
WorkingDirectory=/home/teamspeak/
User=teamspeak
Group=teamspeak
Type=forking
ExecStart=/home/teamspeak/ts3server_startscript.sh start inifile=ts3server.ini
ExecStop=/home/teamspeak/ts3server_startscript.sh stop
PIDFile=/home/teamspeak/ts3server.pid
RestartSec=15
Restart=always
[Install]
WantedBy=multi-user.target
```

Save with Ctrl+O, exit with Ctrl+C.

Enable your service

```shell
systemctl enable teamspeak.service
```

Start your service

```shell
systemctl start teamspeak.service
```

Check your service (should include `Active: active (running)`)

```shell
service teamspeak status
```

View the logs to see your key to connect

```shell
cat /home/teamspeak/logs/ts3server_*
```

Look for these lines:

```shell
ServerAdmin privilege key created, please use the line below
token=...
```
