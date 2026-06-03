# frozen_string_literal: true

module Sjma
  module MemberAuth
    module_function

    def normalize_dni(value)
      value.to_s.upcase.gsub(/[^A-Z0-9]/, "")
    end

    def dni_like?(value)
      normalized = normalize_dni(value)
      normalized.length.between?(6, 12) && normalized.match?(/[0-9]/) && !normalized.include?("@")
    end

    def dni_digest(value)
      normalized = normalize_dni(value)
      return if normalized.blank?

      OpenSSL::HMAC.hexdigest("SHA256", hmac_secret, normalized)
    end

    def dni_last4(value)
      normalize_dni(value).last(4)
    end

    def hmac_secret
      ENV["SJMA_DNI_HMAC_SECRET"].presence || local_hmac_secret || Rails.application.secret_key_base
    end

    def provisional_password?
      ENV["SJMA_FORCE_PASSWORD_CHANGE_ON_IMPORT"] != "false"
    end

    def local_hmac_secret
      path = Rails.root.join("local/member-auth.env")
      return unless path.exist?

      path.read.lines.find { |line| line.start_with?("SJMA_DNI_HMAC_SECRET=") }&.split("=", 2)&.last&.strip
    end
  end
end
