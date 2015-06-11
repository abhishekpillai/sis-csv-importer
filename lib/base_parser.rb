class BaseParser
  attr_reader :active

  def initialize(csv)
    @csv = csv
    @active = {}
  end

  def parse_active
    raise "Implement this method in subclass"
  end

  def active?(row)
    row["state"] == "active"
  end
end
