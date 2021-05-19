class JobUpdateTitle < ApplicationRecord

  @queue = :UpdateTitleJob

  def self.perform(short_url)
    short_url.update_title!
  end
end
