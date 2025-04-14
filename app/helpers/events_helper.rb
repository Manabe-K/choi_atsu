module EventsHelper
  def joined_count(event)
    event.participant_users.count + 1
  end

  def event_full?(event)
    joined_count(event) >= event.capacity.to_i
  end

  def user_joined?(event, user)
    event.participant_users.exists?(user.id)
  end

  def user_curious?(event, user)
    event.curious_users.exists?(user.id)
  end

  def participation_button(event, user)
    if user_joined?(event, user)
      button_to "キャンセル",
                event_participant_path(event),
                method: :delete,
                class: base_button_class + " bg-gray-400 hover:bg-gray-500"
    else
      button_to "参加",
                event_participant_path(event),
                method: :post,
                class: base_button_class + " bg-orange-500 hover:bg-orange-400"
    end
  end

  def curious_button(event, user)
    if user_curious?(event, user)
      button_to "気になる解除",
                event_curious_list_path(event),
                method: :delete,
                class: base_button_class(margin: true) + " bg-gray-400 hover:bg-gray-500"
    else
      button_to "気になる",
                event_curious_list_path(event),
                method: :post,
                class: base_button_class(margin: true) + " bg-yellow-500 hover:bg-yellow-400"
    end
  end

  def base_button_class(margin: false)
    [
      "w-full",
      margin ? "mt-2" : nil,
      "text-white",
      "font-bold",
      "py-2",
      "rounded"
    ].compact.join(" ")
  end

  def tag_color(_tag_name)
    "6c757d"  # Bootstrap風のグレー
  end
end
