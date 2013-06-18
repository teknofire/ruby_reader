class FeedsController < ApplicationController
  before_filter :require_admin_auth, only: [:index, :new, :edit, :create, :update, :reseed]
  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Feed.order('title ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feeds }
    end
  end

  def reseed
    @feed = Feed.find(params[:id])
    if !@feed.reseed!
      flash[:error] = "Error reseeding #{@feed.title}, #{@feed.errors.full_messages}"
    end
    redirect_to feeds_path
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    last = (params[:last].present? ? Time.parse(params[:last]) : Time.zone.now)    
    @feed = Feed.find(params[:id])
    redirect_to feed_path(@feed, last: last)
  end
  
  def stats
    @feed = Feed.find(params[:id]) if params[:id].present?
      
    respond_to do |format|
      format.html {
        @feed = Feed.find(params[:id])
      }
      format.json {
        if @feed
          @stats = @feed.entries.group_by_hour(:published).count
        else
          @stats = Feed.all.map { |feed|
            enddate = Time.now
            startdate = 1.day.ago
            { name: feed.title, data: feed.entries.group_by_hour(:published, Time.zone, startdate..enddate).count }
          }.compact
        end
        render :json => @stats        
      }
    end
  end
  
  def refresh
    if params[:id].nil?
      Feed.all.each(&:refresh_cache)
    else
      Feed.find(params[:id]).refresh_cache
    end
    
    respond_to do |format|
      format.html { redirect_to feeds_path }
    end
  end

  # GET /feeds/new
  # GET /feeds/new.json
  def new
    @feed = Feed.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feed }
    end
  end

  # GET /feeds/1/edit
  def edit
    @feed = Feed.find(params[:id])
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(feed_params)

    respond_to do |format|
      if @feed.save
        @feed.refresh_cache!
        format.html { redirect_to feeds_path, notice: 'Feed was successfully created.' }
        format.json { render json: @feed, status: :created, location: @feed }
      else
        format.html { render action: "new" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feeds/1
  # PUT /feeds/1.json
  def update
    @feed = Feed.find(params[:id])

    respond_to do |format|
      if @feed.update_attributes(feed_params)
        @feed.refresh_cache!
        format.html { redirect_to feeds_path, notice: 'Feed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to feeds_url }
      format.json { head :no_content }
    end
  end
  
  protected
  
  def feed_params
    params.require(:feed).permit(:feed_url, :title, :url)
  end
end
