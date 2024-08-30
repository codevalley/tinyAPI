class PayloadService
  class << self
    def create(params, client_token)
      payload = Payload.new(params.merge(client_token: client_token))
      payload.save!
      payload
    end

    def update(hash, params, client_token)
      payload = find_payload(hash, client_token)
      payload.update!(params.except(:client_token))
      payload
    end

    def find(hash, client_token)
      payload = find_payload(hash, client_token)
      payload.update_column(:viewed_at, Time.current)
      payload
    end

    private

    def find_payload(hash, client_token)
      Payload.find_by!(hash_id: hash)
    end
  end
end
