FactoryBot.define do
  factory :incoming_email, class: OpenStruct do
    to [
         {
           full: "first_token@#{EmailProcessor::PROCESSING_HOSTNAME}",
           email: "first_token@#{EmailProcessor::PROCESSING_HOSTNAME}",
           token: "first_token",
           host: EmailProcessor::PROCESSING_HOSTNAME,
           name: nil
         },
         {
           full: "second_token@#{EmailProcessor::PROCESSING_HOSTNAME}",
           email: "second_token@#{EmailProcessor::PROCESSING_HOSTNAME}",
           token: "second_token",
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

    trait :with_other_attachments do
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