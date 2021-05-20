class ShortUrlsController < ApplicationController
  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  ##
  # This method return a json with a key equals to url and an array with
  # the top 100 most frequently accessed shortcodes
  # @return {url:['as1x','bc2x','4','xx']}
  def index
    respond_to do |format|
      format.json { render json: { urls: ShortUrl.top_100_urls_short_code } }
    end
  end

  ##
  # Receive a full_url and create or find a short_code for the full_url
  # if the url is valid it returns a json with the short_code
  # if the url is invalid it returns a json with the error
  #  Valid Url
  # @return {short_code: 'xafa8'}
  #  Invalid Url
  # @return {erros: ['Full url is not a valid url']}
  def create
    @short_url = ShortUrl.create_or_select_with_full_url(params[:full_url])

    respond_to do |format|
      if @short_url.new_record?
        format.json { render json: { errors: @short_url.errors.full_messages } }
      else
        format.json { render json: { short_code: @short_url.short_code } }
      end
    end
  end

  def public_attributes

  end

  # Receive a short code url and redirect the user to the full url
  # if the url doesn't exist the method will redirect the user to a 404 page
  #
  def show
    @short_url = ShortUrl.get_url_by_short_code_increment(params[:id])
    if @short_url
      redirect_to @short_url.full_url
    else
      redirect_to '404.html', status: 404
    end
  end
end
