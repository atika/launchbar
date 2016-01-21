#!/usr/bin/env ruby
#
# LaunchBar Action Script
# Dominique Da Silva — January 2016
# https://github.com/atika/launchbar
# Send image or text to Copied (http://copiedapp.com/)

require 'json'

menu = []
@moreimage = "0"

def osascript(script)
	system 'osascript', *script.split(/\n/).map { |line| ['-e', line] }.flatten
end

# Copy an image to the clipboard
def filecopy(input)
	osascript <<-END
		delay #{@moreimage}
		set the clipboard to POSIX file ("#{input}")
		tell application "Copied"
			save clipboard
		end tell
	END
end

# copy text to the clipboard
def textcopy(input)
	osascript <<-END
		tell application "Copied"
			save "#{input}"
		end tell
	END
end

ARGV.each do | item |
	if item.downcase =~ /\.(png|jpeg|jpg|png|gif)$/
		# Image File path
		if File.exist?(item)
			filecopy item
			menu.push({
				"title"=> "#{File.basename(item)}",
				"subtitle"=> "Image sent to Copied.",
				"icon"=> item
			})
			@moreimage = "1.2"
		else
			menu.push({"title"=> "#{File.basename(item)} file not found."})
		end
	else
		# Copy Text/Link
		if item.downcase =~ /^(http|https|ftp|webdav|file):\/\//
			menu.push({"url"=>item, "subtitle"=> "Link sent to Copied."})
		else
			menu.push({"title"=> "Text copied as plain text."})
		end
		textcopy item
	end
end

puts menu.to_json
