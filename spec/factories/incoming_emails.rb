FactoryBot.define do
  factory :incoming_email, class: OpenStruct do
    to [{ full: 'to_user@inbox.com',
          email: 'to_user@inbox.com',
          token: 'to_user',
          host: 'inbox.com',
          name: nil }]
    from({ token: 'from_user',
           host: 'example.com',
           email: 'from_email@example.com',
           full: 'From User <from_user@example.com>',
           name: 'From User' })
    subject 'email subject'
    body 'sent from my phone'
    attachments { [
      ActionDispatch::Http::UploadedFile.new({
                                               filename: 'track.gpx',
                                               type: 'application/gpx+xml',
                                               tempfile: File.new(fixture('track.gpx'))
                                             })
    ] }

    trait :with_no_attachments do
      attachments { [] }
    end

    trait :with_other_attachment do
      attachments { [
        ActionDispatch::Http::UploadedFile.new({
                                                 filename: 'rails.jpeg',
                                                 type: 'image/jpeg',
                                                 tempfile: File.new(fixture('rails.jpeg'))
                                               })
      ] }
    end
  end
end