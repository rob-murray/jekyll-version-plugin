# frozen_string_literal: true
module Jekyll
  module VersionPlugin
    # A Jekyll Tag type that renders a version identifier for your Jekyll site
    # sourced from the `git` repository containing your code.
    #
    class Tag < Liquid::Tag
      NO_GIT_MESSAGE          = "Oops, are you sure this is a git project?".freeze
      UNABLE_TO_PARSE_MESSAGE = "Sorry, could not read the project version at the moment".freeze
      OPTION_NOT_SPECIFIED    = nil
      PARAMS                  = [:type, :format].freeze

      attr_writer :system_wrapper # for testing

      # A wrapper around system calls; mock/stub this in testing
      class SystemWrapper
        def run(command)
          `#{command}`
        end

        def command_succeeded?
          !$?.nil? && $?.success?
        end

        def git_repo?
          system("git rev-parse")
        end
      end

      def initialize(_name, params, _tokens)
        super
        args    = params.split(/\s+/).map(&:strip)
        # TODO: When min Ruby version is >=2.1 just use `to_h`
        @params = Hash[PARAMS.zip(args)]
      end

      def render(_context)
        if git_repo?
          current_version.chomp
        else
          NO_GIT_MESSAGE
        end
      end

      private

      attr_reader :params

      # for testing
      def system_wrapper
        @system_wrapper ||= SystemWrapper.new
      end

      def current_version
        @_current_version ||= begin
          version = case params.fetch(:type, "tag")
                    when "tag", OPTION_NOT_SPECIFIED
                      git_describe || parse_head
                    when "commit"
                      parse_head
                    end

          version || UNABLE_TO_PARSE_MESSAGE
        end
      end

      def git_describe
        tagged_version = case params.fetch(:format, "short")
                         when "short", OPTION_NOT_SPECIFIED
                           run("git describe --tags --always")
                         when "long"
                           run("git describe --tags --always --long")
                         end

        tagged_version if command_succeeded?
      end

      def parse_head
        head_commitish = case params.fetch(:format, "short")
                         when "short", OPTION_NOT_SPECIFIED
                           run("git rev-parse --short HEAD")
                         when "long"
                           run("git rev-parse HEAD")
                         end

        head_commitish if command_succeeded?
      end

      def run(command)
        system_wrapper.run(command)
      end

      def git_repo?
        system_wrapper.git_repo?
      end

      def command_succeeded?
        system_wrapper.command_succeeded?
      end
    end
  end
end

Liquid::Template.register_tag("project_version", Jekyll::VersionPlugin::Tag)
