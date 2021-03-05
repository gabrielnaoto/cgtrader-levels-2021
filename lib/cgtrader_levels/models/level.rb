require 'active_record'

class CgtraderLevels::Level < ActiveRecord::Base
  scope :next_level, -> (reputation) {
    where("experience > ?", reputation)
      .order("experience ASC")
      .limit(1)
  }

  scope :current_level, -> (reputation) {
    next_level = CgtraderLevels::Level.next_level(reputation).first

    if next_level.present?
      return where("experience >= :reputation AND :reputation < :next_level", {
        reputation: reputation,
        next_level: next_level.experience
      })
    end

    where("experience >= ?", reputation)
  }
end
