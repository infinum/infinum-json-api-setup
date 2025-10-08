module Api
  module V1
    class HelloController < BaseController
      # GET /api/v1/hello
      def index
        message = I18n.t('hello')
        render json: { data: { type: 'hello', attributes: { message: message } } }
      end
    end
  end
end
