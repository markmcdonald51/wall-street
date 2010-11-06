Time::DATE_FORMATS[:month_and_year] = "%B %Y"
Time::DATE_FORMATS[:time_format] = '%I:%M%p'

Time::DATE_FORMATS[:twenty_four_hours_time] = '%H:%M:%S'

Time::DATE_FORMATS[:simple] = "%a %I%p"
# Time::DATE_FORMATS[:default] = '%m/%d/%Y'
Time::DATE_FORMATS[:row] = "%m/%d/%Y %I:%M%p"
Time::DATE_FORMATS[:short_ordinal] = lambda { |date| date.strftime("%B #{date.day.ordinalize}") }
Time::DATE_FORMATS[:long_ordinal] = lambda { |date| date.strftime("%B #{date.day.ordinalize}, %Y, %I:%M%p")} 
Time::DATE_FORMATS[:article] = "%a, %b %d, %Y"
Time::DATE_FORMATS[:human_hour] = lambda { |date| date.strftime("%I:%M%p").gsub(/^0|:00/, '') }
Time::DATE_FORMATS[:human_hour] = lambda { |date| date.strftime("%I:%M%p").gsub(/^0|:00/, '') }

Time::DATE_FORMATS[:long_ordinal] = lambda { |date| date.strftime("%A, %B #{date.day.ordinalize}, %Y, %I:%M%p")}


class Time
  def tz_cast
    t= self.to_s(:human_hour)
    Time.parse("#{t} UTC").in_time_zone
  end
end

