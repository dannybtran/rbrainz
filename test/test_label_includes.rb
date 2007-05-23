# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'test/unit'
require 'rbrainz'
include MusicBrainz

# Unit test for the LabelIncludes class.
class TestLabelIncludes < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  def test_includes
    includes = Webservice::LabelIncludes.new(
      :aliases => true,
      :artist_rels => true,
      :release_rels => true,
      :track_rels => true,
      :label_rels => true,
      :url_rels => true
      )
    result_string = includes.to_s
    assert_equal 'inc=', result_string[0..3]
    
    result_array = result_string[4..-1].split('%20')
    assert result_array.include?('aliases')
    assert result_array.include?('artist-rels')
    assert result_array.include?('release-rels')
    assert result_array.include?('track-rels')
    assert result_array.include?('label-rels')
    assert result_array.include?('url-rels')
  end
  
  def test_empty_includes
    includes = Webservice::LabelIncludes.new(
      :aliases => false,
      :artist_rels => false,
      :release_rels => false,
      :track_rels => false,
      :label_rels => false,
      :url_rels => false
      )
    assert_equal '', includes.to_s
  
    includes = Webservice::LabelIncludes.new({})
    assert_equal '', includes.to_s
  end
  
end