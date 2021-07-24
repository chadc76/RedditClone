class SubDecorator < Draper::Decorator
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
    object.persisted? ? h.sub_url(object) : h.subs_url
  end

  def hidden_method
    object.persisted? ? "PATCH" : ""
  end

end
