class PostDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def action_url
    object.persisted? ? h.post_url(object) : h.posts_url
  end

  def hidden_method
    object.persisted? ? "PATCH" : ""
  end

  def sub_options
    Sub.all
  end

  def sub_checked(sub_id)
    object.sub_id == sub_id ? ' checked="checked"' : ''
  end

end
