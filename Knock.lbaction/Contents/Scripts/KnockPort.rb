# 
#	Knock Port Action for LaunchBar 6
# 	Dominique Da Silva https://github.com/atika/LaunchBar-actions
# 	January 2015
#   v1.0
#

require 'json'
require 'FileUtils'

class Knacki

	def initialize(jsonFile)		
		
		@version = 1.0

		@knocklist = Array.new
		@knocklist = JSON.parse( File.read( "#{jsonFile}" ) )
		@soundfile = ENV['LB_ACTION_PATH']+"/Contents/Resources/beep.mp3"

		@knocklist.each do |srv|
			server_ip = srv['server_ip']
			if !server_ip.nil?
				if !srv['children'].nil?
					# Server knock sequence list
					srv['icon'] = "Network.icns"
					srv['subtitle'] = server_ip if self.has_altkey_pressed?

					srv['children'].each do |kn|
						kn['action'] = "KnockPort.rb"
						kn['server_ip'] = server_ip
						# Display port sequence if [Alt] key pressed
						if self.has_altkey_pressed?
							infos = kn['subtitle'].nil? ? "" : "("+kn['subtitle']+")"
							kn['subtitle'] = kn['sequence'].upcase.gsub(","," ")+" #{infos}" if !kn['sequence'].nil?
						end
					end
				else
					# Knock sequence at root
					srv['action'] = "KnockPort.rb"
					srv['subtitle'] = server_ip+" ("+srv['sequence'].upcase.gsub(","," ")+") " if !srv['sequence'].nil? and self.has_altkey_pressed?
				end
			else
				srv['subtitle'] = "No server address specified!"
			end
		end

		if self.has_altkey_pressed?
			gitlink = {
				"title"=> "Show on GitHub",
				"url"=> "https://github.com/atika/LaunchBar-actions"
			}
			supportfolder = { 
				"title"=> "Support folder",
				"path"=> ENV['LB_SUPPORT_PATH']
			}
			version = {
				"title"=> "Version "+@version.to_s
			}
			@knocklist << gitlink
			@knocklist << supportfolder
			@knocklist << version
		end

	end

	def knock(item)
		item = JSON.parse(item)
		server_ip = item['server_ip'].to_s
		sequence = item['sequence'].to_s
		app = item['app'].to_s

		if !server_ip.empty? and !sequence.empty?
			knockargs = Array.new
			knockargs << server_ip
			knockargs << sequence.split(",")
			system("/usr/bin/afplay \"#{@soundfile}\"")
			system("/usr/local/bin/knock "+knockargs.join(' '))
			launchapp(app) if !app.empty?
		end
	end

	def launchapp(app)
		# Launch Application
		system('/usr/bin/open -a "'+app+'" && sleep 1 && osascript -e \'tell application "LaunchBar" to activate\'') if !app.empty?
	end

	def has_altkey_pressed?
		if ENV['LB_OPTION_ALTERNATE_KEY'] == "1"
			return true
		else
			return false
		end
	end

	def list()
		@knocklist
	end

end

item = ARGV[0]
userKnockJsonList = ENV['LB_SUPPORT_PATH']+"/KnockList.json"

if ! File.file?(userKnockJsonList)
	jsonDefault = ENV['LB_ACTION_PATH']+"/Contents/Resources/KnockList.json"
	FileUtils.cp jsonDefault, userKnockJsonList	
end

knacki = Knacki.new( userKnockJsonList )

if !item.nil?
	knacki.knock(item)
end

puts knacki.list.to_json
