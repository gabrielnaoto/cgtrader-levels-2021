require 'active_record'
require 'rspec'

RSpec.configure do |config|
  config.before :suite do
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: ':memory:'
    )

    ActiveRecord::Base.connection.create_table :users do |table|
      table.string :username
      table.integer :reputation, default: 0
      table.decimal :coins, default: 0
      table.decimal :tax, default: 30
      table.references :level
    end

    ActiveRecord::Base.connection.create_table :levels do |table|
      table.string :title
      table.integer :experience
      table.decimal :bonus_coins
      table.decimal :tax_reduction
    end
  end
end
