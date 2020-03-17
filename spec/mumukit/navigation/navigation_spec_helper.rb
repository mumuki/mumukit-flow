class RootNavigable
  include Mumukit::Flow::TerminalNavigation

  def name
    'Root'
  end
end

class SubRootNavigable
  include Mumukit::Flow::ParentNavigation

  def defaulting(_block)
    'SubRoot'
  end

  def next_for(_user)
    LeafNavigable.new
  end
end

class LeafNavigable
  include Mumukit::Flow::ParentNavigation
  include Mumukit::Flow::SiblingsNavigation

  attr_reader :number

  def initialize(number=1)
    @number = number
  end

  def structural_parent
    StructuralParent.new
  end

  def progress_for(_user)
    DemoProgress.new
  end

  def name
    'Leaf'
  end
end

class StructuralParent
  def structural_children
    [LeafNavigable.new(1), LeafNavigable.new(2), LeafNavigable.new(3)]
  end

  def usage_in_organization
    SubRootNavigable.new
  end
end

class DemoProgress
  def completed?
    false
  end
end