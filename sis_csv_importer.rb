require 'csv'

class SisCSVImporter
  def self.run(path_to_csv_dir)
    active_courses = []
    csvs_to_parse = Dir.entries(path_to_csv_dir).select { |f| !File.directory?(f) }
    csvs_to_parse.each do |file_path|
      CSV.foreach(path_to_csv_dir + "/" + file_path, :headers => true) do |row|
        active_courses << row["course_name"] if row["state"] == "active"
      end
    end
    active_courses
  end
end

