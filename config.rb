# Created: 2020-06-06
# Revised: 2020-06-13

$savefile_habits = 'extbrain-habits.yaml'
$lockfile = 'lockfile-extbrain.txt'
$color_only = true # if you don't want to see text indicating *when* you last completed a habit. If colorblind, set this to false.

# This is only evaluated on inital launch of the program.
# May need to have it reevaluated hourly if long-running process on a single remote machine.
if Time.now.wday.between?(1, 5) and Time.now.hour.between?(8, 17) # 8am-5pm & M-F assume work
  $life_context = :work
else
  $life_context = :personal
end 
