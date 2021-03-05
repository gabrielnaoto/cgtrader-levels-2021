require 'active_record'

class CgtraderLevels::User < ActiveRecord::Base
  belongs_to :level

  after_initialize :set_new_level, if: :is_level_nil?
  before_update :set_new_level, if: :should_level_up?

  def is_level_nil?
    level.nil?
  end

  private

  def should_level_up?
    matching_level = CgtraderLevels::Level.current_level(reputation).first

    level_id_change_to_be_saved != matching_level.id
  end

  def set_new_level
    matching_level = CgtraderLevels::Level.current_level(reputation).first

    if matching_level
      self.level = matching_level

      on_level_up
    end
  end

  def on_level_up
    if level.bonus_coins.present?
      self.coins = coins + level.bonus_coins
    end

    if level.tax_reduction.present?
      self.tax = tax - level.tax_reduction
    end
  end
end
