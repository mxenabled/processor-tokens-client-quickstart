class AddExternalIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :external_id, :string
  end
end
