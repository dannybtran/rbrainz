#!/usr/bin/env ruby
#
# Example script which queries the database for a
# User
# 
# $Id: getartist.rb 88 2007-06-15 21:24:08Z nigel_graham $

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

username = ARGV[0] ? ARGV[0] : STDIN.gets.strip
password = ARGV[1] ? ARGV[1] : STDIN.gets.strip

ws = Webservice::Webservice.new(:username=>username,:password=>password)

# Create a new Query object which will provide
# us an interface to the MusicBrainz webservice.
query = Webservice::Query.new(ws)

user = query.get_user_by_name(username)
puts "Name            : " + user.name
puts "ShowNag         : " + user.show_nag?.to_s
puts "Types           : " + user.types.join(' ')