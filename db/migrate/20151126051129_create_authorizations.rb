class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :provider
      t.string :uid

      t.timestamps null: false
    end

    add_index :authorizations, [:provider, :uid]
  end
end
