require 'hmac-sha1'

module WillSign
  # maximum allowed expiry
  def self.default_expiry
    @default_expiry ||= 300
  end
  
  def self.default_expiry=(value)
    @default_expiry = value.to_i
  end

  # relies on #sign_secret reader

  # creates a header value like TIME:HASH
  def sign_url(url, expiry = WillSign.default_expiry)
    expiry = (Time.now.utc + expiry).to_i.to_s
    pieces = split_url url
    create_hash_from_url_and_expiry pieces, expiry
  end
  
  def signed_url?(url, given)
    return false if url.nil? || given.nil? || given.size.zero?
    expiry, hash = given.split(":")
    expiry = expiry.to_i
    now    = Time.now.utc.to_i
    return false if expiry < now
    pieces = split_url url
    result = create_hash_from_url_and_expiry pieces, expiry
    result == given
  end

protected
  def split_url(url)
    url.split("/"). \
      delete_if { |piece| piece.nil? || piece.size.zero? }
  end

  def create_hash_from_url_and_expiry(pieces, expiry)
    "#{expiry}:#{HMAC::SHA1.hexdigest(sign_secret.to_s, (pieces << expiry).join("/"))}"
  end
end