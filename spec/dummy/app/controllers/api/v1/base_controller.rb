module Api
  module V1
    class BaseController < ApplicationController
      include InfinumJsonApiSetup::JsonApi::ErrorHandling
      include InfinumJsonApiSetup::JsonApi::ContentNegotiation

      self.responder = InfinumJsonApiSetup::JsonApi::Responder
      respond_to :json_api
    end
  end
end
