# Created: 2020-05-30
# Revised: 2020-06-01

require_relative 'lib/controller'

# Once development finished, update this to 0.2 "testing", with a fixed date
puts "Welcome to extbrain, version 0.1 (\"prototype\"), #{Time.now.strftime('%Y-%m-%d')}"
$projects_and_tasks = ExtbrainData.new
command_loop

