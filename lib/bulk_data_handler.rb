require 'active_record'

require 'bulk_data_handler/mass_creator'
require 'bulk_data_handler/mass_updater'
require 'bulk_data_handler/active_record_ext'


require "bulk_data_handler/version"

module BulkDataHandler
  # Your code goes here...
end

ActiveRecord::Base.send(:extend, BulkDataHandler::ActiveRecordExt)


