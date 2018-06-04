# frozen_string_literal: true

module DataHelper
  def convert_time(time)
    return time unless time.class == String
    Time.parse(time)
  end
end
