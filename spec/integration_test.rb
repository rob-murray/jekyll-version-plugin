# frozen_string_literal: true
# Basic integration example - run code against a dummy repo
#
# * Requires git configured on the machine.
#
# Create a tmp dir and create a dummy git repo, run code at various stages,
# eg no commits, a commit, a tag, etc.
#
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require_relative "./support/jekyll_template"
require "jekyll_version_plugin"
require "tmpdir"

RUN_OPTIONS = [
  "",
  "tags long",
  "tags short",
  "head long",
  "head short"
].freeze

def run_code_with_options(message)
  say_with_colour message, :green

  RUN_OPTIONS.each do |options|
    say_with_colour "Running with options: '#{options}'", :blue
    tag = Jekyll::VersionPlugin::Tag.new(nil, options, nil)
    say_with_colour tag.render(nil), :yellow
  end
end

COLOUR_MAP = {
  red: 31,
  green: 32,
  yellow: 33,
  blue: 34
}.freeze

def say_with_colour(text, colour_name)
  colour_code = COLOUR_MAP.fetch(colour_name)
  puts "\e[#{colour_code}m#{text}\e[0m"
end

def run_commands(message)
  say_with_colour message, :red
  yield
end

def main
  Dir.mktmpdir("jekyll_version_plugin_test") do |dir|
    say_with_colour "Created temp dir: #{dir}", :red
    Dir.chdir(dir) do
      run_code_with_options ">> Without git repo"

      run_commands("** Creating git repo") { `git init .` }

      run_code_with_options ">> With git repo"

      run_commands("** Adding file") do
        File.open("test-file.txt", "w") do |f|
          f.write("this is some text\n")
        end
        `git add -A`
        `git commit -m"first commit"`
      end

      run_code_with_options ">> With a commit"

      run_commands("** Creating tag") { `git tag -a v1 -m"first tag"` }

      run_code_with_options ">> With tag"

      run_commands("** Updating file") do
        File.open("test-file.txt", "w") do |f|
          f.write("this is some more text\n")
        end
        `git add -A`
        `git commit -m"another commit"`
      end

      run_code_with_options ">> With a commit after the tag"

      run_commands("** Creating tag again") { `git tag -a v2 -m"second tag"` }

      run_code_with_options ">> With a commit after the tag"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  say_with_colour "Running integration tests...", :red
  main
end
