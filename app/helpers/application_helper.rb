module ApplicationHelper

  def form_group_tag(errors, &block)
    extra_class = 'has-error' if errors.any?
    content_tag :div, capture(&block), class: "form-group #{extra_class}"
    end
  end
