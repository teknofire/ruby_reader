class Feed < ActiveRecord::Base
  attr_accessible :etag, :feed_url, :last_modified, :title, :url

  has_many :entries, dependent: :destroy

  validates_presence_of :feed_url

  before_save :update_feed_attributes
  
  def update_feed_attributes
    self.title = rss.title
    self.url = rss.url
    self.etag = rss.etag
    self.last_modified = rss.last_modified
  end
  
  def rss
    @rss ||= Feedzirra::Feed.fetch_and_parse(self.feed_url)
  end
  
  def refresh_cache
    # don't fetch the feed again unless it's been more than 30.minutes since the last update
    return false if (Time.zone.now - self.updated_at) < 30.minutes
    self.refresh_cache!
  end
  
  def refresh_cache!
    rss.entries.each do |entry|
      entry_attrs = { 
        title: entry.title.sanitize, 
        author: entry.author.sanitize, 
        summary: entry.summary.sanitize,
        content: entry.content.try(:sanitize),
        url: entry.url, 
        published: entry.published,
        categories: entry.categories.join(', ')
      }
      
      entry = self.entries.where(url: entry.url).first
      if entry.nil?
        self.entries.create(entry_attrs)
      else
        entry.update_attributes(entry_attrs)
      end
    end
    update_feed_attributes
    self.save!
  end
end
