# CODE SAMPLE

# The Problem
Schools use many different Student Information Systems, some commercial, some homegrown, some are even just an excel spreadsheet. Write a script that will take a CSV and parse a school's data.

In this problem we're only going to consider three data types: Students, Courses, and Enrollments. Enrollments is a join between Students and Courses.

```
student columns:    user_id,   user_name,   state
course columns:     course_id, course_name, state
enrollment columns: user_id,   course_id,   state
```

For all data types, state is in ['active', 'deleted']. The user_id and course_id are globally unique, so a new id means a new record, an id they've seen before means an update to an existing record.

Attached is a .zip of CSVs. You should write a program that processes the files in order. You'll need to determine the type of data in the csv based on the headers in the first row. At the end, you need to spit out a list of active courses, and for each course a list of active students with active enrollments in that course.

Some gotchas:
- Some of the enrollments are invalid (reference non-existing user or course).
- Watch out for quoting problems if you try to parse the CSVs by hand
- An active enrollment might point to a deleted user, and enrollments may be deleted as well.
- Column order in the CSV is unspecified, one user csv may be ordered differently than the next.

# Environment

If you have rbenv, when you cd into the directory, you should be automatically placed in ruby 2.2.2 for this coding exercise.
If you don't have rbenv, this code sample was written to work on ruby 2.2.2

# Tests

To run the specs, you will need to install rspec. You can install by doing `gem install rspec`

After you've done that, please run `rspec sis_csv_importer_spec.rb`

# How to run the script

`ruby run_importer.rb ./example-csvs`

On successful completion, there should be a txt file created at the root directory of the project with the list of active course names and active enrolled user names
