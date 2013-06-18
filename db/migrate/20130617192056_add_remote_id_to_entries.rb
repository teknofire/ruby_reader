class AddRemoteIdToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :remote_id, :text
  end
end
