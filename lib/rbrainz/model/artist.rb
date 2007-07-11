# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/individual'
require 'rbrainz/model/alias'

module MusicBrainz
  module Model

    #
    # An artist in the MusicBrainz DB.
    #
    # Artists in MusicBrainz can have a type. Currently, this type can
    # be either Person or Group for which the following URIs are assigned:
    #
    # - http://musicbrainz.org/ns/mmd-1.0#Person
    # - http://musicbrainz.org/ns/mmd-1.0#Group
    #
    # Use the TYPE_PERSON and TYPE_GROUP constants for comparison.
    #
    # == See
    # http://musicbrainz.org/doc/Artist.
    #
    class Artist < Individual
    
      TYPE_PERSON = NS_MMD_1 + 'Person'
      TYPE_GROUP  = NS_MMD_1 + 'Group'
      
      # The list of releases.
      #
      # This may also include releases where this artist isn't the
      # <i>main</i> artist but has just contributed one or more tracks
      # (aka VA-Releases).
      attr_reader :releases
                    
      def initialize
        super
        @releases = Array.new
      end
      
    end

  end
end