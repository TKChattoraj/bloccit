module UsersHelper

  def display(user, context)
    if user.send(context).any?
      route = "helpers/show_context"
      render({partial: route, locals: {user: user, context: context}})
    else
      render({partial: "helpers/nothing_to_see", locals: {user: user, context: context}})
    end
  end

end
