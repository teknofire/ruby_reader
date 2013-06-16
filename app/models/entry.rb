class Entry < ActiveRecord::Base
  belongs_to :feed
  has_many :likes, as: :likeable
  
  validates_uniqueness_of :url
  
  scope :latest,  ->(last = Time.zone.now){ 
    last = Time.zone.now if last.nil? 
    where('published < ?', last).order(published: :desc).limit(15)
  }
  
  searchable do
    text :title
    text :content do
      self.scrub(self.content)
    end
    text :summary do
      self.scrub(self.summary)
    end
    
    text :feed_title do
      self.feed.title
    end
    
    time :published
    integer :feed_id
    integer :liked_by_user_ids, multiple: true do
      self.likes.pluck(:user_id)
    end
  end
  
  def scrub(content)
    return if content.nil? or content.empty?
    
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::SanitizationFilter
      ], { whitelist: HTML::Pipeline::SanitizationFilter::FULL }
      
    pipeline.call(content)[:output].to_s
  end
end
