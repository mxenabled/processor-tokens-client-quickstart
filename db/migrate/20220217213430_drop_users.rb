# frozen_string_literal: true

# Remove the table completely, no table needed
class DropUsers < ActiveRecord::Migration[7.0]
  def change
    drop_table :users
  end
end
