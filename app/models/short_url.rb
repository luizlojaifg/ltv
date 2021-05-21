class ShortUrl < ApplicationRecord
  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  # It must be unique because we dont need equal urls in the database
  validates :full_url, presence: true

  validate :validate_full_url

  scope :top_100_urls, -> { order('click_count desc').limit(100) }

  # update the title after create the short_url
  after_create :update_url_title

  # This method create a short_url record. If short_url already exists
  # the algorithm select such record
  # @return always return a <tt>ShortURL</tt>
  def self.create_or_select_with_full_url(full_url)
    short_url = ShortUrl.where('full_url=?', full_url).first

    short_url ||= ShortUrl.create(full_url: full_url)

    short_url
  end

  #Return the short_code from the full_url.
  def public_attributes
    short_code
  end

  # This method get top 100 most frequently accessed shortcodes.
  # @return an array of the top 100 frequently accessed shortcodes.
  def self.top_100_urls_short_code
    top_100_urls
  end

  # Create a short_code from the short_url id
  # The algorithm convert the id number to base 62 to minimize it
  # @return nil if the id is nil or the url short_code:string
  def short_code
    return nil if id.nil?

    base_to_code = CHARACTERS.size
    number_to_encode = id
    encoded_string = ''

    while number_to_encode > 0

      encoded_string << CHARACTERS[number_to_encode.modulo(base_to_code)]
      number_to_encode = (number_to_encode / base_to_code).to_i

    end

    encoded_string.reverse
  end

  # I implemented this method because in the future we may need this method
  # without incrementing the link
  # Receive a <tt>short_code</tt> and return his <tt>short_url</tt>
  # @param short_code it is a string that contains one short_code that exists in the table
  # @return short_url found by the short_code
  def self.find_by_short_code(short_code)
    short_url = ShortUrl.all.find { |x| x.short_code == short_code }

    short_url
  end

  # Receive a <tt>short_code</tt> and return the <tt>short_url</tt>
  # besides it increment in one the click count of the <tt>short_url</tt>
  # @param short_code it is a string that contains one short_code that exists in the table
  # @return short_url found by the short_code
  def self.get_url_by_short_code_increment(short_code)
    short_url = find_by_short_code short_code

    return nil unless short_url

    short_url.click_count += 1
    short_url.save

    short_url
  end

  # Update the title of the url
  def update_title!
    uri_requested = URI(full_url)
    result = Net::HTTP.get_response(uri_requested)
    title = result.body.scan(%r{<title>(.*?)</title>}).flatten.first
    self.title = title
    save
  end

  private

  # This method will run a job to get the page's title after and save it
  # after create the shorten url
  def update_url_title
    Resque.enqueue(UpdateTitleJob, id)
  end

  # This code may validate the full url.
  # if it isnt valid the software must not save the url
  def validate_full_url
    # Validates if the url is valid
    begin
      full_url_parser = URI.parse(full_url)

      raise Exception unless full_url_parser.is_a? URI::HTTP

    rescue Exception => e
      # This was necessary comply with tests
      errors.add(:full_url, 'is not a valid url')
      return false
    end

    true
  end
end
