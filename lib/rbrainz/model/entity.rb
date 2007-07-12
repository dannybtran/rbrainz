# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.
 
require 'rbrainz/model/mbid'
require 'rbrainz/model/relation'
require 'rbrainz/model/collection'
require 'rbrainz/model/tag'

module MusicBrainz
  module Model

    #
    # A first-level MusicBrainz class.
    # 
    # All entities in MusicBrainz have unique IDs (which are MBID's representing
    # absolute URIs) and may have any number of #relations to other entities.
    # This class is abstract and should not be instantiated.
    # 
    # Relations are differentiated by their <i>target type</i>, that means,
    # where they link to. MusicBrainz currently supports four target types
    # (artists, releases, tracks, and URLs) each identified using a URI.
    # To get all relations with a specific target type, you can use
    # #relations and pass one of the following constants as the
    # parameter:
    #
    # - Relation::TO_ARTIST
    # - Relation::TO_RELEASE
    # - Relation::TO_TRACK
    # - Relation::TO_URL
    #
    # == See 
    # Relation
    #
    class Entity
    
      # The MusicBrainz ID. A MBID containing an absolute URI.
      attr_reader :id
      
      # A Collection of Tag objects assigned to this entity.
      attr_reader :tags
      
      def initialize(id=nil)
        @id = id
        @tags = Collection.new
        @relations = {
          Relation::TO_ARTIST  => Collection.new,
          Relation::TO_RELEASE => Collection.new,
          Relation::TO_TRACK   => Collection.new,
          Relation::TO_LABEL   => Collection.new,
          Relation::TO_URL     => Collection.new,
        }
      end
      
      # Set the MBID.
      # 
      # +mbid+ should be an instance of +MBID+ or a string
      # representing either a complete MBID URI or just the
      # UUID part of it. If it is a complete URI the entity
      # part of the URI must match the entity type returned
      # by +entity_type+ or an +EntityTypeNotMatchingError+
      # will be raised.
      # 
      # Raises: +UnknownEntityError+, +InvalidMBIDError+,
      # +EntityTypeNotMatchingError+
      def id=(mbid)
        if mbid
          @id = MBID.parse(mbid, entity_type)
        else
          @id = nil
        end
      end
      
      # Returns the entity type of the entity class.
      # 
      # Depending on the class this is <tt>:artist</tt>, <tt>:release</tt>,
      # <tt>:track</tt> or <tt>:label</tt>.
      def self.entity_type
        self.name.sub('MusicBrainz::Model::', '').downcase.to_sym
      end
      
      # Returns the entity type of the instance.
      # 
      # Depending on the class this is <tt>:artist</tt>, <tt>:release</tt>,
      # <tt>:track</tt> or <tt>:label</tt>.
      def entity_type
        self.class.entity_type
      end
      
      #
      # Adds a relation.
      #
      # This method adds +relation+ to the list of relations. The
      # given relation has to be initialized, at least the target
      # type has to be set.
      #
      def add_relation(relation)
        @relations[relation.target_type] << relation
      end
      
      #
      # Returns a list of relations.
      #
      # If +target_type+ is given, only relations of that target
      # type are returned. For MusicBrainz, the following target
      # types are defined:
      # - Relation::TO_ARTIST
      # - Relation::TO_RELEASE
      # - Relation::TO_TRACK
      # - Relation::TO_URL
      # 
      # If +target_type+ is Relation::TO_ARTIST, for example,
      # this method returns all relations between this Entity and
      # artists.
      #
      # You may use the +relation_type+ parameter to further restrict
      # the selection. If it is set, only relations with the given
      # relation type are returned. The +required_attributes+ sequence
      # lists attributes that have to be part of all returned relations.
      #
      # If +direction+ is set, only relations with the given reading
      # direction are returned. You can use the Relation::DIR_FORWARD,
      # Relation::DIR_BACKWARD, and Relation::DIR_BOTH constants
      # for this.
      #
      def get_relations(options = {:target_type => nil, :relation_type => nil,
                                   :required_attributes => [], :direction => nil})
        # Select all results depending on the requested target type
        if options[:target_type]
          result = @relations[options[:target_type]]
        else
          result = []
          @relations.each_value {|array| result += array}
        end
        
        # Remove relations which don't meet all the criteria.
        result.delete_if {|relation|
          (options[:relation_type] and relation.type != options[:relation_type]) \
          or (options[:required_attributes] and
              (relation.attributes & options[:required_attributes]).sort \
               != options[:required_attributes].sort) \
          or (options[:direction] and relation.direction != options[:direction])
        }
        
        return result
      end
      
      #
      # Returns a list of target types available for this entity.
      # 
      # Use this to find out to which types of targets this entity
      # has relations. If the entity only has relations to tracks and
      # artists, for example, then a list containg the strings
      # Relation::TO_TRACK and Relation::TO_ARTIST is returned.
      #
      def relation_target_types
        result = []
        @relations.each_pair {|type, relations|
          result << type unless relations.empty?
        }
        return result
      end
      
    end
    
  end
end
