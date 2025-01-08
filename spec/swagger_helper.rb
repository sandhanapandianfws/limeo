# spec/swagger_helper.rb
require 'rswag/specs'

RSpec.configure do |config|
  # Enables or disables the dry run (can be useful for debugging)
  config.swagger_dry_run = false
end
