# encoding: utf-8

require_relative './util/http'
require_relative './util/config'
require_relative './util/parser'
require_relative './util/login'
require_relative './util/me'
require_relative './util/info'
require_relative './util/build'
require_relative './util/publish'
require_relative './util/mapping'

module FIR
  module Util
    extend ActiveSupport::Concern

    module ClassMethods
      include FIR::Http
      include FIR::Config
      include FIR::Login
      include FIR::Me
      include FIR::Info
      include FIR::Build
      include FIR::Publish
      include FIR::Mapping

      attr_accessor :logger

      def fetch_user_info token
        get fir_api[:user_url], api_token: token
      end

      def check_supported_file path
        unless File.file?(path) || APP_FILE_TYPE.include?(File.extname(path))
          logger.error "File does not exist or unsupported file type"
          exit 1
        end
      end

      def check_token_cannot_be_blank token
        if token.blank?
          logger.error "Token can't be blank"
          exit 1
        end
      end

      def check_logined
        if current_token.blank?
          logger.error "Please use `fir login` first"
          exit 1
        end
      end

      def logger_info_dividing_line
        logger.info "✈ -------------------------------------------- ✈"
      end
    end
  end
end
