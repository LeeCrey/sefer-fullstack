# frozen_string_literal: true

u = User.new(
  first_name: "Lee",
  email: "test@example.com",
  password: "123456789",
  gender: User::GENDER[:Male],
  password_confirmation: "123456789",
)

u.confirm
puts u.save

(1..20).each do |i|
  g = i % 2
  pwd = Faker::Internet.password
  u = User.new
  u.gender = g
  u.first_name = Faker::Name.first_name
  u.last_name = Faker::Name.last_name
  u.email = Faker::Internet.email
  u.password_confirmation = pwd
  u.password = pwd
  # u.country = CS.countries.values[1 + rand(248)]
  # u.birthdate = Faker::Date.birthday
  u.save
  puts i
end
