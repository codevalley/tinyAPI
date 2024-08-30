class AddViewedAtToPayloads < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:payloads, :viewed_at)
      add_column :payloads, :viewed_at, :datetime
    end
  end
end
