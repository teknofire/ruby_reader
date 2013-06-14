class Entry < ActiveRecord::Base
  attr_accessible :author, :categories, :feed_id, :published, :summary, :title, :url, :feed, :content
  
  belongs_to :feed
  
  validates_uniqueness_of :url
  
  scope :latest,  ->(last = Time.zone.now){ 
    where('published < ?', last).order(published: :desc).limit(15)
  }
end
