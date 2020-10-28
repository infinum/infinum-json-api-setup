module InfinumJsonApiSetup
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc 'Copy default translations'

      def copy_locale
        copy_file 'config/locales/json_api.en.yml', 'config/locales/json_api.en.yml'
      end
    end
  end
end
