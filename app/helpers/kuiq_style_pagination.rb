class KuiqStylePagination < WillPaginate::LinkRenderer

  #We only need to modify the protected method visible_page_numbers

protected
  def visible_page_numbers
    inner_window, outer_window = @options[:inner_window].to_i, @options[:outer_window].to_i
    window_from = current_page - inner_window
    window_to = current_page + inner_window
    
    # adjust lower or upper limit if other is out of bounds
    # the original doesn't show enough links for certain values
    #if window_to > total_pages
    if window_to > total_pages - 2
      #window_from -= window_to - total_pages
      window_from = total_pages - 6
      window_to = total_pages
    end
    
    #if window_from < 1
    if window_from < 3
      #window_to += 1 - window_from
      window_to = 7
      window_from = 1
      window_to = total_pages if window_to > total_pages
    end
    
    visible   = (1..total_pages).to_a
    left_gap  = (2 + outer_window)...window_from
    right_gap = (window_to + 1)...(total_pages - outer_window)
    visible  -= left_gap.to_a  if left_gap.last - left_gap.first > 1
    visible  -= right_gap.to_a if right_gap.last - right_gap.first > 1

    visible
  end
end