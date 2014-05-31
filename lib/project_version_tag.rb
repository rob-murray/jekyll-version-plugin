module Jekyll
  class ProjectVersionTag < Liquid::Tag
    NO_GIT_MESSAGE = 'Oops, are you sure this is a git project?'
    UNABLE_TO_PARSE_MESSAGE = 'Sorry, could not read project version at the moment'

    def render(context)
      if git_repo?
        current_version.gsub("\n",'')
      else
        NO_GIT_MESSAGE
      end
    end

    private

    def current_version
      @_current_version ||= begin
        version = git_describe

        if version
          version
        else
          version = parse_head

          if version
            version
          else
            UNABLE_TO_PARSE_MESSAGE
          end
        end
      end
    end

    def git_describe
      tagged_version = %x{ git describe --tags }

      if command_succeeded?
        tagged_version
      end
    end

    def parse_head
      head_commitish = %x{ git rev-parse --short HEAD }

      if command_succeeded?
        head_commitish
      end
    end

    def command_succeeded?
      !$?.nil? && $?.success?
    end

    def git_repo?
      system('git rev-parse')
    end
  end
end

Liquid::Template.register_tag('project_version', Jekyll::ProjectVersionTag)
