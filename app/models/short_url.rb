class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  #It must be unique because we dont need equal urls in the database
  validates :full_url , presence: true

  validate :validate_full_url

  scope :top_100_urls, -> { order("click_count desc").limit(100) }


  after_create :update_url_title

  def self.create_or_select_with_full_url full_url

    short_url = ShortUrl.where("full_url=?",full_url).first
    unless short_url
      short_url = ShortUrl.create(full_url: full_url)
    end
    return short_url
  end

  def self.top_100_urls_short_code
    return top_100_urls.collect {|short_url| short_url.short_code}
  end

  def short_code
    base_to_code = CHARACTERS.size

    number_to_encode = self.id
    encoded_string = ""
    while number_to_encode > 0
      encoded_string << CHARACTERS[number_to_encode.modulo(base_to_code)]
      number_to_encode = (number_to_encode/base_to_code).to_i
    end

    encoded_string.reverse

    return encoded_string
  end

  def really_simple_short_code
    return id.to_s(36)
  end

  def update_title!
  end

  private

  #This method will run a job to get the page's title after and save it
  # after create the shorten url
  def update_url_title

  end

  #This code may validate the full url.
  # if it isnt valid the software must not save the url
  def validate_full_url

    #Validates if the url is valid
    unless full_url =~ URI::regexp
      errors.add(:full_url, "The full url is not valid.")
      return false
    end

    #if there are other validations I can put above that one returning false

    return true
  end

end
