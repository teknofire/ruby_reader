class Feed < ActiveRecord::Base
  has_many :entries, dependent: :destroy

  validates_presence_of :feed_url
  validates_uniqueness_of :feed_url

  before_save :update_feed_attributes
  
  def update_feed_attributes
    self.title = rss.title
    self.url = rss.url
    self.etag = rss.etag
    self.last_modified = rss.last_modified
  end
  
  def to_param
    "#{self.id}-#{self.title.truncate(50).parameterize}"
  end
  
  def rss
    @rss ||= Feedzirra::Feed.fetch_and_parse(self.feed_url)
  end
  
  # calculate refresh interval for a feed based on min 30.minutes and max 2.hours.
  # then figuring out a formula based on the number of posts from the last 5 hours
  def refresh_interval
    x = self.entries.where('published > ?', 6.hours.ago).where('published < ?', 1.hour.ago).count / 5.0
    
    if x <= 0.001
      time = 120.minutes
    else
      time = ((-20 * x) + 120).to_i.minutes
    end
    
    time = [time, 30.minutes].max    
    time
  end
  
  def reseed!
    self.entries.destroy_all
    self.refresh_cache!
  end
  
  def refresh_cache
    # don't fetch the feed again unless it's been more than 30.minutes since the last update
    return false if (Time.zone.now - self.updated_at) < self.refresh_interval
    self.refresh_cache!
  end
  
  def refresh_cache!
    rss.entries.each do |entry|
      entry_attrs = { 
        remote_id: entry.id,
        title: entry.title.sanitize, 
        author: entry.author.try(:sanitize), 
        summary: entry.summary,
        content: entry.try(:content),
        url: entry.url, 
        published: entry.published,
        categories: entry.try(:categories).try(:join, ', ')
      }
      
      entry = self.entries.where(remote_id: entry.id).first
      if entry.nil?
        self.entries.create(entry_attrs)
      else
        entry.update_attributes(entry_attrs)
      end
    end
    update_feed_attributes
    self.save
  end
end
