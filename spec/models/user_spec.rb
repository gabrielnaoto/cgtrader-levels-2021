require 'cgtrader_levels'

describe CgtraderLevels::User do
  describe 'new user' do
    it 'has 0 reputation points' do
      @user = CgtraderLevels::User.new
      expect(@user.reputation).to eq(0)
    end

    it "has assigned 'First level'" do
      @level = CgtraderLevels::Level.create!(experience: 0, title: 'First level')
      @user = CgtraderLevels::User.new

      expect(@user.level).to eq(@level)
    end
  end

  describe 'level up' do
    it "level ups from 'First level' to 'Second level'" do
      @level_1 = CgtraderLevels::Level.create!(experience: 0, title: 'First level')
      @level_2 = CgtraderLevels::Level.create!(experience: 10, title: 'Second level')
      @user = CgtraderLevels::User.create!

      expect {
        @user.update_attribute(:reputation, 10)
      }.to change { @user.reload.level }.from(@level_1).to(@level_2)
    end

    it "level ups from 'First level' to 'Second level'" do
      @level_1 = CgtraderLevels::Level.create!(experience: 0, title: 'First level')
      @level_2 = CgtraderLevels::Level.create!(experience: 10, title: 'Second level')
      @level_3 = CgtraderLevels::Level.create!(experience: 13, title: 'Third level')
      @user = CgtraderLevels::User.create!

      expect {
        @user.update_attribute(:reputation, 11)
      }.to change { @user.reload.level }.from(@level_1).to(@level_3)
    end
  end

  describe 'level up bonuses & privileges' do
    it 'gives 7 coins to user' do
      initial_coins = 1

      @level_1 = CgtraderLevels::Level.create!(experience: 0, title: 'First level')
      @level_2 = CgtraderLevels::Level.create!(experience: 10, title: 'Second level', bonus_coins: 7)
      @user = CgtraderLevels::User.create!(coins: initial_coins)

      expect {
        @user.update_attribute(:reputation, 10)
      }.to change { @user.reload.coins }.from(initial_coins).to(initial_coins + @level_2.bonus_coins)
    end

    it 'reduces tax rate by 1' do
      @level_1 = CgtraderLevels::Level.create!(experience: 0, title: 'First level')
      @level_2 = CgtraderLevels::Level.create!(experience: 10, title: 'Second level', tax_reduction: 1)
      @user = CgtraderLevels::User.create!

      initial_tax = @user.tax

      expect {
        @user.update_attribute(:reputation, 10)
      }.to change { @user.reload.tax }.from(initial_tax).to(initial_tax - @level_2.tax_reduction)
    end
  end
end
