require 'base_parser'

module Parsers
  class Course < BaseParser
    HEADERS = %w(course_id course_name state).sort

    def parse_active
      @csv.each do |row|
        @active[row["course_id"]] = row["course_name"] if active?(row)
      end
    end
  end
end
