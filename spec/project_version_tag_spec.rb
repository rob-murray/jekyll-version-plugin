RSpec.describe Jekyll::ProjectVersionTag do
  let(:git_test_command) { 'git rev-parse' }
  let(:git_tag_command) { ' git describe --tags --always ' }
  let(:git_last_commit_command) { ' git rev-parse --short HEAD ' }
  let(:context) { nil }

  subject { Jekyll::ProjectVersionTag.new }

  before do
    allow(subject).to receive(:system).and_return(true)
  end

  context 'given no git repository' do
    before do
      allow(subject).to receive(:system).with(git_test_command).and_return(nil)
    end

    it 'returns an error message' do
      expect(subject.render(context)).to match(/Oops/)
    end
  end

  context 'given a git repository with no commits' do
    before do
      allow(subject).to receive(:`).with(git_last_commit_command).and_return(nil)
      allow(subject).to receive(:`).with(git_tag_command).and_return(nil)
      allow(subject).to receive(:command_succeeded?).and_return(true)
    end

    it 'returns an unable to read project message' do
      expect(subject.render(context)).to match(/could not read project version/)
    end
  end

  context 'given a git repository with a commit and no tag' do
    before do
      allow(subject).to receive(:`).with(git_last_commit_command).and_return('abcdefg')
      allow(subject).to receive(:`).with(git_tag_command).and_return(nil)
      allow(subject).to receive(:command_succeeded?).and_return(true)
    end

    it 'returns the last commit sha' do
      expect(subject.render(context)).to eq('abcdefg')
    end
  end

  context 'given a git repository with a commit and a tag' do
    before do
      allow(subject).to receive(:`).with(git_tag_command).and_return('v1.0.0')
      allow(subject).to receive(:command_succeeded?).and_return(true)
    end

    it 'returns the last commit sha' do
      expect(subject.render(context)).to eq('v1.0.0')
    end

    it 'removes line ending from parsed value' do
      allow(subject).to receive(:`).with(git_tag_command).and_return("v1.0.0\n")

      expect(subject.render(context)).to eq('v1.0.0')
    end
  end
end
