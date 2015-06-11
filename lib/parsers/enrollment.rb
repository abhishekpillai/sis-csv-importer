require 'base_parser'

module Parsers
  class Enrollment < BaseParser
    def parse_active
      @csv.each do |row|
        if active?(row)
          @active[row["course_id"]] ||= []
          @active[row["course_id"]] << row["user_id"]
          @active[row["course_id"]].uniq!
        elsif @active[row["course_id"]]
          @active[row["course_id"]].delete(row["user_id"])
        end
      end
    end
  end
end
