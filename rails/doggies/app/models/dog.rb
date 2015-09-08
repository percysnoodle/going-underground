class Dog < ActiveRecord::Base
  attr_accessible :name, :breed_id, :breed_name, :bottoms_sniffed, :cats_chased, :faces_licked
  belongs_to :breed

  def breed_name
    breed ? breed.name : 'Mongrel'
  end

  def serializable_hash(options = nil)
    options ||= {}
    options[:only] ||= [:id, :name, :breed_id, :breed_name]
    
    hash = super(options)
    if options[:only].include?(:breed_name)
      hash[:breed_name] = breed_name
    end
    hash
  end
end
