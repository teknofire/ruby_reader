class Entry < ActiveRecord::Base
  belongs_to :feed, touch: true
  has_many :likes, as: :likeable
  
  validates_presence_of :url
  validates_uniqueness_of :url
  validates_presence_of :remote_id
  validates_uniqueness_of :remote_id
  
  acts_as_readable on: :created_at
  
  scope :latest,  ->(last = Time.zone.now){ 
    last = Time.zone.now if last.nil? 
    where('created_at < ?', last).order(published: :desc).limit(15)
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
    
    time :created_at
    time :updated_at
    time :published
    
    integer :read_by, multiple: true do
      users = ReadMark.global.where('timestamp >= ?', self.send(self.readable_options[:on])).pluck(:user_id) 
      users += self.read_marks.pluck(:user_id)
      users.uniq
    end
    integer :feed_id
    integer :liked_by_user_ids, multiple: true do
      self.likes.pluck(:user_id)
    end
  end
  
  # def published
  #   self.created_at
  # end
  
  def published_at
    self.read_attribute(:published)
  end
  
  def mark_as_read!(options)
    if self.unread?(options[:for])
      super
      self.index
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
