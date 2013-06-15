class EntriesController < ApplicationController
  before_filter :require_login, only: [:like, :unlike, :liked]
  respond_to :html, :js
  
  def index
    last = (params[:last].present? ? Time.parse(params[:last]) : Time.zone.now)
    
    @entries = Entry.latest(last).includes(:feed)
    
    if params[:feed_id].present?
      @entries = @entries.where(feed_id: params[:feed_id])
    end
    
    if params[:liked].present? and params[:liked] == 'true'
      @entries = @entries.where(id: current_user.likes.where(likeable_type: 'Entry').pluck(:likeable_id))
    end
    
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
