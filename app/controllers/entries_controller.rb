class EntriesController < ApplicationController
  before_filter :require_login, only: [:like]
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
