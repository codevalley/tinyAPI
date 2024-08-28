class AddIndexToPayloads < ActiveRecord::Migration[7.2]
  def change
    add_index :payloads, :id
  end
end
