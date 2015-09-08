class Breed < ActiveRecord::Base
  attr_accessible :name
  has_many :dogs

  def serializable_hash(options = nil)
    options ||= {}
    options[:only] ||= []
    options[:only] += [:id, :name, :size]
    options[:only].uniq!
    super(options)
  end
end
