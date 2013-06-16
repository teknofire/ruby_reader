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
  
  # calculate refresh interval for a feed based on min 15.minutes and max 1.hour.
  # then figuring out a formula based on the number of posts from the last 3 hours
  def refresh_interval
    time = 60.minutes
    
    x = self.entries.where('published > ?', 6.hour.ago).count / 6.0
    time = time + ((-45 * x + 60)).to_i.minutes
    logger.info "#{time}, #{x}"
    
    time = [time, 15.minutes].max
    time = [time, 1.hours].min
    
    time
  end
  
  def refresh_cache
    # don't fetch the feed again unless it's been more than 30.minutes since the last update
    return false if (Time.zone.now - self.updated_at) < self.refresh_interval
    self.refresh_cache!
  end
  
  def refresh_cache!
    rss.entries.each do |entry|
      entry_attrs = { 
        title: entry.title.sanitize, 
        author: entry.author.try(:sanitize), 
        summary: entry.summary,
        content: entry.try(:content),
        url: entry.url, 
        published: entry.published,
        categories: entry.try(:categories).try(:join, ', ')
      }
      
      entry = self.entries.where(url: entry.url).first
      if entry.nil?
        self.entries.create(entry_attrs)
      else
        entry.update_attributes(entry_attrs)
      end
    end
    update_feed_attributes
    self.touch
    self.save!
  end
end
