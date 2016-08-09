RSpec.describe Jekyll::ProjectVersionTag do
  GIT_TEST_COMMAND          = 'git rev-parse'
  GIT_TAG_COMMAND           = 'git describe --tags --always'
  GIT_LAST_COMMIT_COMMAND   = 'git rev-parse --short HEAD'
  let(:context) { double.as_null_object }

  subject { Jekyll::ProjectVersionTag.new }

  before do
    allow(subject).to receive(:system).and_return(true)
  end

  context 'no git repository' do
    before do
      allow(subject).to receive(:system).with(GIT_TEST_COMMAND).and_return(nil)
    end

    it 'returns an error message' do
      expect(subject.render(context)).to match(/Oops/)
    end
  end

  context 'a git repository with no commits' do
    before do
      allow(subject).to receive(:`).with(GIT_LAST_COMMIT_COMMAND).and_return(nil)
      allow(subject).to receive(:`).with(GIT_TAG_COMMAND).and_return(nil)
      allow(subject).to receive(:command_succeeded?).and_return(true)
    end

    it 'returns an unable to read project message' do
      expect(subject.render(context)).to match(/could not read the project version/)
    end
  end

  context 'a git repository with a commit and no tag' do
    before do
      allow(subject).to receive(:`).with(GIT_LAST_COMMIT_COMMAND).and_return('abcdefg')
      allow(subject).to receive(:`).with(GIT_TAG_COMMAND).and_return(nil)
      allow(subject).to receive(:command_succeeded?).and_return(true)
    end

    it 'returns the last commit sha' do
      expect(subject.render(context)).to eq('abcdefg')
    end
  end

  context 'a git repository with a commit and a tag' do
    before do
      allow(subject).to receive(:`).with(GIT_LAST_COMMIT_COMMAND).and_return('abcdefg')
      allow(subject).to receive(:`).with(GIT_TAG_COMMAND).and_return('v1.0.0')
      allow(subject).to receive(:command_succeeded?).and_return(true)
    end

    it 'returns the last commit sha' do
      expect(subject.render(context)).to eq('v1.0.0')
    end

    it 'removes line ending from parsed value' do
      allow(subject).to receive(:`).with(GIT_TAG_COMMAND).and_return("v1.0.0\n")

      expect(subject.render(context)).to eq('v1.0.0')
    end
  end
end
