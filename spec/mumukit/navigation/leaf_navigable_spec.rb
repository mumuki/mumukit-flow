require 'spec_helper'
require 'mumukit/navigation/navigation_spec_helper.rb'

describe 'ParentNavigation, SiblingsNavigation' do
  let(:leaf) { LeafNavigable.new }

  describe '#leave' do
    it { expect(leaf.leave('user')).to be_a LeafNavigable }
  end

  describe '#navigation_end?' do
    it { expect(leaf.navigation_end?).to be false }
  end

  describe '#navigable_name' do
    it { expect(leaf.navigable_name).to eq '1. Leaf' }
  end

  describe '#navigable_parent' do
    it { expect(leaf.navigable_parent).to be_a SubRootNavigable }
  end

  describe '#structural_parent' do
    it { expect(leaf.structural_parent).to be_a StructuralParent }
  end

  describe '#next_for' do
    it { expect(leaf.next_for('user')).to be_a LeafNavigable }
  end

  describe '#restart' do
    it { expect(leaf.restart('user')).to be_a LeafNavigable }
  end

  describe '#siblings' do
    it { expect(leaf.siblings).to all(be_a LeafNavigable) }
  end

  describe '#pending_siblings_for' do
    it { expect(leaf.pending_siblings_for('user')).to all(be_a LeafNavigable) }
  end
end
