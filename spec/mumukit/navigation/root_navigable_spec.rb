require 'spec_helper'
require 'mumukit/navigation/navigation_spec_helper.rb'

describe 'TerminalNavigation' do
  let(:root) { RootNavigable.new }

  describe '#navigation_end?' do
    it { expect(root.navigation_end?).to be true }
  end

  describe '#friendly' do
    it { expect(root.friendly).to eq 'Root' }
  end

  describe '#navigable_name' do
    it { expect(root.navigable_name).to eq 'Root' }
  end

  describe '#structural_parent' do
    it { expect(root.structural_parent).to be nil }
  end

  describe '#siblings' do
    it { expect(root.siblings).to be_empty }
  end
end
