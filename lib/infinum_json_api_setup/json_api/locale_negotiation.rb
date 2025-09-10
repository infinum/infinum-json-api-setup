module InfinumJsonApiSetup
  module JsonApi
    module LocaleNegotiation
      extend ActiveSupport::Concern

      included do
        around_action :setup_locale
      end

      def rescue_with_handler(*)
        # Must render error in valid locale
        valid_locale = locale_valid?(locale) ? locale : I18n.default_locale
        I18n.with_locale(valid_locale) { super }
      end

      private

      def setup_locale(&action)
        I18n.with_locale(locale, &action)
      end

      def locale
        (locale_from_request.presence || I18n.default_locale).to_s
      end

      def locale_valid?(locale)
        I18n.available_locales.map(&:to_s).include?(locale)
      end

      def locale_from_request
        accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
        return unless accept_language

        accept_language.scan(/^[a-z]{2}/).first
      end
    end
  end
end
