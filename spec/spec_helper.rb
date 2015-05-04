require 'coveralls'
Coveralls.wear!

require 'rspec-html-matchers'

RSpec.configure do |config|
  config.include RSpecHtmlMatchers
end

require 'rails'
require 'showcase'
require 'active_model'
require 'action_view'

require_relative './fixtures'

