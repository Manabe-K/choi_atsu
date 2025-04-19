module EventsHelper
  def joined_count(event)
    event.participant_users.count
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
      capacity_display = (event.capacity == 999) ? "制限なし" : "#{event.capacity}名"
      raw "<i class='fas fa-users mr-1'></i>#{joined_count(event)}名 / #{capacity_display}"
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

  def safe_return_to_path
    return_to = params[:return_to]

    if return_to.present? &&
       URI.parse(return_to).host.nil? &&
       return_to.start_with?("/") &&
       !return_to.include?("/participant") # 👈 ここ重要
      return_to
    else
      events_path
    end
  rescue URI::InvalidURIError
    events_path
  end

  def event_status(event)
    return "開催済み" if event.end_time < Time.current
    return "締切終了" if event.deadline.present? && event.deadline < Time.current
    return "満員" if event_full?(event)
    "募集中"
  end

  def event_status_class(status)
    case status
    when "募集中" then "bg-green-500"
    when "満員" then "bg-red-500"
    when "締切終了" then "bg-yellow-500"
    when "開催済み" then "bg-gray-500"
    else "bg-gray-300"
    end
  end
end
