class CreatePayloads < ActiveRecord::Migration[7.2]
  def change
    create_table :payloads do |t|
      t.string :hash_id, null: false, index: { unique: true }
      t.text :content, null: false
      t.string :mime_type, null: false, default: 'text/plain'
      t.datetime :expiry_time, null: false
      t.datetime :viewed_at

      t.timestamps
    end
  end
end