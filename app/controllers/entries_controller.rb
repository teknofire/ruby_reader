class EntriesController < ApplicationController
  before_filter :require_login, only: [:like, :unlike, :liked, :allread, :read, :unread_count]
  respond_to :html, :js

  def index
    @last = (params[:last].present? ? Time.parse(params[:last]) : nil)
    @search = search(@last)
    @entries = @search.results
    
    
    respond_to do |format|
      format.html
      format.js {
        if params[:count].present?
          render 'count'
        end
      }
    end
  end
  
  def allread
    @entries = Entry.unread_by(current_user)
    
    Entry.mark_as_read! :all, :for => current_user
    @entries.each(&:index)
    
    redirect_to root_url
  end
  
  def read
    @entry = Entry.find(params[:id])
    @entry.mark_as_read!(:for => current_user)
    respond_to do |format|
      format.js {
        render 'count'
      }
    end
  end
  
  def like
    @entry = Entry.find(params[:id])
    
    respond_to do |format|
      if current_user.like(@entry)
        format.js { render 'likeable' }
      else
        format.js {
          flash.now[:error] = 'Could not like this entry'
        }
      end
    end
  end
  
  def unlike
    @entry = Entry.find(params[:id])
    
    respond_to do |format|
      if current_user.unlike(@entry)
        format.js { render 'likeable' }
      else
        format.js {
          flash.now[:error] = 'Could not unlike this entry'
        }
      end
    end
  end
  
  protected
  
  def save_lastest_seen_entry_date(date)
    session[:newest_entry] = date
  end
  
  def lastest_seen_entry_date
    session[:newest_entry]
  end
  
  def new_total
    Entry.unread_by(current_user).count
  end
  helper_method :new_total
  
  def search(last = nil, first = nil)
    last = Time.zone.now if last.nil?
    
    Entry.search(include: [:feed, :likes]) do
      if params[:q].present? and !params[:q].empty?
        fulltext params[:q] do
          boost_fields :title => 2.0
        end
      else
        if signed_in? and params[:read] != 'true' and params[:liked] != 'true'
          without(:read_by, current_user.id)
        end
        if params[:liked].present? and params[:liked] == 'true'
          with :liked_by_user_ids, current_user.id 
        end
      end
      
      with(:published).less_than last unless last.nil?
      with :feed_id, params[:feed_id] if params[:feed_id].present?
      
      order_by :published, :desc
      paginate :page => 1, :per_page => 15
    end
  end
end
