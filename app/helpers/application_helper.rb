# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def ytg_get_kuiq_user_id(video)
    video.developer_tags.select {|dt| dt =~ /^#{YT_CONFIG['developer_tag']}_/ }.to_s.split(/^#{YT_CONFIG['developer_tag']}_/).to_s unless video.developer_tags.blank?
  end
  
  def ytg_get_vidvatar_by_id(id)
    client = YouTubeG::Client.new
    @ytg_result = client.video_by(id, :headers => {"X-GData-Key" => "key=AI39si4PHm-0wUtYO6jVx-ywH23zI93R8nLY24NJrCUn27FCuTESwIWH1I5wQE-vj1vGXHtid9zeXWR4vmv9bw7RdvZcpqCjXg"})
  end
  
  def video_exists?(id)
    response = Net::HTTP.get_response(URI.parse("http://gdata.youtube.com/feeds/api/videos/#{id}")).code.to_i
       
    return response == 200 unless id.blank?
    return false if id.blank?     
  end
  
  def default_video
    client = YouTubeG::Client.new
    client.video_by('T6LxtUgzVjk')
  end
  
  def first_20_kuiq_videos
    YouTubeG::Client.new.videos_by(
      :developer_tags => [:kuiqtest], 
      :max_results => 20, 
      :headers => {"X-GData-Key" => "key=AI39si4PHm-0wUtYO6jVx-ywH23zI93R8nLY24NJrCUn27FCuTESwIWH1I5wQE-vj1vGXHtid9zeXWR4vmv9bw7RdvZcpqCjXg"}
    ).videos
  end
end
