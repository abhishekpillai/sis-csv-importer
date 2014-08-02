require './sis_csv_importer'

describe SisCSVImporter do
  describe "#run" do
    it "reads csvs from a given directory and returns a hash keyed with active course names" do
      result = {
        "Suicide" => [],
        "Chemistry" => []
      }
      expect(SisCSVImporter.run("./test_csvs")).to eq(result)
    end
  end
end

