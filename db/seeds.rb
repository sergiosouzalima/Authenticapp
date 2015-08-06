# This file should contain all the record creation needed to seed the database with its default values.
# How to run:
#
# rake db:seed
#
# ---

puts "####### deleting all users"
User.delete_all

password   = "123456"
user = ['admin@gmail.com','superuser@yahoo.com.br','john@uol.com.br']
user.each_with_index do |v,k|
  puts "####### creating user #{k+1}, #{v}, password: #{password}"
  User.create( email: v,
              password: password)
end
puts ""
puts "####### done."

