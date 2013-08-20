require 'spec_helper'

describe "Track pages" do

  subject { page }

  describe "show track" do
    let(:track_author) { FactoryGirl.create(:user) }
    let(:comment_author) { FactoryGirl.create(:user) }
    let(:user) { FactoryGirl.create(:user) }
    let(:track) { FactoryGirl.create(:track, user: track_author) }
    let(:comment) do
      comment_author.comments.build(
                      track_id: track.id,
                      content: Faker::Lorem.paragraph(2))
    end

    before do
      sign_in user
      visit track_path(track)
    end

    it { should have_selector('title', text: 'Track') }
    it { should have_link(track.title, href: track_path(track)) }
    it { should have_selector('p', text: track.description) }
    it { should have_selector('p', text: track_author.bio) }
    it { should have_selector('p', text: 'No one has commented on this track.') }

    describe "with comments" do
      before do
        comment.save
        visit track_path(track)
      end

      it { should have_selector('p', text: comment.content) }
      it { should have_link(comment_author.name, href: user_path(comment_author)) }
      describe "signed in as comment author" do
        before do
          sign_in comment_author
          visit track_path(track)
        end

        it { should have_link('delete this comment', href: comment_path(comment)) }
        describe "delete comment link" do
          it "should decrement comment author's comment count" do
            expect do
              click_link("delete this comment")
            end.to change(comment_author.comments, :count).by(-1)
          end
        end
      end
    end

    describe "signed in as track author" do
      before do
        sign_in track_author
        visit track_path(track)
      end

      it { should have_link('delete', href: track_path(track), method: :delete) }
      it { should have_link('edit', href: edit_track_path(track)) }
      
      describe "track delete link" do
        it "should decrement track author's track count" do
          expect do
            click_link("delete")
          end.to change(track_author.tracks, :count).by(-1)
        end
      end
    end
  end


  describe "edit" do

    let(:user) { FactoryGirl.create(:user) }
    let(:track) { FactoryGirl.create(:track, user: user) }

    before do
      sign_in user
      visit edit_track_path(track)
    end

    it { should have_selector("title", text: "Update Track") }

    describe "update with valid information" do
      let(:new_title) { Faker::Name.name }
      let(:new_description) { Faker::Lorem.paragraph(3) }

      before do
        fill_in "Title", with: new_title
        fill_in "Description", with: new_description
        click_button "Update!"
      end

      it { should have_selector('div.alert.alert-success') }
      it { should have_selector('title', text: 'Track') }
      it { should have_link(new_title, href: track_path(track)) }
      it { should have_selector('p', text: new_description) }

      specify { track.reload.title.should == new_title }
      specify { track.reload.description.should == new_description }
    end
  end
end

