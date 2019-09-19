#!/usr/bin/env ruby

require 'net/http'

PACKAGE_MANAGERS = ['dnf','yum']

def command?(cmd)
	system("which #{cmd} > /dev/null 2>&1")
end

check_rc = nil

PACKAGE_MANAGERS.each do |pm|
	if command?(pm)
		check_rc = system("#{pm} check-update --security > /dev/null 2>&1")
		break
	end
end

if check_rc
	puts "No updates detected"
	if ARGV[0]
		snitch = ARGV[0].chomp
		res = Net::HTTP.get_response(URI("https://nosnch.in/#{snitch}"))
		puts "Reported okay for check updates to snitch #{snitch}"
	end
else
	puts "Updates detected"
	puts "Not reporting okay for snitch #{snitch}"
end

