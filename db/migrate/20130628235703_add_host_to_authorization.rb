class AddHostToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :host, :string
  end
end
