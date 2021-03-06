def fixture(name)
  ROOT.join('spec', 'fixtures', name)
end

def fixture_file_upload(filename, mime_type)
  Rack::Test::UploadedFile.new(fixture(filename), mime_type)
end

def store_fixture_file(uploader, filename)
  uploader.store!(
    File.open(
      fixture filename
    )
  )
end

def open_image version
  path = uploader.send(version).file.path
  MiniMagick::Image.open(path)
end

def open_fixture_file(name)
  File.open(fixture(name))
end
