require 'spec_helper'

describe Mumukit::Flow::AdaptiveItem do
  let(:exercise) { DemoExercise.new(:learning, ['A', 'B']) }

  describe '#has?' do
    context 'with some tags it does have' do
      it { expect(exercise.has? 'A').to be true }
      it { expect(exercise.has? 'B').to be true }
    end

    context 'with a tag it does not have' do
      it { expect(exercise.has? 'C').to be false }
    end
  end
end
