# frozen_string_literal: true
RSpec.describe Jekyll::VersionPlugin::Tag do
  GIT_LAST_COMMIT_COMMAND = "git rev-parse --short HEAD"

  GIT_DEFAULT_COMMAND     = "git describe --tags --always"

  GIT_TAG_LONG_COMMAND    = "git describe --tags --always --long"
  GIT_TAG_SHORT_COMMAND   = "git describe --tags --always"
  GIT_COMMIT_LONG_COMMAND   = "git rev-parse HEAD"
  GIT_COMMIT_SHORT_COMMAND  = "git rev-parse --short HEAD"
  let(:context) { double.as_null_object }

  subject { described_class.new(nil, options, nil) }
  let(:system_double) { double }
  let(:options) { "" }

  before do
    subject.system_wrapper = system_double
  end

  describe "Parsing options" do
    before do
      with_git_repo
    end

    context "with no options" do
      let(:options) { "" }

      it "use default command" do
        allow_call_to_succeed do
          expect(system_double).to receive(:run).with(GIT_DEFAULT_COMMAND).and_return("hash")
        end

        subject.render(context)
      end
    end

    context "with tag type" do
      context "with no format" do
        let(:options) { "tag" }

        it "use default command" do
          allow_call_to_succeed do
            expect(system_double).to receive(:run).with(GIT_DEFAULT_COMMAND).and_return("hash")
          end

          subject.render(context)
        end
      end

      context "with long format" do
        let(:options) { "tag long" }

        it "use correct command" do
          allow_call_to_succeed do
            expect(system_double).to receive(:run).with(GIT_TAG_LONG_COMMAND).and_return("hash")
          end

          subject.render(context)
        end
      end

      context "with short format" do
        let(:options) { "tag short" }

        it "use correct command" do
          allow_call_to_succeed do
            expect(system_double).to receive(:run).with(GIT_TAG_SHORT_COMMAND).and_return("hash")
          end

          subject.render(context)
        end
      end

      context "with no tag" do
        let(:options) { "tag short" }

        it "falls back to head command" do
          do_not_allow_call_to_succeed do
            allow(system_double).to receive(:run).with(GIT_TAG_SHORT_COMMAND)
          end

          allow_call_to_succeed do
            allow(system_double).to receive(:run).with(GIT_COMMIT_SHORT_COMMAND).and_return("hash")
          end

          subject.render(context)
        end
      end
    end

    context "with commit type" do
      context "with no format" do
        let(:options) { "commit" }

        it "use default command" do
          allow_call_to_succeed do
            expect(system_double).to receive(:run).with(GIT_COMMIT_SHORT_COMMAND).and_return("hash")
          end

          subject.render(context)
        end
      end

      context "with long format" do
        let(:options) { "commit short" }

        it "use correct command" do
          allow_call_to_succeed do
            expect(system_double).to receive(:run).with(GIT_COMMIT_SHORT_COMMAND).and_return("hash")
          end

          subject.render(context)
        end
      end

      context "with short format" do
        let(:options) { "commit long" }

        it "use correct command" do
          allow_call_to_succeed do
            expect(system_double).to receive(:run).with(GIT_COMMIT_LONG_COMMAND).and_return("hash")
          end

          subject.render(context)
        end
      end
    end
  end

  describe "return message" do
    context "no git repository" do
      before do
        allow(system_double).to receive(:git_repo?).and_return(false)
      end

      it "returns an error message" do
        expect(subject.render(context)).to match(/Oops/)
      end
    end

    context "a git repository with no commits" do
      before do
        with_git_repo
        do_not_allow_call_to_succeed do
          allow(system_double).to receive(:run).with(GIT_DEFAULT_COMMAND).and_return(false)
        end

        do_not_allow_call_to_succeed do
          allow(system_double).to receive(:run).with(GIT_LAST_COMMIT_COMMAND).and_return(false)
        end
      end

      it "returns an unable to read project message" do
        expect(subject.render(context)).to match(/could not read the project version/)
      end
    end

    context "with tag type" do
      before do
        with_git_repo
      end
      let(:options) { "tag" }

      it "returns response" do
        allow_call_to_succeed do
          allow(system_double).to receive(:run).with(GIT_DEFAULT_COMMAND).and_return("tag-hash")
        end

        expect(subject.render(context)).to eq "tag-hash"
      end
    end

    context "with commit type" do
      before do
        with_git_repo
      end
      let(:options) { "commit" }

      it "returns response" do
        allow_call_to_succeed do
          allow(system_double).to receive(:run).with(GIT_COMMIT_SHORT_COMMAND).and_return("commit-hash")
        end

        expect(subject.render(context)).to eq "commit-hash"
      end
    end

    it "removes line ending from parsed value" do
      with_git_repo
      allow_call_to_succeed do
        allow(system_double).to receive(:run).with(GIT_DEFAULT_COMMAND).and_return("tag-hash\n")
      end

      expect(subject.render(context)).to eq "tag-hash"
    end
  end

  private

  def with_git_repo
    allow(system_double).to receive(:git_repo?).and_return(true)
  end

  def allow_call_to_succeed
    yield
    allow(system_double).to receive(:command_succeeded?).and_return(true)
  end

  def do_not_allow_call_to_succeed
    yield
    allow(system_double).to receive(:command_succeeded?).and_return(false)
  end
end
