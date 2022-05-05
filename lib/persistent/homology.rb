# frozen_string_literal: true

require_relative "homology/version"

module Persistent
  module Homology

    class Error < StandardError; end

    def self.compute(sequence)
      peaks = []

      # Index to peak map
      index_to_peak = Array.new(sequence.length)
      indices = Range.new(0, sequence.length - 1).to_a.sort.reverse

      indices.each do |idx|
        left_done = ((idx.positive? and !index_to_peak[idx - 1].nil?))
        right_done = ((idx < sequence.length - 1) and !index_to_peak[idx + 1].nil?)

        left = left_done ? index_to_peak[idx - 1] : nil
        right = right_done ? index_to_peak[idx + 1] : nil

        if !left_done && !right_done
          peaks << Peak.new(idx)
          index_to_peak[idx] = peaks.length - 1
        end

        if left_done && !right_done
          peaks[left].right += 1
          index_to_peak[idx] = left
        end

        if !left_done && right_done
          peaks[right].left -= 1
          index_to_peak[idx] = right
        end

        if left_done && right_done
          if sequence[peaks[left].born] > sequence[peaks[right].born]
            peaks[right].died = idx
            peaks[left].right = peaks[right].right
            index_to_peak[peaks[left].right] = index_to_peak[idx] = left
          else
            peaks[left].died = idx
            peaks[right].left = peaks[left].left
            index_to_peak[peaks[right].left] = index_to_peak[idx] = right
          end
        end
      end

      peaks
    end

    # A class to keep track of peaks in the persistent homology
    class Peak
      def initialize(start_index)
        @born = @left = @right = start_index
        @died = nil
      end

      def get_persistence(sequence)
        if @died.nil?
          Float::INFINITY
        else
          sequence[@born] - sequence[@died]
        end
      end
    end
  end
end
