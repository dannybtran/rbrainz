# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'test/unit'
require 'testing_helper'
require 'rbrainz'
include MusicBrainz

# Unit test for the ArtistFilter class.
class TestArtistFilter < Test::Unit::TestCase

  def setup
    @filter_hash = {:name => 'Tori Amos', :limit => 10}
  end

  def teardown
  end
  
  def test_filter
    filter = Webservice::ArtistFilter.new(@filter_hash)
    filter_string = filter.to_s
    assert_not_equal '&', filter_string[0]
    
    result_hash = query_string_to_hash filter_string
    assert_equal @filter_hash[:name], result_hash['name'], filter_string
    assert_equal @filter_hash[:limit].to_s, result_hash['limit'], filter_string
  end
  
  def test_empty_filter
    filter = Webservice::ArtistFilter.new({})
    assert_equal '', filter.to_s
  end
  
end