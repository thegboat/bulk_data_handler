$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bulk_data_handler'
require 'factory_girl'
require 'rspec'
require 'database_cleaner'
require 'awesome_print'
require 'pry'
require 'pg'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end


ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'bulk_data_handler_test',
  host: 'localhost',
  username: 'postgres'
)

table_exists = !!ActiveRecord::Base.connection.select_value(%{
   SELECT 1
   FROM   information_schema.tables 
   WHERE  table_schema = 'public'
   AND    table_name = 'test_models'
;})

unless table_exists
  ActiveRecord::Migration.create_table :test_models, :force => true do |t|
    t.string :name, null: false
    t.integer :age
    t.decimal :weight, null: false, precision: 4, scale: 2
  end
end

class TestModel < ActiveRecord::Base

end
