include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    bio Faker::Lorem.paragraph(3)
    factory :admin do
      admin true
    end
  end

  factory :track do
    sequence(:title) { |n| "Test Track #{n}" }
    track_file do 
      fixture_file_upload(Rails.root.join('spec', 'fixtures', 'test.ogg'),
                         'audio/ogg')
    end
    description Faker::Lorem.paragraph(3)
  end

  factory :comment do
    user_id 1
    content "MyString"
    track_id 1
  end

end
