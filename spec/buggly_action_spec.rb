describe Fastlane::Actions::BugglyAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The buggly plugin is working!")

      Fastlane::Actions::BugglyAction.run(nil)
    end
  end
end
