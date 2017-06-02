class AllocationLink < ActiveRecord::Base
  belongs_to :course
  belongs_to :tutor_application

  enum state: %w(unallocated awaiting reserve shortlisted accepted rejected allocated)

  def proposed?
    not (reserve? || awaiting?)
  end

  def self.state_hash
    {
      unallocated: "Unallocated",
      awaiting: "Planning allocation",
      reserve: "Reserved",
      shortlisted: "Shortlisted",
      accepted: "Accepted",
      rejected: "Rejected",
      allocated: "Allocated"
    }
  end

  def self.readable_state(state)
    state_hash[state.to_sym]
  end

  def readable_state
    AllocationLink.readable_state(state)
  end

  def self.cc_viewable_states
    [3, 4, 5, 6]
  end
end
