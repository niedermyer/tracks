def dom_id_selector(object)
  "##{dom_id object}"
end

RSpec.configure do |config|
  config.include ActionView::RecordIdentifier, type: :feature
end