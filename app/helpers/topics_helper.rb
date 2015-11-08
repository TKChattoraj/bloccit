module TopicsHelper

  def user_is_authorized_to_create_or_delete_topic?
    current_user && current_user.admin?
  end
  def user_is_authorized_to_edit_topic?
    current_user && (current_user.admin? || current_user.moderator?)
  end


end
