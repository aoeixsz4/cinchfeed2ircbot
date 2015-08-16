require 'json'
require 'open-uri'

class Sendeplan
  def self.format_item(item)
    "#{item[:summary]} von #{item[:start][:dateTime][11..15]} bis #{item[:end][:dateTime][11..15]} Uhr"
  end

  def self.jetzt_und_danach
    key = File.read(File.expand_path("~/.google_calendar_api_key")).strip
    url = "https://www.googleapis.com/calendar/v3/calendars/"+
      "h6tfehdpu3jrbcrn9sdju9ohj8@group.calendar.google.com/events"+
      "?singleEvents=true&orderBy=startTime&timeZone=CET&"+
      "timeMin=#{(Time.now).utc.iso8601}&"+
      "timeMax=#{(Time.now+86400).utc.iso8601}&"+
      "key=#{key}"

    open(url) do |cal|
      events = JSON.parse cal.read, symbolize_names: true
      [format_item(events[:items][0]), format_item(events[:items][1])]
    end
  end
end
