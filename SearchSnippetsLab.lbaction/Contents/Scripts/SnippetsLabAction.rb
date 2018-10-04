#!/usr/bin/env ruby
#
# Search in SnippetsLab
# Use SnippetsLab Alfred command to reformat response for LaunchBar.
# Dominique Da Silva https://github.com/atika — April 2016

require 'rexml/document'
include REXML

search = ARGV[0].strip

results = []

begin
	doc = Document.new(IO.popen("open -g './Alfred.app' && ./SnippetsLabAlfredWorkflow --search \"#{search}\""))
	doc2 = Document.new
	doc2.add_element("items")

	doc.root.each_element('//item'){ |item|

		subtitle = item.elements["subtitle"]

		item2 = Element.new("item")
		item2.add_element(item.elements["title"])
		item2.add_element(subtitle)
		item2.add_element("icon").text = "icon.png"
		item2.add_element("action").text = "SnippetsLabRun.rb"
		item2.add_element("actionArgument").text = item.elements["@uid"]
		item2.add_element("actionReturnsItems").text = "false"
		item2.add_element("label").text = subtitle.text.split("/").last.to_s

		doc2.root.add_element(item2)
	}
	print doc2
rescue

end
