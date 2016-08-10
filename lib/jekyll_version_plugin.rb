module Jekyll
  module VersionPlugin
    # A Jekyll Tag type that renders a version identifier for your Jekyll site
    # sourced from the `git` repository containing your code.
    #
    class Tag < Liquid::Tag
      NO_GIT_MESSAGE          = 'Oops, are you sure this is a git project?'.freeze
      UNABLE_TO_PARSE_MESSAGE = 'Sorry, could not read the project version at the moment'.freeze

      def render(_context)
        if git_repo?
          current_version.chomp
        else
          NO_GIT_MESSAGE
        end
      end

      private

      def current_version
        @_current_version ||= begin
          # attempt to find the latest tag, falling back to last commit
          version = git_describe || parse_head

          version || UNABLE_TO_PARSE_MESSAGE
        end
      end

      def git_describe
        tagged_version = `git describe --tags --always`

        tagged_version if command_succeeded?
      end

      def parse_head
        head_commitish = `git rev-parse --short HEAD`

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
