require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do

    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_selector('title', text: 'Users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }
      let(:number_per_page) { 10 }
      let(:first_page) { User.paginate(page: 1, per_page: number_per_page) }
      let(:second_page) { User.paginate(page: 2, per_page: number_per_page) }

      it { should have_link('Next') }
      its(:html) { should match('>2</a>') }

      it "should list each user" do
        User.all[0..2].each do |user|
          page.should have_selector('a', text: user.name)
        end
      end

      it "should list the first page of users" do
        first_page.each do |user|
          page.should have_selector('a', text: user.name)
        end
      end

      it "should not list the second page of users" do
        second_page.each do |user|
          page.should_not have_selector('a', text: user.name)
        end
      end

      describe "showing the second page" do
        before { visit users_path(page: 2) }

        it "should list the second page of users" do
          second_page.each do |user|
            page.should have_selector('a', text: user.name)
          end
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_selector('a', text: 'delete') }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:t1) { FactoryGirl.create(:track, user: user) }
    let!(:t2) { FactoryGirl.create(:track, user: user) }

    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }

    describe "tracks" do
      it { should have_content(t1.title) }
      it { should have_content(t2.title) }

      describe "edit links" do
        describe "when not signed in" do
          it { should_not have_link('edit', href: edit_track_path(t1)) }
          it { should_not have_link('edit', href: edit_track_path(t1)) }
        end

        describe "when signed in" do
          before { sign_in user }
          it { should have_link('edit', href: edit_track_path(t1)) }
          it { should have_link('edit', href: edit_track_path(t2)) }
          describe "should lead to the track update page" do
            before { click_link('edit') }
            it { should have_selector('title', text: 'Update Track') }
          end
        end
      end

      describe "delete links" do
        describe "when not signed in" do
          it { should_not have_link('delete', href: track_path(t1)) }
          it { should_not have_link('delete', href: track_path(t2)) }
        end

        describe "when signed in" do
          before { sign_in user }
          it { should have_link('delete', href: track_path(t1)) }
          it { should have_link('delete', href: track_path(t2)) }
          it "should decrement the user's track count" do
            expect do
              click_link('delete')
            end.to change(user.tracks, :count).by(-1)
          end
        end
      end

    end

    describe "update profile link" do
      describe "when not signed in" do
        it { should_not have_link('update profile', href: edit_user_path(user)) }
      end
      describe "when signed in" do
        before { sign_in user }
        it { should have_link('update profile', href: edit_user_path(user)) }
      end
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: 'Unfollow') }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end
      end
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Sign up!" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "error messages" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_selector('ul', class: 'errors') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirm", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }

        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('div.alert.alert-success', text: 'Welcome to Tombo!') }
        it { should have_link('sign out') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1', text: "Update your profile") }
      it { should have_selector('title', text: "Update profile") }
    end

    describe "with invalid information" do
      before { click_button "Update!" }

      it { should have_selector('ul', class: 'errors') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      let(:new_bio) { Faker::Lorem.paragraph(2) }

      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Bio", with: new_bio
        fill_in "Password", with: user.password
        fill_in "Confirm", with: user.password
        click_button "Update!"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('sign out', href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
      specify { user.reload.bio.should == new_bio }
    end
  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_selector('title', text: full_title('Following')) }
      it { should have_selector('h2', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_selector('title', text: full_title('Followers')) }
      it { should have_selector('h2', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
end
