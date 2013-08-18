require 'spec_helper'

describe Track do

  let(:user) { FactoryGirl.create(:user) }

  before do 
    @track = user.tracks.build(title: 'test123',
                     track_file: fixture_file_upload('/test.ogg', 'audio/ogg'))
  end
  subject { @track }

  it { should respond_to(:track_file) }
  it { should respond_to(:comments) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Track.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when user_id is not present" do
    before { @track.user_id = nil }
    it { should_not be_valid }
  end

  describe "when track_file is not present" do
    before { @track.track_file = nil }
    it { should_not be_valid }
  end
end

