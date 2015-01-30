# 
#	Date Convert Action for LaunchBar 6
#   Convert date string or unix timestamp end display in different format
# 	Dominique Da Silva https://github.com/atika
# 	January 2015
#   v1.0
#

require 'date'
require 'json'

class UnixDate

	def today
		@thedate = DateTime.now
	end

	def initialize(date)

		if date.nil? or date === "now"
			today
		elsif /^[0-9]+$/ =~ date
			# Timestamp
			@thedate = Time.at(date.to_i).to_datetime
		elsif /^[+-]+[0-9]+d/ =~ date
			# Day Offset
			today
			offset = date.to_i
			@thedate = @thedate + offset
		elsif /^[+-]+[0-9]+m/ =~ date
			# Month offset
			today
			offset = date.to_i
			@thedate = @thedate >> offset
		elsif /^[+-]+[0-9]+h/ =~ date
			# Hours offset
			today
			offset = date.to_i
			actualdate = @thedate.to_time.to_i
			@thedate = Time.at(actualdate+(offset*3600)).to_datetime
		else
			# Date string
			begin
				@thedate = DateTime.parse(date).to_datetime
			rescue
				@error = 'Invalid date format'
			end
		end
	end

	def to_json
		
		json_result = Array.new

		if ! @error.nil?
			json_result.push({'title'=> @error})
		else
			year_week = @thedate.strftime("%W").to_i + 1
			json_result.push({'title'=> @thedate.strftime("%A %d %B %Y"), 'subtitle'=>'Day', 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false })
			json_result.push({'title'=> @thedate.strftime("%H:%M:%S"), 'subtitle'=>'Time', 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false })
			json_result.push({'title'=> @thedate.strftime("%s"), 'subtitle'=>'Unix Timestamp', 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false })
			json_result.push({'title'=> "UTC"+@thedate.zone, 'subtitle'=>'TimeZone', 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false })

			# comparaison
			now = DateTime.now.to_time.to_i
			date_timestamp = @thedate.to_time.to_i
			comparaison = now <=> date_timestamp
			if comparaison === -1
				# futur
				datediff = date_timestamp-now
				cmpdate = (datediff/86400).to_s + " day"
				cmpdate = (datediff/3600).to_s + " hour" if cmpdate.to_i === 0
				cmpdate = (datediff/60).to_s + " minute" if cmpdate.to_i === 0
				cmpdate = datediff.to_s + " second" if cmpdate.to_i === 0
				cmpdate = "" if cmpdate.to_i === 0
				cmpdate += "s" if cmpdate.to_i > 1
				json_result.push({'title'=> "It's in #{cmpdate}.", 'subtitle'=>'Interval', 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false }) if !cmpdate.empty?
			elsif comparaison === 1
				# past
				datediff = now-date_timestamp
				cmpdate = (datediff/86400).to_s + " day"
				cmpdate = (datediff/3600).to_s + " hour" if cmpdate.to_i === 0
				cmpdate = (datediff/60).to_s + " minute" if cmpdate.to_i === 0
				cmpdate = datediff.to_s + " second" if cmpdate.to_i === 0
				cmpdate = "" if cmpdate.to_i === 0
				cmpdate += "s" if cmpdate.to_i > 1
				json_result.push({'title'=> "It was #{cmpdate} ago.", 'subtitle'=>'Interval', 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false }) if !cmpdate.empty?
			end
				
			# format
			username ||= IO.popen('git config --get user.name').gets
			username ||= ENV['USER'] 
			username ||= "You"

			json_result.push({
				'title'=> 'Format',
				'icon'=>'clockTemplate@2x.png',
				'children' => [
					{'title'=> @thedate.strftime("%F"), 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false },
					{'title'=> @thedate.strftime("%d-%m-%Y"), 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false },
					{'title'=> @thedate.strftime("%x"), 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false },
					{'title'=> @thedate.strftime("%A %d %B %Y"), 'icon'=>'CopyActionTemplate.pdf','action'=>'CopyClipboard.rb', "actionReturnsItems"=> false },
					{'title'=> @thedate.strftime("%c"), 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false },
					{'title'=> @thedate.strftime("%B %Y"), 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false },
					{'title'=> "Copyright "+@thedate.strftime("%Y")+" © #{username}", 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false },
					{'title'=> @thedate.strftime("%X"), 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false },
					{'title'=> "Week "+year_week.to_s, 'icon'=>'CopyActionTemplate.pdf', 'action'=>'CopyClipboard.rb', "actionReturnsItems"=> false }
				]
			})

			# convert
			json_result.push({'title'=> "Convert", 'subtitle'=>'convert a date', 'icon'=>'clockTemplate@2x.png', 'actionBundleIdentifier'=>'com.agonia.dateconvert' })

		end
		json_result.to_json
	end
end

thedate = ARGV[0]
ud = UnixDate.new(thedate)
puts ud.to_json


