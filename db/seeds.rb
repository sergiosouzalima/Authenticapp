# This file should contain all the record creation needed to seed the database with its default values.
# How to run:
#
# rake db:seed
#
# ---

puts "####### deleting all users"
User.delete_all

(1..10).each do |e|
  fake_email = Faker::Internet.email
  password   = "123456"
  puts "####### creating user #{e}, #{fake_email}, password: #{password}"
  User.create( email: fake_email,
              password: password)
end
puts ""
puts "####### done."

