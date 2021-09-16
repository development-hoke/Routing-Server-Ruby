module JwtAuthenticator
  extend ActiveSupport::Concern
  require "jwt"
  SECRET_KEY = Rails.application.secrets.secret_key_base

  # jwt_authenticateを記載したコントローラにprepend_before_actionを定義する
  class_methods do
    def jwt_authenticate(**options)
      class_eval do
        prepend_before_action :jwt_authenticate!, options
      end
    end
  end

  def jwt_authenticate(token)
    if token.blank?
      raise UnableAuthorizationError.new("認証情報が不足しています。")
    end
    # JWTトークンの取り出し
    encoded_token = token.split.last
    # JWTトークンのデコード
    payload = decode(encoded_token)
    # インスタンス変数をセット
    @current_user = User.find_by(id: payload.values_at("user_id"))
    if @current_user.blank?
      raise UnableAuthorizationError.new("認証できません。")
    end
    @current_user
  end

  # 暗号化処理
  def encode(user_id)
    expires_in = 1.month.from_now.to_i
    preload = { user_id: user_id, exp: expires_in }
    JWT.encode(preload, SECRET_KEY, 'HS256')
  end

  # 復号化処理
  def decode(encoded_token)
    decoded_dwt = JWT.decode(encoded_token, SECRET_KEY, true, algorithm: 'HS256')
    decoded_dwt.first
  end

end