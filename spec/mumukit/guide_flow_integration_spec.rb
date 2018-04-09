require_relative './../guide_flow_helper'

describe 'guide flow integration' do
  let(:guide) { build_guide :learning, :practice, :learning  }
  let(:flow) { build_guide_flow guide }

  it "1: normal, 2: normal, 3: easy" do
    expect(flow.current_exercise_number).to be 1

    4.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to eq 2

    4.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to eq 3

    flow.submit! :passed
    expect(flow.current_exercise_number).to be nil

    expect(flow).to be_finished
  end

  pending "1: easy, 2: bypassed, 3: easy" do
    expect(flow.current_exercise_number).to be 1

    flow.submit! :passed
    expect(flow.current_exercise_number).to be 3

    flow.submit! :passed
    expect(flow.current_exercise_number).to be nil

    expect(flow).to be_finished
  end

  it "1: hard, 2: easy, 3: easy, 1: easy" do
    expect(flow.current_exercise_number).to be 1

    10.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to be 2

    flow.submit! :passed
    expect(flow.current_exercise_number).to be 3

    flow.submit! :passed
    expect(flow.current_exercise_number).to be 1

    flow.submit! :passed
    expect(flow.current_exercise_number).to be nil

    expect(flow).to be_finished
  end

  it "[mixed submissions] 1: normal, 2: normal, 3: normal" do
    expect(flow.current_exercise_number).to be 1

    flow.submit! :failed
    flow.submit! :failed
    flow.submit! :failed

    flow.seek! 2

    flow.submit! :failed
    flow.submit! :failed
    flow.submit! :failed

    flow.seek! 3

    flow.submit! :failed
    flow.submit! :failed
    flow.submit! :failed

    flow.seek! 1

    flow.submit! :passed
    expect(flow.current_exercise_number).to be 2

    flow.submit! :passed
    expect(flow.current_exercise_number).to be 3

    flow.submit! :passed
    expect(flow.current_exercise_number).to be nil

    expect(flow).to be_finished
  end


  pending "1: hard, 2: hard, 3: easy, 1: easy, 2: easy" do
    expect(flow.current_exercise_number).to be 1

    10.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to be 2

    10.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to be 3

    flow.submit! :passed
    expect(flow.current_exercise_number).to be 1

    flow.submit! :passed
    expect(flow.current_exercise_number).to be 2

    flow.submit! :passed
    expect(flow.current_exercise_number).to be nil

    expect(flow).to be_finished
  end

  it "1: skipped, 2: skipped, 3: normal, 1: normal, 2: normal" do
    expect(flow.current_exercise_number).to be 1

    flow.seek! 3
    expect(flow.current_exercise_number).to be 3

    4.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to be 1

    4.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to be 2

    4.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to be nil

    expect(flow).to be_finished
  end

  pending "1: skipped, 2: skipped, 3: easy, 1: easy, 2: bypassed" do
    expect(flow.current_exercise_number).to be 1

    flow.seek! 3
    expect(flow.current_exercise_number).to be 3

    flow.submit! :passed
    expect(flow.current_exercise_number).to be 1

    flow.submit! :passed
    expect(flow.current_exercise_number).to be nil

    expect(flow).to be_finished
  end


  it "1: hard, 2: easy, 3: easy, 1: hard" do
    expect(flow.current_exercise_number).to be 1

    10.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to be 2

    flow.submit! :passed
    expect(flow.current_exercise_number).to be 3

    flow.submit! :passed
    expect(flow.current_exercise_number).to be 1

    10.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to be nil

    expect(flow).to be_finished
  end

  pending "1: hard, 2: hard, 3: easy, 1: hard, 1: hard" do
    expect(flow.current_exercise_number).to be 1

    10.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to be 2

    10.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to be 3

    flow.submit! :passed
    expect(flow.current_exercise_number).to be 1

    10.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to be 2

    10.times { flow.submit! :failed }
    flow.submit! :passed
    expect(flow.current_exercise_number).to be nil

    expect(flow).to be_finished
  end

end
