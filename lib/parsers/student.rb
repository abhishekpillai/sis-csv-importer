require 'base_parser'

module Parsers
  class Student < BaseParser
    HEADERS = %w(user_id user_name state).sort

    def parse_active
      @csv.each do |row|
        @active[row["user_id"]] = row["user_name"] if active?(row)
      end
    end
  end
end
