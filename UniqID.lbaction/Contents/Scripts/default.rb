#!/usr/bin/env ruby

# LaunchBar Action Script

require 'json'
require 'securerandom'

item = {}
item['title'] = SecureRandom.hex(6)
puts item.to_json
