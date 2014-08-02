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
      csv_type = determine_csv_type(parsed_csv.headers)
      case csv_type
      when :course
        parse_courses(parsed_csv)
      when :student
        parse_students(parsed_csv)
      when :enrollment
        parse_enrollments(parsed_csv)
      end
    end
    determine_active_courses_and_enrolled_users
  end

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

  def determine_csv_type(headers)
    sorted_headers = headers.sort
    student_headers = %w(user_id user_name state).sort
    course_headers = %w(course_id course_name state).sort
    enrollment_headers = %w(course_id user_id state).sort

    if student_headers == sorted_headers
      :student
    elsif course_headers == sorted_headers
      :course
    elsif enrollment_headers == sorted_headers
      :enrollment
    end
  end

  def active?(row)
    row["state"] == "active"
  end

  def parse_courses(csv)
    csv.each do |row|
      @active_courses[row["course_id"]] = row["course_name"] if active?(row)
    end
  end

  def parse_students(csv)
    csv.each do |row|
      @active_users[row["user_id"]] = row["user_name"] if active?(row)
    end
  end

  def parse_enrollments(csv)
    csv.each do |row|
      if active?(row)
        @active_enrollments[row["course_id"]] ||= []
        @active_enrollments[row["course_id"]] << row["user_id"]
        @active_enrollments[row["course_id"]].uniq!
      elsif @active_enrollments[row["course_id"]]
        @active_enrollments[row["course_id"]].delete(row["user_id"])
      end
    end
  end

  def determine_active_courses_and_enrolled_users
    {}.tap do |active_courses_to_enrolled_users|
      @active_courses.each do |course_id, course_name|
        active_courses_to_enrolled_users[course_name] ||= []
        enrolled_users = @active_enrollments[course_id] || []
        enrolled_users.each do |user_id|
          active_courses_to_enrolled_users[course_name] << @active_users[user_id]
        end
      end
    end
  end
end

