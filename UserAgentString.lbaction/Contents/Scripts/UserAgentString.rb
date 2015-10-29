# 
#	User Agent String Action for LaunchBar 6
# 	Dominique Da Silva https://github.com/atika
# 	January 2015
#   v1.0
#

require 'net/http'
require 'json'
require 'FileUtils'

class UserAgentString

	def initialize
		@agentinfos = Array.new
	end

	def formatInfos
		agentrep = JSON.parse(@response.body)

		agent_type = agentrep["agent_type"]
		agent_version = agentrep["agent_version"]
		agent_name = agentrep["agent_name"]
		agent_fullname = "#{agent_name} #{agent_version}".strip

		linux_distibution = agentrep["linux_distibution"]
		os_type    = agentrep["os_type"]
		os_name    = agentrep["os_name"]

		# default
		os_icon, agent_icon, country_icon = "","",""
		# OS Icon
		os_icon = "windows.png" if os_type =~ /windows/i
		os_icon = "android.png" if os_type =~ /android/i
		os_icon = "macTemplate.png" if os_type =~ /macintosh/i
		os_icon = "debian.png" if linux_distibution =~ /debian/i
		os_icon = "ubuntu.png" if linux_distibution =~ /ubuntu/i

		# Country
		agent_language = agentrep["agent_language"]
		ct = agentrep["agent_languageTag"]
		agent_language_tag = ct =~ /-/ ? ct.match(/([a-zA-Z]+)-(.*)?/).captures[1].to_s.downcase : ct.match(/^([a-zA-Z]+)/).captures[0].to_s.downcase if ! ct.empty?

		if ! agent_language_tag.nil? and ! ENV["LB_ACTION_PATH"].nil?
			flag_path = ENV["LB_ACTION_PATH"] + "/Contents/Resources/flags/" + agent_language_tag + ".png"
			country_icon = flag_path
		end

		# Agent Icon
		agent_icon = "firefox.png" if agent_name =~ /firefox/i
		agent_icon = "safari.png" if agent_name =~ /safari/i
		agent_icon = "chrome.png" if agent_name =~ /chrome/i
		agent_icon = "safari-mobile.png" if agent_name =~ /safari/i and os_name =~ /(iphone|ipad) os/i
		agent_icon = "bot.png" if agent_name =~ /bot$/i or agent_type == "Crawler"
		agent_icon = "opera.png" if agent_name =~ /opera/i
		agent_icon = "internet-explorer.png" if agent_name =~ /Internet Explorer/i
		os_fullname = linux_distibution != "Null" ? "#{os_name} #{linux_distibution}".strip : "#{os_name}"

		os_version_name = agentrep["os_versionName"]
		os_version_number = agentrep["os_versionNumber"].to_s.tr('_','.')
		os_version = "#{os_version_name} #{os_version_number}".strip

		@agentinfos.push({ "title" => agent_fullname, "subtitle" => "Agent Name - Type #{agent_type}", "icon" => agent_icon }) if !agentrep["agent_name"].empty?
		@agentinfos.push({ "title" => os_fullname, "subtitle" => "OS Name", "icon" => os_icon }) if !os_fullname.empty?
		@agentinfos.push({ "title" => os_version, "subtitle" => "OS Version" }) if !os_version.empty?

		# For Internet Explorer
		if agent_name =~ /Internet Explorer/i
			if @agentstring =~ /WOW64/ then @agentinfos.push({ "title" => "(Windows-On-Windows 64-bit) A 32-bit application is running on a 64-bit processor", "subtitle" => "WOW64" }) end
			if @agentstring =~ /Trident/ then @agentinfos.push({ "title" => @agentstring[/Trident\/[0-9._]+/].sub('/',' '), "subtitle" => "Layout engine for the Microsoft Windows version of Internet Explorer." }) end
			if @agentstring =~ /SLCC2/ then @agentinfos.push({ "title" => "Microsoft-Windows-Security-Licensing-SLCC component SLCC is a service for the Windows Anytime upgrade process in Vista and Server 2008. Allows upgrade from Vista Home Basic to Vista Ultimate Edition, or Server 2008 Standard to Server 2008 Enterprise", "subtitle" => "SLCC2" }) end
			if @agentstring =~ /WOW64/ then @agentinfos.push({ "title" => "(Windows-On-Windows 64-bit) A 32-bit application is running on a 64-bit processor", "subtitle" => "WOW64" }) end
			if @agentstring =~ /Media Center PC/ then @agentinfos.push({ "title" =>  @agentstring[/Media Center PC [0-9._]+/], "subtitle" => "Media Center PC" }) end
			if @agentstring =~ /InfoPath/ then @agentinfos.push({ "title" =>  @agentstring[/InfoPath[0-9._]+/], "subtitle" => "Microsoft Office information gathering and management program" }) end
		end

		# For Chrome or Safari
		if agent_name =~ /safari/i or agent_name =~ /chrome/i
			if @agentstring =~ /AppleWebKit\/[0-9.]+/ then @agentinfos.push({ "title" => @agentstring[/AppleWebKit\/[0-9.]+/].sub('/',' '), "subtitle" => "The Web Kit provides a set of core classes to display web content in windows" }) end
			if agent_name =~ /safari/i
				version = /Version\/([0-9.]+)/.match(@agentstring).captures[0]
				if !version.empty? then @agentinfos.push({ "title" => "Safari " + version, "subtitle" => "Safari Version" }) end
			else
				# Chrome
				if @agentstring =~ /Safari\/[0-9.]+/ then @agentinfos.push({ "title" => @agentstring[/Safari\/[0-9.]+/].sub('/',' version '), "subtitle" => "Based on Safari" }) end
			end

			if @agentstring =~ / U;/ then @agentinfos.push({ "title" => "U: Strong Security", "subtitle" => "Security values" }) end
			if @agentstring =~ / N;/ then @agentinfos.push({ "title" => "N: No Security", "subtitle" => "Security values" }) end
			if @agentstring =~ / r;/ then @agentinfos.push({ "title" => "W: Weak Security", "subtitle" => "Security values" }) end
			if @agentstring =~ /KHTML/ then @agentinfos.push({ "title" => "KTML", "subtitle" => "Open Source HTML layout engine developed by the KDE project" }) end
		end

		# For firefox
		if agent_name =~ /firefox/i
			if @agentstring =~ /Firefox\/[0-9.]+/ then @agentinfos.push({ "title" => @agentstring[/Firefox\/[0-9.]+/].sub('/',' version '), "subtitle" => "Based on Safari" }) end

			if @agentstring =~ /rv:[0-9.]+/
				revision = /rv:([0-9.]+)/.match(@agentstring).captures[0]
			end

			if @agentstring =~ /Gecko/i 
				name, builddate = /(Gecko)\/([0-9.]+)/.match(@agentstring).captures
				revision_subtitle = "CVS Branch Tag #{revision}" if !revision.empty?
				revision_subtitle += " Build Date " + builddate if !builddate.empty?
				@agentinfos.push({ "title" => "Gecko engine inside", "subtitle" => "#{revision_subtitle}".strip }) 
			end
		end

		@agentinfos.push({ "title" => agentrep["os_producer"], "subtitle" => "OS Producer" }) if !agentrep["os_producer"].empty?
		@agentinfos.push({ "title" => agentrep["os_producerURL"], "subtitle" => "OS Producer URL" }) if !agentrep["os_producerURL"].empty?
		@agentinfos.push({ "title" => agent_language, "subtitle" => "Agent Language", "icon" => country_icon }) if !agent_language.empty?

		# Insert missing icons
		@agentinfos.each do |value|
			value["icon"] = "arrowTemplate.png" if !value.has_key?"icon"
		end
	end

	def getInfos(agentstring)

		@agentstring = agentstring

		data = {
			:uas => agentstring,
			:getJSON => "all"
		}

		url = URI.parse("http://www.useragentstring.com/")
		url.query = URI.encode_www_form(data)
		
		http = Net::HTTP.new(url.host, url.port)
		http.open_timeout = 5
		http.read_timeout = 2
		request = Net::HTTP::Get.new(url, initheader = {'Content-Type' =>'application/json'})

		begin

			http.start { |res| 
				@response = res.request(request)
				# puts @response.code

				if @response.code.to_i == 200
					formatInfos
				else
					raise "An error occured while contacting the server. (Error code #{@response.code})"
				end
			}

		rescue StandardError => error
			@agentinfos.push({"title"=>"Error","subtitle"=>"#{error}"})
		end

		@agentinfos

	end
 
	def list()
		@proxies
	end

end

agentstring = ARGV[0]

# agentstring = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.91 Safari/537.36"
# agentstring = "Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0"
# agentstring = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; it-it) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27"
# agentstring = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_U: Strong Security6_7; en-us) AppleWebKit/534.16+ (KHTML, like Gecko) Version/5.0.3 Safari/533.19.4"
# agentstring = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0b8) Gecko/20100101 Firefox/4.0b8"
# agentstring = "Mozilla/5.0 (Android; U; Android; pl; rv:1.9.2.8) Gecko/20100202 Firefox/3.5.8"
# agentstring = "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; Media Center PC 6.0; InfoPath.3; MS-RTC LM 8; Zune 4.7)"

if !agentstring.nil?
	uas = UserAgentString.new
	agentInfos = uas.getInfos(agentstring)
	puts agentInfos.to_json
end

