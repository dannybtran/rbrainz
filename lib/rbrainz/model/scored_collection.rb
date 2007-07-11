# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/collection'

module MusicBrainz
  module Model

    # A ScoredCollection is a list of entities with scores.
    # 
    # A ScoredCollection is returned as the result of an entity search (e.g. search
    # for an Artist). It contains an ordered list of Entry objects which wrap
    # the entities and a corresponding search score, which indicates how good
    # the entity matches the search criteria used for search. The entities in a
    # scored collection are sorted by score (in descending order).
    # 
    # A collection object may only store an extract of the complete data
    # available on the server. This is especially the case if the limit or
    # offset filter was used in the query. The collection object makes the
    # total number of elements on the server and the current offset available
    # with the +count+ respective the +offset+ parameter.
    class ScoredCollection < Collection
    
      # An entry in a ScoredCollection wrapping an entity and a
      # corresponding search result score.
      class Entry
        attr_accessor :entity, :score
        
        def initialize(entity, score=nil)
          @entity = entity
          @score  = score
        end
      end
    
      # Return an array of all entities.
      def entities
        return map {|entry| entry.entity}
      end
      
      # Add a new entry to the collection.
      # 
      # You may either add a ScoredCollection::Entry, just an Model::Entity
      # or an object responding to +first+ and +last+ where +first+ must
      # return the entity and +last+ the score.
      # 
      # Examples:
      #  include MusicBrainz
      #  artist = Model::Artist.new
      #  
      #  collection << Model::ScoredCollection::Entry.new(artist, 100)
      #  collection << [artist, 100]
      #  collection << artist
      def <<(entry)
        self[size] = entry
      end
      
      # Set the entry at the given position.
      # 
      # You may either add a ScoredCollection::Entry, just an Model::Entity
      # or an object responding to +first+ and +last+ where +first+ must
      # return the entity and +last+ the score.
      def []=(index, entry)
        unless entry.is_a? Entry
          if entry.respond_to?(:first) and entry.respond_to?(:last)
            entry = Entry.new(entry.first, entry.last)
          else
            entry = Entry.new(entry)
          end
        end
        super index, entry
      end
      
    end
    
  end
end