module Mumukit::Flow::TerminalNavigation
  def navigation_end?
    true
  end

  def friendly
    name
  end

  def navigable_name
    name
  end

  def structural_parent
    nil
  end

  def siblings
    []
  end
end
