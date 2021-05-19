class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    respond_to do |format|
      format.json { render :json => {urls: ShortUrl.top_100_urls_short_code} }
    end
  end

  def create
    full_url = params[:full_url]
    @short_url = ShortUrl.create_or_select_with_full_url full_url
    respond_to do |format|
      unless @short_url.new_record?
        format.json { render :json => {short_code: @short_url.short_code }}
      else
        format.json { render :json => {errors: @short_url.errors.values.flatten }}
      end

    end
  end

  def show
    begin
      @short_url = ShortUrl.get_url_by_short_code_increment(params[:id])
      redirect_to @short_url.full_url
    rescue Exception => e
      redirect_to "404.html", :status => 404
    end


  end

end
