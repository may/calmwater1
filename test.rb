

input_string = 'exit'

print 'boolean: '
puts input_string == 'exit'
p input_string
puts input_string == 'exit'
p input_string

unless 'exit' == input_string.lstrip! or '!!' == input_string.lstrip!
  puts 'writing mode magic here'
else
  puts 'Disabling writing mode..'
  $writing_mode = false
end
