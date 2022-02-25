# frozen_string_literal: true

# Initial creation of users table (now deprecated)
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password

      t.timestamps
    end
  end
end
