class EmailProcessor
  class UserNotFound < RuntimeError
    def initialize(message="No user found with given public_id.")
      super(message)
    end
  end

  class AttachmentNotFound < RuntimeError
    def initialize(message="Could not find any email attachments.")
      super(message)
    end
  end

  class UnprocessableAttachment < RuntimeError
    def initialize(message="None of the attached files were of correct type.")
      super(message)
    end
  end

  PROCESSING_HOSTNAME = 'parse-activity.niedermyer.tech'

  def initialize email
    @email = email
  end

  def process
    errors = []

    relevant_to_address_tokens.each do |token|
      begin
        user = User.find_by!(public_id: token)
        file = gpx_file
      rescue ActiveRecord::RecordNotFound
        errors << {object: UserNotFound.new, token: token}
      rescue AttachmentNotFound => e
        errors << {object: e, token: token}
      rescue UnprocessableAttachment => e
        errors << {object: e, token: token}
      end
    end

    if errors.any?
      errors.each do |e|
        log_error_message(e[:object], "given_public_id: #{e[:token]}")
      end
      log_error_message(errors.first[:object], "email_attributes: #{email_attributes}")
    end
  end

  private

  attr_accessor :email

  def relevant_to_address_tokens
    @relevant_to_address_tokens ||= relevant_to_addresses.map{|to| to[:token] }
  end

  def relevant_to_addresses
    @relevant_to_addresses ||= email.to.select{|address| address[:host] == PROCESSING_HOSTNAME}
  end

  def gpx_file
    raise AttachmentNotFound.new if email.attachments.empty?
    @gpx_file ||= email.attachments.select{ |a| a.content_type == 'application/gpx+xml' }.first || raise(UnprocessableAttachment.new)
  end

  def email_md5
    @email_md5 ||= Digest::MD5.hexdigest email.inspect
  end

  def log_error_message(error, additional_message)
    Rails.logger.warn( "#{error.class} [#{email_md5}] #{error.message} #{additional_message}" )
  end

  def email_attributes
    output = "\n"
    output += "TO: #{email.to.map{|to| to[:full]}}\n"
    output += "FROM: #{email.from[:full]}\n"
    output += "CC: #{email.cc}\n"
    output += "SUBJECT: #{email.subject}\n"
    output += "BODY (above delimiter): #{email.body}\n"
    output += "ATTACHMENTS: #{email.attachments}\n"
    output += "RAW BODY: #{email.raw_body}\n"
    output += "HEADERS: #{email.headers}\n"
    output
  end
end