namespace :feeds do
  desc 'update the feeds cache for all active feeds'
  task :update_cache => :environment do
    Feed.all.each do |feed|
      feed.refresh_cache
    end
  end
end