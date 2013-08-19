require 'spec_helper'

describe Comment do
  let(:user) { FactoryGirl.create(:user) }

  before do 
    @track = user.tracks.new(
                     title: 'test123',
                     track_file: fixture_file_upload('/test.ogg', 'audio/ogg'))
    @track.save
    @comment = user.comments.build(content: "test comment", track_id: @track.id)
  end

  subject { @comment }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:track_id) }

  its(:user) { should == user }
  its(:track) { should == @track }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Comment.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when user_id is not present" do
    before { @comment.user_id = nil }
    it { should_not be_valid }
  end

  describe "content" do
    describe "when content is not present" do
      before { @comment.content = nil }
      it { should_not be_valid }
    end

    describe "when content is too long" do
      before { @comment.content = "a" * 2001 }
      it { should_not be_valid }
    end

    describe "when content is blank" do
      before { @comment.content = "" }
      it { should_not be_valid }
    end

  end
end
