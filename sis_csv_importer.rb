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
      parsed_csv = CSV.read(path_to_csv_dir + "/" + file_path, :headers => true)
      csv_type = determine_csv_type(parsed_csv.headers)
      parsed_csv.each do |row|
        case csv_type
        when :course
          active_courses[row["course_id"]] = row["course_name"] if row["state"] == "active"
        when :student
          active_users[row["user_id"]] = row["user_name"] if row["state"] == "active"
        when :enrollment
         if row["state"] == "active"
           active_enrollments[row["course_id"]] ||= []
           active_enrollments[row["course_id"]] << row["user_id"]
         end
        end
      end
    end

    active_courses_to_enrolled_users = {}
    active_courses.each do |course_id, course_name|
      active_courses_to_enrolled_users[course_name] ||= []
      enrolled_users = active_enrollments[course_id] || []
      enrolled_users.each do |user_id|
        active_courses_to_enrolled_users[course_name] << active_users[user_id]
      end
    end
    active_courses_to_enrolled_users
  end

  def self.determine_csv_type(headers)
    sorted_headers = headers.sort
    student_headers = %w(user_id user_name state)
    course_headers = %w(course_id course_name state)
    #enrollment_headers = %w(user_id course_id state)

    if student_headers.sort == sorted_headers
      :student
    elsif course_headers.sort == sorted_headers
      :course
    else
      :enrollment
    end
  end
end

