module JsonWebToken
  SECRET_KEY = Rails.application.secret_key_base

  # Encode payload into JWT
  def self.encode(payload, exp = 30.minutes.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # Decode JWT token
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    nil
  rescue JWT::ExpiredSignature
    nil
  end
end
