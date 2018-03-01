require 'component/component_spec_helper'

describe Importers::TrackImporter do
  subject(:importer) { Importers::TrackImporter.new(filename, user) }
  let(:user) { create :user }
  let(:filename) { fixture 'track.gpx' }
  let(:md5) { '665883018cce3116fca9e6b93cf0444d' }
  let(:imported_result) { double 'imported track import result' }

  before do
    allow(SuccessfulTrackImportResult).to receive(:new).with(instance_of(Track)).and_return imported_result
  end

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
        expect(track.import_fingerprint).to eq md5
        track.segments[0].points.each_with_index do |point, i|
          expect(point.latitude).to eq BigDecimal("40.00000#{i}")
          expect(point.longitude).to eq BigDecimal("-77.00000#{i}")
          expect(point.elevation_in_meters).to eq BigDecimal("30#{i}.000000")
          expect(point.recorded_at).to eq Time.zone.local(2018, 1, 31, 14, 00, "#{i}0".to_i )
        end
      end
    end

    it 'returns an array of TrackImportResults' do
      expect(importer.import!).to eq [imported_result]
    end
  end


  context 'when run twice' do
    let(:ignored_result) { double 'ignored track import result' }

    before do
      allow(IgnoredDuplicateTrackImportResult).to receive(:new).with(instance_of(Track)).and_return ignored_result
    end

    it 'is idempotent' do
      importer.import!
      expect {
        importer.import!
      }.not_to change{
        TrackPoint.count
      }
    end

    it 'does not overwrite existing attributes' do
      importer.import!

      # Find an track point created by the import and sanity check
      point = TrackPoint.find_by(latitude: BigDecimal('40.000000'))
      expect(point.longitude).to eq BigDecimal('-77.000000')
      expect(point.elevation_in_meters).to eq BigDecimal('300.000000')
      expect(point.recorded_at).to eq Time.zone.local(2018, 1, 31, 14, 00, 00)

      # Update the record
      point.update_column(:latitude, BigDecimal('22.000000'))
      point.update_column(:longitude, BigDecimal('-88.000000'))
      point.update_column(:elevation_in_meters, BigDecimal('0.000000'))
      point.update_column(:recorded_at, Time.zone.local(2017, 2, 1, 00, 00, 00))

      # Re-import
      importer.import!
      point.reload

      expect(point.latitude).to eq BigDecimal('22.000000')
      expect(point.longitude).to eq BigDecimal('-88.000000')
      expect(point.elevation_in_meters).to eq BigDecimal('0.000000')
      expect(point.recorded_at).to eq Time.zone.local(2017, 2, 1, 00, 00, 00)
    end

    it 'returns an array of TrackImportResults' do
      importer.import!
      expect(importer.import!).to eq [ignored_result]
    end
  end

end