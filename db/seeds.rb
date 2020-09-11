User.create!(name: "Example User", email: "example@railstutorial.org", password: "foobar", password_confirmation: "foobar", admin: true)

100.times do |n|
  User.create!(name: Faker::Name.name, email: "example-#{n+1}@reilstutorial.org", password: "password", password_confirmation: "password")
end

users = User.order(:created_at).take(6)
50.times do |n|
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.posts.create!(title: "example_title_#{user.name}_#{n}", content: content) }
end
