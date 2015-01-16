# LaunchBar Actions Repo
Actions repository for LaunchBar 6 

## Bluetooth Audio

List system paired Bluetooth Audio devices, connect and set system audio output. 

![Bluetooth Audio](./assets/bluetoothaudio.png "Switch audio bluetooth source on Mac OS X")

Press __[ALT] key__ to disconnect bluetooth device.

### Requirements

Install Switch Audio
[https://github.com/deweller/switchaudio-osx](https://github.com/deweller/switchaudio-osx)
```shell
    brew install switchaudio-osx
```

## Proxy Switch

Display a list of user defined Proxy (json) and current status of Network Proxy Preferences (Ethernet).

![Switch Proxy](./assets/proxyswitch.png "Switch Proxy on Mac OS X")

### Installation
Install and launch ``ProxySwitch.lbaction`` and edit ``UserProxy.json`` located in ``~/Library/Application Support/LaunchBar/Action Support/com.agonia.proxyswitch/``

__Tip:__ Press [ALT] key when you click on the action will display the "Action Support" Folder

### Define a proxy (UserProxy.json)
* __title:__ Proxy Title.
* __subtitle:__ Additional information.
* __proxy_ip:__ IP Address.
* __proxy_port:__ Port number.
* __proxy_type:__ Type : web, https, ftp or socks.
* __app:__ Application name or path to launch.