$LOAD_PATH << './lib'
require 'sis_csv_importer'

SisCSVImporter.new(ARGV.first).run
