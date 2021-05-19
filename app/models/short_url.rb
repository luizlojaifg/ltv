class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validate :validate_full_url

  after_create :update_url_title

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
    #I could use the code return full_url =~ URI::regexp, nevertheless
    # I think it would be complicate to some developers to understand 0 for true and nil for false
    # So I decide the code with tradicional if
    if full_url =~ URI::regexp
      return true
    else
      errors.add(:full_url, "The full url is not valid.")
      return false
    end
  end

end
