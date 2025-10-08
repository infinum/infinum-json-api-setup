module InfinumJsonApiSetup
  module JsonApi
    module LocaleNegotiation
      extend ActiveSupport::Concern

      included do
        around_action :setup_locale
        class_attribute :fallback_to_default_locale_if_invalid, default: false
      end

      def rescue_with_handler(*)
        I18n.with_locale(locale) { super }
      end

      private

      def setup_locale(&)
        return render_invalid_locale_error if locale.blank?

        I18n.with_locale(locale, &)
      end

      def locale
        return I18n.default_locale if locale_from_request.blank?

        parsed_locale = AcceptLanguage.parse(locale_from_request).match(*I18n.available_locales)

        if parsed_locale.present?
          parsed_locale
        elsif fallback_to_default_locale_if_invalid
          I18n.default_locale
        end
      end

      def locale_from_request
        request.env['HTTP_ACCEPT_LANGUAGE']
      end

      def render_invalid_locale_error
        message = I18n.t('json_api.errors.bad_request.invalid_locale')
        render_error(InfinumJsonApiSetup::Error::BadRequest.new(message:))
      end
    end
  end
end
