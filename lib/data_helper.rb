module DataHelper
  def convert_time(time)
    if time.class == String
      Time.parse(time)
    else
      return time
    end
  end
end
