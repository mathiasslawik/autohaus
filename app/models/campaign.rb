class Campaign < ActiveRecord::Base
  def matches?(account)
    puts "Versuche zu matchen: #{condition}"

    begin
      eval "#{condition}"
    rescue Exception
      false
    end
  end
end