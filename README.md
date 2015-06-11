# Environment

If you have rbenv, when you cd into the directory, you should be automatically placed in ruby 2.2.2 for this coding exercise.
If you don't have rbenv, this code sample was written to work on ruby 2.2.2

# Tests

To run the specs, you will need to install rspec. You can install by doing `gem install rspec`

After you've done that, please run `rspec sis_csv_importer_spec.rb`

# How to run the script

`ruby run_importer.rb full-path-to-csv-dir`

On successful completion, there should be a txt file created at the root directory of the project with the list of active course names and active enrolled user names
