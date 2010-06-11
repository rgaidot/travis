module Travis
  module Helpers
    def build_output(build, options = { :width => 120 })
      output = build.output.split("\n").collect do |line|
        line = line.gsub(%r(/home/slugs/[^/]*/mnt/.bundle/gems/gems/), '[gems]/')
        line = line.gsub(%r(/disk[^/]*/tmp/[^/]*/), '[repo]/')
        line.gsub(%r((.{1,#{options[:width]}})), "\\1\n")
      end.join
      "$ #{build.command}\n\n#{output}"
    end

    # thank you, integrity
    def pretty_date(date_time)
      days_away = (Date.today - Date.new(date_time.year, date_time.month, date_time.day)).to_i
      if days_away == 0
        "today"
      elsif days_away == 1
        "yesterday"
      else
        strftime_with_ordinal(date_time, "on %b %d%o")
      end
    end

    def strftime_with_ordinal(date_time, format_string)
      ordinal = case date_time.day
        when 1, 21, 31 then "st"
        when 2, 22     then "nd"
        when 3, 23     then "rd"
        else                "th"
      end

      date_time.strftime(format_string.gsub("%o", ordinal))
    end
  end
end