class JsonWebToken
  SECRET_KEY = Rails.application.secrets['jwt_secret_key']

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, 'HS512')
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true , { algorithm:'HS512' }).first
    HashWithIndifferentAccess.new decoded
  end
end