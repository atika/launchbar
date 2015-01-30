
require 'json'

item = ARGV[0]

if ! item.nil?
	thedate = JSON.parse(item)["title"]
	IO.popen('pbcopy', 'w') {|clipboard| clipboard << thedate } if ! thedate.nil?
end