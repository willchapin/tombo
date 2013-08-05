namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "test user",
                 email: "test@test.com",
                 password: "foobar",
                 password_confirmation: "foobar",
                 bio: Faker::Lorem.paragraph)
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "faker-#{n+1}@test.com"
      password  = "foobar"
      bio = Faker::Lorem.paragraph
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   bio: bio)
    end
  end
end
