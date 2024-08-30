class AddClientTokenToPayloads < ActiveRecord::Migration[7.2]
  def change
    add_column :payloads, :client_token, :string
  end
end
