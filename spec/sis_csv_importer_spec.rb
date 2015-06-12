require 'sis_csv_importer'

describe SisCSVImporter do
  describe "#parse_csvs" do
    it "reads csvs from a given directory and returns a hash with correct results" do
      correct_result = {
        "Suicide" => [],
        "Chemistry" => ["Noah Thomas", "Chloe Wood"],
        "Abortion, law" => []
      }
      path_to_csv = './spec/support/test_csvs'
      # csvs in this directory cover multiple cases:
      # - csv with quoting problem
      # - active enrollment pointing to a deleted user
      # - active enrollment pointing to a non-existent course and user
      expect(SisCSVImporter.new(path_to_csv).parse_csvs).to eq(correct_result)
    end
  end
end

