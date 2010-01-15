my_formats = { :short => '%d/%m/%Y', :long => '%d/%m/%Y %H:%M' }

Time::DATE_FORMATS.merge!(my_formats)
Date::DATE_FORMATS.merge!(my_formats)