# LaunchBar Actions and Themes
My Repository of Actions and Themes for LaunchBar 6.


- [Knock - Port Knocking](#knock---port-knocking)
     - [Requirements](#requirements)
     - [Define a sequence](#define-a-sequence)
     - [Download](#download)
- [Unique Identifier](#unique-identifier)
     - [Download](#download)
- [Application Reloader](#application-reloader)
     - [Download](#download)
- [Search in SnippetsLab](#search-in-snippetslab)
     - [Download](#download)
- [LaunchBar Midnight Theme](#launchbar-midnight-theme)
     - [Download](#download)
- [Bluetooth Audio](#bluetooth-audio)
     - [Requirements](#requirements)
     - [Download](#download)
- [Send to Copied](#send-to-copied)
     - [Installation](#installation)
     - [Download](#download)
- [Proxy Switch](#proxy-switch)
     - [Installation](#installation)
     - [Define a proxy (UserProxy.json)](#define-a-proxy-userproxyjson)
     - [Download](#download)
- [Run iTerm2 Command](#run-iterm2-command)
     - [Download](#download)
- [Date Convert](#date-convert)
     - [Download](#download)
- [Application Bundle Identifier](#application-bundle-identifier)
     - [Download](#download)
- [Mac Promo Code](#mac-promo-code)
     - [Download](#download)



--------------------

## Knock - Port Knocking

Knock server port with knock from LaunchBar

<!-- more -->

![Knock](./assets/knock.png "Port knocking on Mac OS X")

Install and launch ``Knock.lbaction`` and edit ``KnockList.json`` located in ``~/Library/Application Support/LaunchBar/Action Support/com.inspira.knock/``

__Tip:__ Press [ALT] key when you click on the action will display additional informations

### Requirements
Knock app in /usr/local/bin
```shell
brew install knock
```

### Define a sequence
* __title:__ LaunchBar menu title
* __subtitle:__ LaunchBar menu subtitle
* __server_ip:__ Server name or IP address
* __sequence:__ comma separated list
* __delay:__ delay in milliseconds between knock
* __app:__ name of the app to launch

```json
[
	{
		"title": "Raspberry",
		"server_ip": "192.168.0.50",
		"children": [
			{
					"title": "My knock command",
					"sequence": "5000:tcp,7000:tcp,6000:tcp",
					"delay": 300,
					"app":"MyAppToLaunch"
			},
			{
					"title": "...",
					"sequence": "..."
			}
		]
	}
]
```
or a sequence at root :
```json
[
	{
		"title": "My knock command",
		"server_ip": "192.168.0.50",
		"sequence": "5000:tcp,7000:tcp,6000:tcp",
		"delay": 300,
		"app":"MyAppToLaunch"
	}
]
```

### Download
Knock Action: [Knock.lbaction](https://github.com/atika/launchbar/raw/master/actions-zipped/Knock.lbaction)



--------------------

## Unique Identifier

Generate a 12 characters unique identifier.

### Download
UniqID Action: [UniqID.lbaction](https://github.com/atika/launchbar/raw/master/actions-zipped/UniqID.lbaction)



--------------------

## Application Reloader

Quit and restart passed Mac Application.

### Download
Reload Mac App: [ReloadApplication.lbaction](https://github.com/atika/launchbar/raw/master/actions-zipped/ReloadApplication.lbaction)



--------------------

## Search in SnippetsLab

Live Search in SnippetsLab from Launchbar.

<!-- more -->

![SnippetsLab Search](./assets/search-snippetslab-launchbar.png "Live search in SnippetsLab from LaunchBar")

<!-- **Important:** The developer added a verification directly into the app SnippetsLab to accept **request only from the Alfred app**. -->

Press `ALT` to copy, click item to reveal in SnippetsLab

### Download
Search SnippetsLab Action: [SearchSnippetsLab.lbaction](https://github.com/atika/launchbar/raw/master/actions-zipped/SearchSnippetsLab.lbaction)



--------------------

## LaunchBar Midnight Theme

Midnight Theme for LaunchBar

![Midnight LaunchBar Theme](./assets/launchbar-midnight-theme.png "Midnight LaunchBar Theme")

### Download
Midnight LaunchBar Theme: [Midnight.lbtheme](https://github.com/atika/launchbar/raw/master/actions-zipped/Midnight.lbtheme)



--------------------

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

### Download
Bluetooth Audio Action: [BluetoothAudio.lbaction](https://github.com/atika/launchbar/raw/master/actions-zipped/BluetoothAudio.lbaction)



--------------------

## Send to Copied

Send Image or Text to Copied app [copiedapp.com](http://copiedapp.com/).

![Send to Copied](./assets/sendtocopiedapp.png "Send to Copied app for Mac OS X")

### Installation
Doucle-click on ``SendToCopied.lbaction`` to install and:

* Send Text or Image file with **LaunchBar Instant Send** to "Send to Copied" action.
* Press space to Enter text to copy.
* Press enter to choose an Image file to send to Copied.

### Download
Send to Copied: [SendToCopied.lbaction](https://github.com/atika/launchbar/raw/master/actions-zipped/SendToCopied.lbaction)



--------------------

## Proxy Switch

Display a list of user defined Proxy (json) and current status of Network Proxy Preferences (Ethernet).

![Switch Proxy](./assets/proxyswitch.png "Switch Proxy on Mac OS X")

### Installation
Install and launch ``ProxySwitch.lbaction`` and edit ``UserProxy.json`` located in ``~/Library/Application Support/LaunchBar/Action Support/com.inspira.proxyswitch/``

Action retrieve the __admin password__ from __Keychain__. Open Keychain app and add a new Generic Password named ```ProxySwitch```

__Tip:__ Press [ALT] key when you click on the action will display the "Action Support" Folder


### Define a proxy (UserProxy.json)
* __title:__ Proxy Title.
* __subtitle:__ Additional information.
* __proxy_ip:__ IP Address.
* __proxy_port:__ Port number.
* __proxy_type:__ Type : web, https, ftp or socks.
* __app:__ Application name or path to launch.

### Download
Switch Proxy Action: [ProxySwitch.lbaction](https://github.com/atika/launchbar/raw/master/actions-zipped/ProxySwitch.lbaction)



--------------------

## Run iTerm2 Command

Open iTerm2 and run a command (requires iTerm 2.9 and earlier).

<!-- more -->

![Run iTerm 2.9 command](./assets/run-iterm2-command-launchbar.png "Run iTerm2 command in LaunchBar")

### Download
Run iTerm2 Command action: [Run iTerm Command.lbaction](https://github.com/atika/launchbar/raw/master/actions-zipped/Run%20iTerm2%20Command.lbaction)



--------------------

## Date Convert

Display date in __differents formats__ and convert _unix timestamp_ or date string. You can also __calculate an interval__, example: _+1d or -5h (h:hour, d:day, w:week, m:month)._

Press space bar to enter a date and __clicking on the date__ put content on the clipboard.

![Date Convert](./assets/dateconvert.png "Convert Unix Timestamp and date with Mac OS X Launchbar")

### Download
Date Convert Action: [DateConvert.lbaction](https://github.com/atika/launchbar/raw/master/actions-zipped/DateConvert.lbaction)



--------------------

## Application Bundle Identifier

Get the bundle identifier of an application.

<!-- more -->

![App Bundle ID](./assets/app-bundle-id-launchbar.png "Get application bundle identifier")

### Download
App Bundle ID Action: [AppBundleID.lbaction](https://github.com/atika/launchbar/raw/master/actions-zipped/AppBundleID.lbaction)



--------------------

## Mac Promo Code

Open the Mac App Store application to redeem a promo code.

### Download
Mac Promo Code: [MacPromoCode.lbaction](https://github.com/atika/launchbar/raw/master/actions-zipped/MacPromoCode.lbaction)

