class Profile < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :vidvatar_url
  
  validates_format_of :vidvatar_url, :with => /(?:\A|v=)[a-zA-Z0-9_-]{11}(?:\Z|&)|v=\Z/, :message => "not a proper Youtube Video URL or ID"
  
  def vidvatar_url=(url)
    self.vidvatar = url.scan(/(?:\A|v=)([^http][a-zA-Z0-9_-]+)/).to_s
  end
  
  def vidvatar_url
    "http://www.youtube.com/watch?v=#{vidvatar}"
  end
end
