module Jekyll
  module VersionPlugin
    # A Jekyll Tag type that renders a version identifier for your Jekyll site
    # sourced from the `git` repository containing your code.
    #
    class Tag < Liquid::Tag
      NO_GIT_MESSAGE          = 'Oops, are you sure this is a git project?'.freeze
      UNABLE_TO_PARSE_MESSAGE = 'Sorry, could not read the project version at the moment'.freeze

      def initialize(_name, params, _tokens)
        super
        args      = params.split(/\s+/).map(&:strip)
        # @api_type = args.shift
        @params   = [:type, :format].zip(args).to_h
      end

      def render(_context)
        if git_repo?
          current_version.chomp
        else
          NO_GIT_MESSAGE
        end
      end

      private

      def current_version
        #puts @params
        @_current_version ||= begin
          version = case @params.fetch(:type, "tags")
          when "tags"
            git_describe || parse_head
          when "head"
            parse_head
          else
            parse_head
          end

          version || UNABLE_TO_PARSE_MESSAGE
        end
      end

      def git_describe
        if @params.fetch(:format, "short") == "long"
          tagged_version = `git describe --tags --always --long`
          #puts "1"
        else
          tagged_version = `git describe --tags --always`
          #puts "2"
        end

        tagged_version if command_succeeded?
      end

      def parse_head
        if @params.fetch(:format, "short") == "long"
          head_commitish = `git rev-parse HEAD`
          #puts "3"
        else
          head_commitish = `git rev-parse --short HEAD`
          #puts "4"
        end

        head_commitish if command_succeeded?
      end

      def command_succeeded?
        !$?.nil? && $?.success?
      end

      def git_repo?
        system('git rev-parse')
      end
    end
  end
end

Liquid::Template.register_tag('project_version', Jekyll::VersionPlugin::Tag)
