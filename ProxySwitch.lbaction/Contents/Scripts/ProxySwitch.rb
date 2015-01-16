# 
#	Switch Proxy Action for LaunchBar 6
# 	Dominique Da Silva https://github.com/atika
# 	January 2015
#   v1.0
#

require 'json'
require 'FileUtils'


class Proxy

	require './keychain'

	def initialize(jsonFile)
		
		@proxies = Array.new
		@userProxies = Array.new
		@definedType = ["web", "https", "ftp", "socks"]
		@proxiesCmd = {
			"web" => { "setCmd" => "-setwebproxy", "getCmd" => "-getwebproxy", "stateCmd" => "-setwebproxystate" },
			"https" => { "setCmd" => "-setsecurewebproxy", "getCmd" => "-getsecurewebproxy", "stateCmd" => "-setsecurewebproxy" },
			"ftp" => { "setCmd" => "-setftpproxy", "getCmd" => "-getftpproxy", "stateCmd" => "-setftpproxystate" },
			"socks" => { "setCmd" => "-setsocksfirewallproxy", "getCmd" => "-getsocksfirewallproxy", "stateCmd" => "-setsocksfirewallproxystate" }
		}
		@password = KeyChain.find_generic_password '-s', 'ProxySwitch'
		@userProxies = JSON.parse( File.read( "#{jsonFile}" ) )
		# Add prefixe infos to subtitle
		@userProxies.each do |px|
			infos = px['subtitle']
			proxy_type = px['proxy_type']
			px['icon'] = "ProxyTemplate@2x.png"
			px['action'] = "ProxySwitch.rb"
			px['subaction'] = "setproxy"
			px['subtitle'] = '('+px['proxy_type'].capitalize+' Proxy) '+ px['proxy_ip'] + '/' + px['proxy_port'] + ' ' + infos
			px['title'] = px['title'] + " (#{proxy_type} type is incorect)" if not @definedType.include?(proxy_type)
		end
		# Update proxies menu
		update_proxies_menu
	end

	def update_proxies_menu

		@proxies.clear
		@proxies.replace( @userProxies )

		currentProxyWeb = currentProxy("web")
		currentProxyHttps = currentProxy("https")
		currentProxyFtp = currentProxy("ftp")
		currentProxySock = currentProxy("socks")

		@proxies << currentProxyWeb if !currentProxyWeb.nil?
		@proxies << currentProxyHttps if !currentProxyHttps.nil?
		@proxies << currentProxyFtp if !currentProxyFtp.nil?
		@proxies << currentProxySock if !currentProxySock.nil?

		if ENV['LB_OPTION_ALTERNATE_KEY'] == "1"
			@proxies << { 
				"title"=> "Support folder",
				"path"=> ENV['LB_SUPPORT_PATH']
			}
		end
	end

	def execute(item)
		item = JSON.parse(item)
		proxy_ip = item['proxy_ip'].to_s
		proxy_port = item['proxy_port'].to_s
		proxy_type = item['proxy_type'].to_s
		subaction = item['subaction'].to_s
		app = item['app'].to_s
		
		if subaction === "enable_current"
			setProxyState(proxy_type, "enable")
		elsif subaction === "disable_current"
			setProxyState(proxy_type, "disable")
		elsif subaction === "setproxy"
			setProxy(proxy_ip, proxy_port, proxy_type)
			launchapp(app) if !app.empty?
		end
		update_proxies_menu
	end

	def list()
		@proxies
	end

	private

	def setProxy(proxy_ip, proxy_port, proxy_type)

		return if not @definedType.include?(proxy_type)
		setcmd = @proxiesCmd[proxy_type]['setCmd']

		system("echo \"#{@password}\" | sudo -S /usr/sbin/networksetup "+setcmd+" Ethernet #{proxy_ip} #{proxy_port} 2>&1 >/dev/null")
		setProxyState(proxy_type, "enable")
	end

	def setProxyState(proxy_type, state)

		return if not @definedType.include?(proxy_type)
		setcmd = @proxiesCmd[proxy_type]['stateCmd']

		if state === 'enable'
			system("echo \"#{@password}\" | sudo -S /usr/sbin/networksetup "+setcmd+" Ethernet on 2>&1 >/dev/null")
		else
			system("echo \"#{@password}\" | sudo -S /usr/sbin/networksetup "+setcmd+" Ethernet off 2>&1 >/dev/null")
		end
	end

	def currentProxy(proxy_type)
		
		# Return if passed type is not in list
		return if not @definedType.include?(proxy_type)
		getcmd = @proxiesCmd[proxy_type]['getCmd']
		titlePrefix = '('+proxy_type.upcase+')'
		
		current_proxy = Array.new
		proxyCmd = IO.popen("/usr/sbin/networksetup "+getcmd+" Ethernet | head -n3")
		proxyCmd.readlines.each(){ |s| current_proxy.push( s.split(':')[1].strip )}

		penable = current_proxy[0]
		pip = current_proxy[1]
		pport = current_proxy[2]
		ptitle = pip+'/'+pport+' '+titlePrefix

		# return if proxy not defined
		return nil if pip.empty?

		# Determine Proxy Title
		@proxies.each do |px|
			if !px.nil?
				if px["proxy_ip"] === pip and px["proxy_port"] === pport and px["proxy_type"] === proxy_type
					ptitle = px["title"]+' '+titlePrefix
					next
				end
			end
		end

		menu = {}
		menu['title'] = ptitle
		menu['proxy_type'] = proxy_type
		menu['action'] = 'ProxySwitch.rb'

		if penable === "Yes"
			menu['subtitle'] = "Current "+proxy_type.capitalize+" Proxy is enabled"
			menu['icon'] = 'ProxyEnabled@2x.png'
			menu['subaction'] = 'disable_current'
		else
			menu['subtitle'] = "Current "+proxy_type.capitalize+" Proxy is disabled"
			menu['icon'] = 'ProxyDisabled@2x.png'
			menu['subaction'] = 'enable_current'
		end

		return menu
	end

	def launchapp(app)
		# Launch Application
		system('/usr/bin/open -a "'+app+'" && sleep 1 && osascript -e \'tell application "LaunchBar" to activate\'')
	end

end

item = ARGV[0]
userProxyJsonList = ENV['LB_SUPPORT_PATH']+"/UserProxy.json"

if ! File.file?(userProxyJsonList)
	jsonDefault = ENV['LB_ACTION_PATH']+"/Contents/Resources/Proxy.json"
	FileUtils.cp jsonDefault, userProxyJsonList	
end

proxies = Proxy.new( userProxyJsonList )

if !item.nil?
	proxies.execute(item)
end

puts proxies.list.to_json
