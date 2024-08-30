require "ostruct"

class PayloadService
  MAX_CONTENT_SIZE = 1.megabyte

  def self.create(params, client_token)
    payload = Payload.new(params.merge(client_token: client_token))
    payload.hash_id = generate_unique_hash

    if payload.content && payload.content.bytesize > MAX_CONTENT_SIZE
      return OpenStruct.new(success?: false, errors: [ "Content is too large" ])
    end

    if payload.save
      OpenStruct.new(success?: true, payload: payload)
    else
      OpenStruct.new(success?: false, errors: payload.errors.full_messages)
    end
  end

  def self.update(hash_id, params, client_token)
    payload = Payload.find_by(hash_id: hash_id, client_token: client_token)
    return OpenStruct.new(success?: false, errors: [ "Payload not found" ]) unless payload

    if payload.update(params)
      OpenStruct.new(success?: true, payload: payload)
    else
      OpenStruct.new(success?: false, errors: payload.errors.full_messages)
    end
  end

  def self.find(hash_id, client_token)
    payload = Payload.find_by(hash_id: hash_id, client_token: client_token)
    if payload && payload.expiry_time > Time.current
      payload.update(viewed_at: Time.current)
      payload
    else
      nil
    end
  end

  private

  def self.generate_unique_hash
    loop do
      hash = SecureRandom.alphanumeric(8)
      break hash unless Payload.exists?(hash_id: hash)
    end
  end
end
