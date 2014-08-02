require './sis_csv_importer'

describe SisCSVImporter do
  describe "#run" do
    it "reads csvs from a given directory and returns a hash with correct results" do
      correct_result = {
        "Suicide" => [],
        "Chemistry" => ["Noah Thomas", "Chloe Wood"]
      }
      expect(SisCSVImporter.run("./test_csvs")).to eq(correct_result)
    end
  end
end

