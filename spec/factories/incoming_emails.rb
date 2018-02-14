FactoryBot.define do
  factory :incoming_email, class: OpenStruct do
    to [
         {
           full: "user_public_id@#{EmailProcessor::PROCESSING_HOSTNAME}",
           email: "user_public_id@#{EmailProcessor::PROCESSING_HOSTNAME}",
           token: "user_public_id",
           host: EmailProcessor::PROCESSING_HOSTNAME,
           name: nil
         },
         {
           full: "bogus@#{EmailProcessor::PROCESSING_HOSTNAME}",
           email: "bogus@#{EmailProcessor::PROCESSING_HOSTNAME}",
           token: "bogus",
           host: EmailProcessor::PROCESSING_HOSTNAME,
           name: nil
         }
       ]
    from({
           token: 'from_user',
           host: 'example.com',
           email: 'from_email@example.com',
           full: 'From User <from_user@example.com>',
           name: 'From User'
         })
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