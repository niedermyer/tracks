class EmailProcessor

  PROCESSING_HOSTNAME = 'parse-activity.niedermyer.tech'

  def initialize email
    @email = email
  end

  def process
    relevant_to_addresses.each do |to_address|
      begin
        user = User.find_by!(public_id: to_address[:token])
      rescue ActiveRecord::RecordNotFound
        Rails.logger.info( "EmailProcessorFailedAttempt::UserNotFound [#{email_md5}] to: #{to_address[:full]}" )
      end
    end

    Rails.logger.info( "EmailProcessorFailedAttempt::UserNotFound [#{email_md5}] email: #{email.inspect}" )

  end

  private

  attr_accessor :email

  def relevant_to_addresses
    @relevant_to_addresses ||= email.to.select{|address| address[:host] == PROCESSING_HOSTNAME}
  end

  def email_md5
    @email_md5 ||= Digest::MD5.hexdigest email.inspect
  end
end