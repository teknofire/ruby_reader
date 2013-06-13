class WelcomeController < ApplicationController
  respond_to :html, :js
  
  def index
    last = (params[:last].present? ? Time.parse(params[:last]) : Time.zone.now)
    @entries = Entry.latest(last)    
  end
end
