module ApplicationHelper
  def auth_token
    "<input type=\"hidden\" name=\"authenticity_token\" value=\"#{form_authenticity_token}\">".html_safe
  end

  def score(com_or_post)
    com_or_post.votes.map(&:value).sum
  end
end
