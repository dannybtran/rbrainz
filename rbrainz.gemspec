$:.push File.expand_path("../lib", __FILE__)

require "rbrainz/version"

Gem::Specification.new do |s|
  s.name        = "rbrainz"
  s.version     = MusicBrainz::RBRAINZ_VERSION
end
