class NSString

  def format_as(format, pre_format = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ")
    date_formatter = NSDateFormatter.alloc.init
    date_formatter.dateFormat = pre_format
    date = date_formatter.dateFromString(self)
    date_formatter.dateFormat = format
    date_formatter.stringFromDate date
  end
  
  def time_count
    date_formatter = NSDateFormatter.alloc.init
    date_formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
    date = date_formatter.dateFromString(self)
    
    timeCountString = ""
    timeinterval = NSDate.new.timeIntervalSinceDate(date)
    
    minutes = 0
    hours = 0
    days = 0
    seconds = 0
    
    if (timeinterval < 3600)
      minutes = (timeinterval / 60).round
      seconds = (timeinterval % 60).round
      seconds = seconds == 0 ? 1 : seconds
      
      if (minutes == 0)
        timeCountString = "#{seconds} segundos atrás"  
      else
        if (minutes > 1)
          timeCountString = "#{minutes} minutos atrás"
        else
          timeCountString = "#{minutes} minuto atrás"
        end
      end
    elsif (timeinterval < 86400)
      hours = (timeinterval / 60 / 60).round
      if (hours < 2)
        timeCountString = "#{hours} hora atrás"
      else
        timeCountString = "#{hours} horas atrás"
      end
    else
      days = (timeinterval / 60 / 60 / 24).round
      if (days < 2)
        timeCountString = "#{days} dia atrás"
      else
        timeCountString = "#{days} dias atrás"
      end
    end
      
    "Há #{timeCountString}"
  end

end