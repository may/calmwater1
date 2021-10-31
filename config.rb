# Created: 2020-06-06
# Revised: 2021-10-30

## User options


# Extbrain uses color to denote when you need to do something or error states.
# For example, if you have a project with no next action -- it turns red.
# If you'd rather not have colors, you can turn this off with no (or limited)
# loss of function; for instance projects with no next action will be listed with !
# in front of them.
# TODO rename to $color ? 10/27
$color_only = false # If perfer b&w, if colorblind, or if using Windows, set this to false.


# Project list sorting - possible values:
#  :keyword
#  :creation [i.e. creation date, oldest first; see what you're avoiding
#             or may be taking awhile]
$project_sort = :keyword 
#$project_sort = :creation

# ISO standard is good, so is human-readable.
$time_formatting_string = "%Y-%m-%d %H:%M, %A."

# If true, running a second session of extbrain on the same computer
# will kill the first session.
$take_over_lock = true

# for writing habits, calculate average word count for *evey* day since the habit
# was created, not just the days you wrote. Can be toggled back and forth if needed.
# Setting to true provides a more accurate picture of how much you *actually* write,
# instead of just counting the 'good' days where you write.
$use_zero_day_average = true 



## Developer options
$log_command_usage = true

## Saving options

$save_directory = "#{Dir.home}/.extbrain"
$save_file = "#{$save_directory}/extbrain.yaml"
$lockfile = "#{$save_directory}/lockfile.txt" 
$archive_file = "#{$save_directory}/#{Time.now.year}_extbrain_completed_or_deleted.yaml"

$data_file_command_usage = "#{$save_directory}/command_usage.yaml"




