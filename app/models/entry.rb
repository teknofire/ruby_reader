class Entry < ActiveRecord::Base
  belongs_to :feed
  has_many :likes, as: :likeable
  
  validates_uniqueness_of :url
  
  scope :latest,  ->(last = Time.zone.now){ 
    where('published < ?', last).order(published: :desc).limit(15)
  }
end
