#!/usr/bin/env ruby

uid = ARGV[0].strip

if !uid.empty? then
	if ENV["LB_OPTION_ALTERNATE_KEY"].to_i == 0 then
		# Reveal in SnippetsLab
		system("open snippetslab://snippet/#{uid}/")
	else
		# Copy snippets from SnippetsLab
		system("open -g snippetslab://alfred/#{uid}/")
	end
end
