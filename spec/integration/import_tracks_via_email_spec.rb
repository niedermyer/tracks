require 'integration/integration_spec_helper'

feature 'Importing Tracks via an Emailed GPX file', type: :feature do
  let!(:user) { create :user }
  let(:email) { build :incoming_email, to: to }
  let(:to) { [{
                full: user.processing_email,
                email: user.processing_email,
                token: user.public_id,
                host: EmailProcessor::PROCESSING_HOSTNAME,
                name: nil
              }] }

  scenario 'emails containing a GPX file from an existing user create new tracks' do
    # Sanity checks
    expect(Track.count).to eq 0
    clear_emails

    # Simulate Griddler when a new email comes in
    # Note: changes to config/initializers/griddler.rb will affect
    # this call (i.e. processor_class, processor_method )
    EmailProcessor.new(email).process

    expect(Track.count).to eq 1
    expect(TrackSegment.count).to eq 1
    expect(TrackPoint.count).to eq 3

    # Record is properly saved in database
    t = Track.last

    expect(t.user).to eq user
    expect(t.import_fingerprint).to eq '44eeb323d0321b18480d947db9797611'
    expect(t.name).to eq 'TEST TRACK from GPX FILE'
    t.segments[0].points.each do |point|
      expect(point.latitude).to be_present
      expect(point.longitude).to be_present
      expect(point.elevation_in_meters).to be_present
      expect(point.recorded_at).to be_present
    end

    # Email is sent to user
    # open_email(user.email)
    # expect(current_email.subject).to match /New track imported via emailed GPX/i
    # expect(current_email.body).to match /check out your new track/i
  end
end

