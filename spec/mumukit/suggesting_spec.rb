require 'spec_helper'

describe Mumukit::Flow::Suggesting do
  let(:exercises) { [
      DemoExercise.new(:learning),
      DemoExercise.new(:learning),
      DemoExercise.new(:practice),
      DemoExercise.new(:learning),
      DemoExercise.new(:learning)
  ] }
  let(:submitter) { 'a student' }
  let(:exercise) { exercises[0] }

  before { build_guide_with(exercises) }

  describe 'exercises with same tags' do
    context 'when one exercise has been solved' do
      before do
        exercise.accept_submission_status! :passed
      end

      it 'suggests continuing with the next one' do
        expect(exercise.next_suggested_item_for(submitter)).to eq exercises[1]
      end
    end

    context 'when two learning exercises of a certain tag were solved easily' do
      before do
        exercises[0].accept_submission_status! :passed
        exercises[1].accept_submission_status! :passed
      end

      context 'when the third exercise is learning' do
        before do
          exercises[2] = DemoExercise.new(:learning)
          build_guide_with(exercises)
        end

        it 'suggests continuing with it' do
          expect(exercise.next_suggested_item_for(submitter)).to eq exercises[2]
        end
      end

      context 'when the third exercise is practice' do
        context 'when the fourth exercise is learning' do
          it 'suggests skipping to the fourth one' do
            expect(exercises[1].next_suggested_item_for(submitter)).to eq exercises[3]
            expect(exercises[2]).to be_passed
          end
        end

        context 'when the fourth exercise is practice and the fifth one is learning' do
          before do
            exercises[3] = DemoExercise.new(:practice)
            build_guide_with(exercises)
          end

          it 'suggests skipping to the fifth one' do
            expect(exercises[1].next_suggested_item_for(submitter)).to eq exercises[4]
            expect(exercises[2]).to be_passed
            expect(exercises[3]).to be_passed
          end
        end
      end
    end

    context 'when no exercises of a certain tag were solved easily' do
      before do
        5.times { exercises[0].accept_submission_status! :failed }
        5.times { exercises[1].accept_submission_status! :failed }

        exercises[0].accept_submission_status! :passed
        exercises[1].accept_submission_status! :passed
      end

      it 'suggests continuing with the next exercise' do
        expect(exercise.next_suggested_item_for(submitter)).to eq exercises[2]
      end
    end
  end

  describe 'exercises with different tags' do
    context 'when exercise with tag A and exercise with tag B were solved easily' do
      let(:exercises) { [
          DemoExercise.new(:learning, ['A']),
          DemoExercise.new(:learning, ['B']),
          DemoExercise.new(:practice)]
      }

      before do
        exercises[0].accept_submission_status! :passed
        exercises[1].accept_submission_status! :passed
      end

      it 'suggests continuing with the next exercise whatever its tag' do
        expect(exercise.next_suggested_item_for(submitter)).to eq exercises[2]
      end
    end

    context 'when exercise with tags AB and exercise with tag A were solved easily' do
      let(:exercises) { [
          DemoExercise.new(:learning, ['A', 'B']),
          DemoExercise.new(:learning, ['A'])]
      }

      before do
        exercises[0].accept_submission_status! :passed
        exercises[1].accept_submission_status! :passed
      end

      context 'when next exercise is learning with any tag' do
        before do
          exercises[2] = DemoExercise.new(:learning)
          build_guide_with(exercises)
        end

        it 'suggests continuing' do
          expect(exercise.next_suggested_item_for(submitter)).to eq exercises[2]
        end
      end

      context 'when next exercise is practice with tag A' do
        before do
          exercises[2] = DemoExercise.new(:practice, ['A'])
          build_guide_with(exercises)
        end

        it 'suggests skipping' do
          expect(exercise.next_suggested_item_for(submitter)).to eq exercises[3]
          expect(exercises[2]).to be_passed
        end
      end

      context 'when next exercise is practice with tag B' do
        before do
          exercises[2] = DemoExercise.new(:practice, ['B'])
          build_guide_with(exercises)
        end

        it 'suggests continuing' do
          expect(exercise.next_suggested_item_for(submitter)).to eq exercises[2]
        end
      end

      context 'when next exercise is practice with tags AB' do
        before do
          exercises[2] = DemoExercise.new(:practice, ['A', 'B'])
          build_guide_with(exercises)
        end

        it 'suggests continuing' do
          expect(exercise.next_suggested_item_for(submitter)).to eq exercises[2]
        end
      end
    end
  end
end
