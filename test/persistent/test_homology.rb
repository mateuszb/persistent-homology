# frozen_string_literal: true

require "test_helper"

class Persistent::TestHomology < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Persistent::Homology::VERSION
  end

  def test_of_empty_sequence
    peaks = Persistent::Homology.compute([])
    assert_empty peaks
  end

  def test_of_simple_sequence
    peaks = Persistent::Homology.compute([1.0, 0.0, 3.0])
    refute_empty peaks
  end

  def test_of_simple_sequence_2
    peaks = Persistent::Homology.compute([1.0, 0.0, 0.0, 1.0])
    refute_empty peaks
  end

end
