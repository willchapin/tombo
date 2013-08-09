include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :track do
    title 'Test Track'
    track_file do 
      fixture_file_upload(Rails.root.join('spec', 'tracks', 'test.ogg'), 'audio/ogg')
    end
  end
end
