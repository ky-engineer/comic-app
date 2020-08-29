User.create!(name: "Example User", email: "example@railstutorial.org", password: "foobar", password_confirmation: "foobar", admin: true)

100.times do |n|
  User.create!(name: Faker::Name.name, email: "example-#{n+1}@reilstutorial.org", password: "password", password_confirmation: "password")
end
