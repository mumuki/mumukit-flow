module Mumukit::Flow::SiblingsNavigation
  required :structural_parent
  required :progress_for
  required :number
  required :name

  def next_for(user)
    pending_siblings_for(user).select { |it| it.number > number }.sort_by(&:number).first
  end

  def restart(user)
    pending_siblings_for(user).sort_by(&:number).first
  end

  def siblings
    structural_parent.structural_children
  end

  def pending_siblings_for(user, organization=Organization.current)
    siblings.reject { |it| it.progress_for(user, organization).completed? }
  end

  # Names

  def navigable_name
    "#{number}. #{name}"
  end
end
