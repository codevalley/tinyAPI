class CreatePayloads < ActiveRecord::Migration[7.2]
  def change
    create_table :payloads do |t|
      t.string :hash_id
      t.text :content
      t.string :mime_type
      t.datetime :expiry_time
      t.datetime :viewed_at

      t.timestamps
    end
  end
end
