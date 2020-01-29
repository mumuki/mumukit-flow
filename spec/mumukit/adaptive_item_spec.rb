require 'spec_helper'

describe Mumukit::Flow::AdaptiveItem do
  let(:exercise) { DemoExercise.new(:learning, ['A', 'B']) }

  describe '#tagged_as?' do
    context 'with some tags it does have' do
      it { expect(exercise.tagged_as? 'A').to be true }
      it { expect(exercise.tagged_as? 'B').to be true }
    end

    context 'with a tag it does not have' do
      it { expect(exercise.tagged_as? 'C').to be false }
    end
  end
end
