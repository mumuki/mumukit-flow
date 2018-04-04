module Mumukit::Flow::Node
  def siblings
    if parent.nil?
      []
    else
      parent.children - [self]
    end
  end
end
