class CreateDogs < ActiveRecord::Migration
  def change
    create_table :breeds do |t|
      t.string :name, :null => false
      t.string :size, :null => false

      t.timestamps
    end
    
    create_table :dogs do |t|
      t.string :name, :null => false
      t.integer :breed_id

      t.integer :bottoms_sniffed, :null => false, :default => 0
      t.integer :cats_chased, :null => false, :default => 0
      t.integer :faces_licked, :null => false, :default => 0

      t.timestamps
    end
  end
end
