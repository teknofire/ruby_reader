class Entry < ActiveRecord::Base
  attr_accessible :author, :categories, :feed_id, :published, :summary, :title, :url, :feed, :content
  
  belongs_to :feed
  
  scope :latest,  ->(last = Time.zone.now){ 
    where('published < ?', last).order('published DESC').limit(30)
  }
end
