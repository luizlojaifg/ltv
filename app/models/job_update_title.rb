class JobUpdateTitle < ApplicationRecord

  @queue = :update_server

  def self.perform(short_url)
    short_url.update_title!
  end
end
