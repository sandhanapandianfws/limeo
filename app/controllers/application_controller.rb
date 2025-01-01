class ApplicationController < ActionController::Base

  before_action :authenticate_request
  before_action :set_locale

  private
    def authenticate_request
      header = request.headers['Authorization']
      token = header.split(' ').last if header

      begin
        decoded_token = JsonWebToken.decode(token)
      rescue StandardError
        render json: { errors: ['Unauthorized access'] }, status: :unauthorized
      rescue JWT::ExpiredSignature
        render json: { errors: ['Token has expired'] }, status: :unauthorized
      rescue JWT::DecodeError
        render json: { errors: ['Invalid token'] }, status: :unauthorized
      end

      user_json = $redis.get(token)
      unless user_json
        render json: { errors: ['Unauthorized access'] }, status: :unauthorized and return
      end

      @current_user = User.find_by(id: decoded_token[:user_id])
      unless @current_user
        render json: { errors: ['Unauthorized access'] }, status: :unauthorized and return
      end
    end


  private

  def set_locale
    I18n.locale = extract_locale_from_header || I18n.default_locale
  end

  def extract_locale_from_header
    p I18n.available_locales
    locale = request.headers['Accept-Language']&.scan(/^[a-z]{2}/)&.first
    I18n.available_locales.map(&:to_s).include?(locale) ? locale : nil
  end

end
