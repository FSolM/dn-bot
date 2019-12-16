require 'Session'
require 'Character'

primary_char = Character.new
primary_char.name = 'General Kenobi'
primary_char.race = 'Human'
primary_char.stats = {
  ATK: 6,
  DEF: 10,
  AGL: 8,
  DEX: 8,
  INT: 9,
  CHA: 10
}

RSpec.describe Session, 'Session class' do
  context 'Class initialization' do
    it 'Initializes with the char_list empty' do
      session = Session.new
      expect(session.char_list.length).to eql 0
    end
  end
  context 'Class closure' do
    it 'Closes the class deleting the char_list' do
      session = Session.new
      session.close
      expect(session.char_list).to eql nil
    end
  end
  context 'Class methods' do
    it 'Adds new characters to the char_list' do
      session = Session.new
      session.add_char(primary_char)
      expect(session.char_list.length).to eql 1
    end
    it 'Deletes added characters in the char_list' do
      session = Session.new
      session.add_char(primary_char)
      session.delete_char(primary_char.name)
      expect(session.char_list.length).to eql 0
    end
    it 'Updates added characters' do
      session = Session.new
      session.add_char(primary_char)
      session.update_char(primary_char.name, 'health', 10)
      expect(session.char_list[0].health).to eql 10
    end
    it 'Modifies added characters' do
      session = Session.new
      session.add_char(primary_char)
      session.mod_char(primary_char.name, 'ATK', 2)
      expect(session.char_list[0].stats[:ATK]).to eql 8
    end
    it "Checks if character exists in char_list, returns true if it doesn't" do
      session = Session.new
      session.add_char(primary_char)
      expect(session.exists?('General Kenobi')).to eql true
    end
    it "Checks if character exists in char_list, return false if it doesn't" do
      session = Session.new
      session.add_char(primary_char)
      expect(session.exists?('General Skywalker')).to eql false
    end
  end
end
