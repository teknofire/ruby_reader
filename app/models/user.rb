class User < ActiveRecord::Base
  has_many :authorizations
  has_many :likes
  
  validates_presence_of :email
  validates_uniqueness_of :email
  
  acts_as_reader
  
  def self.create_from_hash!(hash)
    create(:name => hash['info']['name'], :email => hash['info']['email'])
  end
  
  def like(item)
    self.likes.create(likeable: item)
  end
  
  def unlike(item)
    self.likes.where(likeable: item).first.destroy
  end
end
