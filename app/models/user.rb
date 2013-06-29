class User < ActiveRecord::Base
  has_many :authorizations
  has_many :likes
  
  validates_presence_of :email
  validates_uniqueness_of :email
  
  acts_as_reader
  
  def self.create_or_find_from_hash!(hash)
    user = where(email: hash['info']['email']).first
    user = create!(:name => hash['info']['name'], :email => hash['info']['email']) if user.nil?
    
    user
  end
  
  def like(item)
    self.likes.create(likeable: item)
    item.index
  end
  
  def unlike(item)
    self.likes.where(likeable: item).first.destroy
    item.index
  end
end
