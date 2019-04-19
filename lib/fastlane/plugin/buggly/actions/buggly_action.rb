require 'pathname'
require 'fileutils'
module Fastlane
  module Actions
    module SharedValues
    end

    class BugglyAction < Action
      def self.run(params)
        unless Helper.test?
          UI.user_error!("curl not installed") if `which curl`.length == 0
        end
        
        filename = params[:dymZipFile].split("/").last
        dsymUzip =  "#{Pathname.new(params[:dymZipFile]).dirname}/#{filename.gsub!(".app.dSYM.zip", "")}"
        command = "unzip -o #{params[:dymZipFile]} -d '#{dsymUzip}'"
        Fastlane::Actions.sh(command, log: false)
        dsymFileName = sh "ls #{dsymUzip} | grep -e 'app.dSYM'"
        command = "java -jar ~/bin/buglySymboliOS.jar -u -id #{params[:appId]} -key #{params[:appKey]} -package #{params[:bundleId]} -version #{params[:appVersion]} -i #{dsymUzip}/#{dsymFileName}"
        result = Fastlane::Actions.sh(command, log: true)
        FileUtils.rm_r "#{dsymUzip}" if dsymUzip.length>0
        UI.success "Success to upload the dSYM for the app [#{params[:bundleId]} #{params[:appVersion]}]"

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload the dSYM file to Buggly crash analyze system."
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "More information can be found on https://github.com/lvdaqian/fastlane-buggly.git"
      end

      def self.available_options

        [
          FastlaneCore::ConfigItem.new(key: :appId,
                                       env_name: "BUGGLY_APP_ID", # The name of the environment variable
                                       description: "APP ID for Buggly", # a short description of this parameter
                                       default_value:CredentialsManager::BugglyAppfileConfig.try_fetch_value(:buggly_app_id),
                                       verify_block: proc do |value|
                                          UI.user_error!("No APP ID for Buggly given, pass using `appId: 'appId'`, you can find it in your buggly app settings.") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :appKey,
                                       env_name: "BUGGLY_APP_KEY", # The name of the environment variable
                                       description: "APP Key for Buggly", # a short description of this parameter
                                       default_value:CredentialsManager::BugglyAppfileConfig.try_fetch_value(:buggly_app_key),
                                       verify_block: proc do |value|
                                          UI.user_error!("No APP Key for Buggly given, pass using `appKey: 'appKey'`, you can find it in your buggly app settings.") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :bundleId,
                                       env_name: "BUGGLY_APP_BUNDLE_ID", # The name of the environment variable
                                       description: "The app's bundle indentifier", # a short description of this parameter
                                       default_value:CredentialsManager::BugglyAppfileConfig.try_fetch_value(:app_identifier),
                                       verify_block: proc do |value|
                                          UI.user_error!("No APP bundle id for the app given, pass using `bundleId: 'bundleId'`, the same as app_identifier in APPConfigFile") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :appVersion,
                                       env_name: "BUGGLY_APP_VERSION", # The name of the environment variable
                                       description: "APP Version to indentify dSYM file", # a short description of this parameter
                                       default_value: "#{Actions.lane_context[SharedValues::VERSION_NUMBER]}(#{Actions.lane_context[SharedValues::BUILD_NUMBER]})" 
                                       ),
          FastlaneCore::ConfigItem.new(key: :dymZipFile,
                                       env_name: "BUGGLY_BSYMBOL_ZIP_FILE", # The name of the environment variable
                                       description: "The dSYM zip file path", # a short description of this parameter
                                       default_value: Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH],
                                       verify_block: proc do |value|
                                          UI.user_error!("DSYM zip file path, pass using `dymZipFile: 'dymZipFile'`") unless (value and not value.empty?)
                                          UI.user_error!("dsym file not found") if !Helper.test? && !File.exist?(value)
                                          UI.user_error!("dsym file must be a valid zip file") unless File.size(value) > 1
                                       end)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["lvdaqian@gmail.com"]
      end

      def self.is_supported?(platform)

        platform == :ios
      end
    end
  end
end

