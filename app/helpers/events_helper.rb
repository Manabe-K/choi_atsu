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
    turbo_frame_tag dom_id(event, :participation_button) do
      if user_joined?(event, user)
        button_to "キャンセル",
                  event_participant_path(event, from: "participating"),
                  method: :delete,
                  form: { data: { turbo_stream: true } },
                  class: base_button_class + " bg-gray-400 hover:bg-gray-500"
      else
        button_to "参加",
                  event_participant_path(event),
                  method: :post,
                  form: { data: { turbo_stream: true } },
                  class: base_button_class + " bg-orange-500 hover:bg-orange-400"
      end
    end
  end

  def participation_count(event)
    turbo_frame_tag dom_id(event, :participant_count) do
      content_tag :p, class: "text-sm text-gray-600" do
        raw "<i class='fas fa-users mr-1'></i>#{joined_count(event)}名 / #{event.capacity.present? ? "#{event.capacity}名" : "制限なし"}"
      end
    end
  end

  def curious_button(event, user)
    turbo_frame_tag "curious_button_#{event.id}" do
      if user_curious?(event, user)
        button_to "気になる解除",
                  event_curious_list_path(event, from: "interested"),
                  method: :delete,
                  form: { data: { turbo_stream: true } },
                  class: base_button_class(margin: true) + " bg-gray-400 hover:bg-gray-500"
      else
        button_to "気になる",
                  event_curious_list_path(event),
                  method: :post,
                  form: { data: { turbo_stream: true } },
                  class: base_button_class(margin: true) + " bg-yellow-500 hover:bg-yellow-400"
      end
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
