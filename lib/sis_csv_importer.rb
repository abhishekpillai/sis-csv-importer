# Notes
# - Students, Courses, Enrollments
# - all data types, state is in ['active', 'deleted’]
# - user_id and course_id are globally unique
# - determine the type of data in the csv based on the headers in the first row
# - spit out a list of active courses, and for each course a list of active students with active enrollments in that course
# - caveats:
#     - Some of the enrollments are invalid (reference non-existing user or course).
#     - Watch out for quoting problems if you try to parse the CSVs by hand
#     - An active enrollment might point to a deleted user, and enrollments may be deleted as well.
#     - Column order in the CSV is unspecified, one user csv may be ordered differently than the next.

require 'csv'
require 'time'
require 'parsers/course'
require 'parsers/student'
require 'parsers/enrollment'

class SisCSVImporter
  def initialize(path_to_csv_dir)
    @active_courses = {}
    @active_users = {}
    @active_enrollments = {}
    @path_to_csv_dir = path_to_csv_dir
  end

  def run
    active_courses_and_enrolled_users = parse_csvs
    write_to_file(active_courses_and_enrolled_users)
    "complete"
  end

  def parse_csvs
    csvs_to_parse = Dir.entries(@path_to_csv_dir).select { |f| !File.directory?(f) }
    csvs_to_parse.each do |file_path|
      parsed_csv = CSV.read(@path_to_csv_dir + "/" + file_path, :headers => true)
      parse_csv_by_type(parsed_csv)
    end
    determine_active_courses_and_enrolled_users
  end


  private

  def write_to_file(courses_and_users)
    File.open("active_courses_and_enrolled_users#{Time.now.iso8601}.txt", "w") do |f|
      courses_and_users.each do |course, users|
        f << "Active Course: "
        f << course
        f << "\n\n"
        f << "Active Enrolled Users:\n"
        f << users.join("\n")
        f << "\n\n\n"
      end
    end
  end

  def parse_csv_by_type(parsed_csv)
    sorted_headers = parsed_csv.headers.sort

    case sorted_headers
    when Parsers::Student::HEADERS
      @active_users = parse(Parsers::Student, parsed_csv)
    when Parsers::Course::HEADERS
      @active_courses = parse(Parsers::Course, parsed_csv)
    when Parsers::Enrollment::HEADERS
      @active_enrollments = parse(Parsers::Enrollment, parsed_csv)
    end
  end

  def parse(parser_type, csv)
    parser = parser_type.new(csv)
    parser.parse_active
    parser.active
  end

  def determine_active_courses_and_enrolled_users
    {}.tap do |active_courses_to_enrolled_users|
      @active_courses.each do |course_id, course_name|
        active_courses_to_enrolled_users[course_name] ||= []
        enrolled_users = @active_enrollments[course_id] || []
        enrolled_users.each do |user_id|
          if @active_users[user_id]
            active_courses_to_enrolled_users[course_name] << @active_users[user_id]
          end
        end
      end
    end
  end
end

