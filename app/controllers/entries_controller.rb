class EntriesController < ApplicationController
  before_filter :require_login, only: [:like, :unlike, :liked]
  respond_to :html, :js
  
  def index
    @last = last = (params[:last].present? ? Time.parse(params[:last]) : nil)
    
    @search = Entry.search(include: [:feed, :likes]) do
      if params[:q].present? and !params[:q].empty?
        fulltext params[:q] do
          boost_fields :title => 2.0
        end
      end
      
      with(:published).less_than last unless last.nil?
      with :feed_id, params[:feed_id] if params[:feed_id].present?
      
      with :liked_by_user_ids, current_user.id if params[:liked].present? and params[:liked] == 'true'
      
      order_by :published, :desc
      paginate :page => 1, :per_page => 15
    end
    
    @entries = @search.results
    
    respond_with(@entries)
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
end
