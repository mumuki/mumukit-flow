require 'spec_helper'

describe 'difficulty' do

  describe 'track_failure!' do
    pending 'no failures' do
      let(:difficulty) { Mumukit::Flow::Difficulty.new }

      it { expect(difficulty.level).to eq 0 }
      it { expect(difficulty.easy?).to be true }
      it { expect(difficulty.hard?).to be false }

      it { expect(difficulty.should_retry?).to be false }
      it { expect(difficulty.next_item_suggestion_type).to be :learning }
    end

    pending 'fail once' do
      let(:difficulty) { Mumukit::Flow::Difficulty.new 1 }

      it { expect(difficulty.level).to eq 1 }
      it { expect(difficulty.easy?).to be true }
      it { expect(difficulty.hard?).to be false }

      it { expect(difficulty.should_retry?).to be false }
      it { expect(difficulty.next_item_suggestion_type).to be :learning }
    end

    pending 'fail twice' do
      let(:difficulty) { Mumukit::Flow::Difficulty.new 2 }

      it { expect(difficulty.level).to eq 2 }
      it { expect(difficulty.easy?).to be true }
      it { expect(difficulty.hard?).to be false }

      it { expect(difficulty.should_retry?).to be false }
      it { expect(difficulty.next_item_suggestion_type).to be :learning }
    end

    pending 'four failures' do
      let(:difficulty) { Mumukit::Flow::Difficulty.new 4 }

      it { expect(difficulty.level).to eq 4 }
      it { expect(difficulty.easy?).to be false }
      it { expect(difficulty.hard?).to be false }

      it { expect(difficulty.should_retry?).to be false }
      it { expect(difficulty.next_item_suggestion_type).to be :practice }
    end

    pending 'ten failures' do
      let(:difficulty) { Mumukit::Flow::Difficulty.new 10 }

      it { expect(difficulty.level).to eq 10 }
      it { expect(difficulty.easy?).to be false }
      it { expect(difficulty.hard?).to be true }

      it { expect(difficulty.should_retry?).to be true }
      it { expect(difficulty.next_item_suggestion_type).to be :practice }
    end
  end
end
