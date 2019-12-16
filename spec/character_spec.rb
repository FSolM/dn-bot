require 'Character'

base_stats = {
  ATK: nil,
  DEF: nil,
  AGL: nil,
  DEX: nil,
  INT: nil,
  CHA: nil
}

RSpec.describe Character, 'Character class' do
  context 'Class initialization' do
    it 'Initializes with the name empty' do
      character = Character.new
      expect(character.name).to eql nil
    end
    it 'Initializes with the race empty' do
      character = Character.new
      expect(character.race).to eql nil
    end
    it 'Initializes with their stats empty' do
      character = Character.new
      expect(character.stats).to eql base_stats
    end
    it 'Initializes with 20 health' do
      character = Character.new
      expect(character.health).to eql 20
    end
  end
end
