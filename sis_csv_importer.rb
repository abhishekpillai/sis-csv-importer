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

class SisCSVImporter
  def self.run(path_to_csv_dir)
    active_courses = {}
    active_users = {}
    active_enrollments = {}
    csvs_to_parse = Dir.entries(path_to_csv_dir).select { |f| !File.directory?(f) }
    csvs_to_parse.each do |file_path|
      CSV.foreach(path_to_csv_dir + "/" + file_path, :headers => true) do |row|
        csv_type = determine_csv_type(row.headers)
        case csv_type
        when :course
          active_courses[row["course_id"]] = row if row["state"] == "active"
        when :student
          active_users[row["user_id"]] << row["user_name"] if row["state"] == "active"
        when :enrollment
          active_enrollments[row["course_id"]] = row["user_id"] if row["state"] == "active"
        end
      end
    end
    active_courses_to_enrolled_users = {}

    active_courses_to_enrolled_users
  end

  def self.determine_csv_type(headers)
    sorted_headers = headers.sort
    student_headers = %w(user_id user_name state)
    course_headers = %w(course_id course_name state)
    #enrollment_headers = %w(user_id course_id state)

    if student_headers == sorted_headers
      :student
    elsif course_headers == sorted_headers
      :course
    else
      :enrollment
    end
  end
end

