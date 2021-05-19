class UpdateTitleJob < ApplicationJob
  queue_as :default
  @queue = :default

  # Receive a short url's id and update his title based on the full url
  # Update short url's title
  # #
  def perform(short_url_id)
    short_url = ShortUrl.find short_url_id
    short_url.update_title!
  end
end
