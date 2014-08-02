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
    active_courses_to_students = {}
    csvs_to_parse = Dir.entries(path_to_csv_dir).select { |f| !File.directory?(f) }
    csvs_to_parse.each do |file_path|
      CSV.foreach(path_to_csv_dir + "/" + file_path, :headers => true) do |row|
        active_courses_to_students[row["course_name"]] = [] if row["state"] == "active"
      end
    end
    active_courses_to_students
  end
end

