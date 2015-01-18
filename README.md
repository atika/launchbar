# LaunchBar Actions Repo
My Actions repository for LaunchBar 6 

* [Bluetooth Audio](#bluetoothaudio) 
* [Proxy Switch](#proxyswitch) 
* [Knock](#knock) 

<a name="bluetoothaudio"></a>
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

<a name="proxyswitch"></a>
## Proxy Switch

Display a list of user defined Proxy (json) and current status of Network Proxy Preferences (Ethernet).

![Switch Proxy](./assets/proxyswitch.png "Switch Proxy on Mac OS X")

### Installation
Install and launch ``ProxySwitch.lbaction`` and edit ``UserProxy.json`` located in ``~/Library/Application Support/LaunchBar/Action Support/com.agonia.proxyswitch/``

Action retrieve the __admin password__ from __Keychain__. Open Keychain app and add a new Generic Password named ```ProxySwitch```

__Tip:__ Press [ALT] key when you click on the action will display the "Action Support" Folder


### Define a proxy (UserProxy.json)
* __title:__ Proxy Title.
* __subtitle:__ Additional information.
* __proxy_ip:__ IP Address.
* __proxy_port:__ Port number.
* __proxy_type:__ Type : web, https, ftp or socks.
* __app:__ Application name or path to launch.

<a name="knock"></a>
## Knock : Port Knocking
Knock server port with knock from LaunchBar

![Knock](./assets/knock.png "Port knocking on Mac OS X")

Install and launch ``Knock.lbaction`` and edit ``KnockList.json`` located in ``~/Library/Application Support/LaunchBar/Action Support/com.agonia.knock/``

### Requirements
Knock app in /usr/local/bin
```shell
brew install knock
```

__Tip:__ Press [ALT] key when you click on the action will display additional informations

