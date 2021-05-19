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
    unless id.nil?
      base_to_code = CHARACTERS.size

      number_to_encode = self.id
      encoded_string = ""
      while number_to_encode > 0
        encoded_string << CHARACTERS[number_to_encode.modulo(base_to_code)]
        number_to_encode = (number_to_encode/base_to_code).to_i
      end

      encoded_string.reverse

      return encoded_string
    else
      return nil
    end
  end

  def really_simple_short_code
    return id.to_s(36)
  end

  #This method get url by his short code
  def self.find_by_short_code short_code

    short_url = ShortUrl.all.find {|x| x.short_code == short_code}

    if short_url.nil?
      raise ActionController::RoutingError.new('Url not Found')
    end

    return  short_url
  end

  #I did this method because in the future we may need this method
  # without incrementing the link
  # #

  def self.get_url_by_short_code_increment short_code
    short_url = find_by_short_code short_code
    short_url.click_count += 1
    short_url.save
    return short_url
  end

  #This method update the title of the url
  def update_title!
    uri_requested = URI(self.full_url)
    result = Net::HTTP.get_response(uri_requested)
    title = JSON.parse(result.body)["title"]
    self.title = title
    self.save
  end

  private

  #This method will run a job to get the page's title after and save it
  # after create the shorten url
  def update_url_title
    Resque.enqueue(JobUpdateTitle, self)
  end

  #This code may validate the full url.
  # if it isnt valid the software must not save the url
  def validate_full_url

    #Validates if the url is valid
    begin
      full_url_parser = URI.parse(full_url)

      unless full_url_parser.is_a? URI::HTTP
        errors.add(:full_url,"is not a valid url")
        errors.add(:base,"Full url is not a valid url")
        return false
      end

    rescue
      errors.add(:full_url,"is not a valid url")
      errors.add(:base,"Full url is not a valid url")
      return false
    end


    #if there are other validations I can put above that one returning false

    return true
  end

end
