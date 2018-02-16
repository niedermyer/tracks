require 'component/component_spec_helper'

describe Importers::TrackImporter do
  subject(:importer) { Importers::TrackImporter.new(filename, user) }
  let(:user) { create :user }
  let(:filename) { fixture 'track.gpx' }

  describe '#initialize' do
    it 'accepts a filename and a user' do
      expect(Importers::TrackImporter.new('file.gpx', user).filename).to eq 'file.gpx'
      expect(Importers::TrackImporter.new('file.gpx', user).user).to eq user
    end
  end

  describe '#import!' do
    it 'inserts a Track, TrackSegment and TrackPoints for each trk in the given file' do
      expect {
        importer.import!
      }.to change {
        TrackPoint.count
      }.by 3

      Track.find_by(name: 'TEST TRACK from GPX FILE').tap do |track|
        expect(track.user).to eq user
        expect(track.import_fingerprint).to eq '44eeb323d0321b18480d947db9797611'
        track.segments[0].points.each_with_index do |point, i|
          expect(point.latitude).to eq BigDecimal("40.00000#{i}")
          expect(point.longitude).to eq BigDecimal("-77.00000#{i}")
          expect(point.elevation_in_meters).to eq BigDecimal("30#{i}.000000")
          expect(point.recorded_at).to eq Time.zone.local(2018, 1, 31, 14, 00, "#{i}0".to_i )
        end
      end
    end
  end
end