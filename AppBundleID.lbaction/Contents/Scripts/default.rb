#!/usr/bin/env ruby
#
# LaunchBar Action Script
# Get the Bundle Identifier off an application
# 
# Dominique Da Silva — 2016
# http://atika.github.io/launchbar/

require 'json'

items = []
item = {}

path = ARGV[0].strip

error_message = "Invalid application path."

if File.exist?(path) && File.extname(path) == ".app" then
	item["title"] = `/usr/bin/osascript -e \"id of app \\\"#{path}\\\"\"`.strip
	item["subtitle"] = path
	item["icon"] = "BundleIDIconTemplate.png"
else
	item["title"] = error_message
	item["subtitle"] = path
	item["icon"] = "Caution.icns"
end

items.push(item)
puts items.to_json