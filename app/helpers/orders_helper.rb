module OrdersHelper
  def rating_text(rating)
    case rating
      when "5"
        "Sehr gut"
      when "4"
        "Gut"
      when "3"
        "Befriedigend"
      when "2"
        "Mangelhaft"
      when "1"
        "Ungenügend"
      else
        "Nicht angegeben"
    end
  end
end