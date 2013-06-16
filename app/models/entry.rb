class Entry < ActiveRecord::Base
  belongs_to :feed
  has_many :likes, as: :likeable
  
  validates_uniqueness_of :url
  
  scope :latest,  ->(last = Time.zone.now){ 
    last = Time.zone.now if last.nil? 
    where('published < ?', last).order(published: :desc).limit(15)
  }
  
  searchable do
    text :title, :content, :summary
    
    time :published
    integer :feed_id
    integer :liked_by_user_ids, multiple: true do
      self.likes.pluck(:user_id)
    end
  end
end
