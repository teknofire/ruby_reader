class UpdateUrlsToTextFields < ActiveRecord::Migration
  def up
    change_table :entries do |t|
	t.change :url, :text
    end
    change_table :feeds do |t|
	t.change :url, :text
    end
  end

  def down
    change_column :entries, :url, :string
    change_column :feeds, :url, :string
  end
end
