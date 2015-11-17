class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file
      t.integer :attachmentable_id
      t.string :attachmentable_type

      t.timestamps null: false
    end

    add_index :attachments, [:attachmentable_id, :attachmentable_type]
  end
end
