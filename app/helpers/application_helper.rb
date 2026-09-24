module ApplicationHelper
    def flash_class(message_type)
    case message_type.to_s
    when "notice"
      "bg-green-100 text-green-800 border border-green-300"
    when "alert"
      "bg-red-100 text-red-800 border border-red-300"
    when "warning"
      "bg-yellow-100 text-yellow-800 border border-yellow-300"
    else
      "bg-blue-100 text-blue-800 border border-blue-300"
    end
  end
end
