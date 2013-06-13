class AddActiveToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :active, :boolean, default: true
  end
end
