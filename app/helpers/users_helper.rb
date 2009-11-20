module UsersHelper
  
  def youtube_embed_small(video)
    youtube_embed video, :width => 212, :height => 186
  end
    
end