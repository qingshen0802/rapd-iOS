class BaseTextField < UITextField

  # UIKeyboardTypeDefault,                // Default type for the current input method.
  # UIKeyboardTypeASCIICapable,           // Displays a keyboard which can enter ASCII characters, non-ASCII keyboards remain active
  # UIKeyboardTypeNumbersAndPunctuation,  // Numbers and assorted punctuation.
  # UIKeyboardTypeURL,                    // A type optimized for URL entry (shows . / .com prominently).
  # UIKeyboardTypeNumberPad,              // A number pad (0-9). Suitable for PIN entry.
  # UIKeyboardTypePhonePad,               // A phone pad (1-9, *, 0, #, with letters under the numbers).
  # UIKeyboardTypeNamePhonePad,           // A type optimized for entering a person's name or phone number.
  # UIKeyboardTypeEmailAddress,           // A type optimized for multiple email address entry (shows space @ . prominently).
  # UIKeyboardTypeDecimalPad,             // A number pad including a decimal point
  # UIKeyboardTypeTwitter,                // Optimized for entering Twitter messages (shows # and @)
  # UIKeyboardTypeWebSearch,              // Optimized for URL and search term entry (shows space and .)

  UITextAutocapitalizationTypeWords

  def self.get_field(options = {})
    field = new

    field.delegate = options[:delegate] unless options[:delegate].nil?

    field.layer.borderColor = Theme.tertiary_color.CGColor
    field.layer.borderWidth = 1
    field.layer.masksToBounds = true

    field.placeholder = options[:placeholder] unless options[:placeholder].nil?
    field.secureTextEntry = true if options[:secure] == true
    field.autocapitalizationType = UITextAutocapitalizationTypeNone
    field.backgroundColor = UIColor.whiteColor

    unless options[:capitalization].nil?
      capitalization = case options[:capitalization]
      when :words
        UITextAutocapitalizationTypeWords
      else
        UITextAutocapitalizationTypeNone
      end
      field.autocapitalizationType = capitalization
    end

    unless options[:keyboard].nil?
      field.keyboardType = case options[:keyboard]
      when :email
        UIKeyboardTypeEmailAddress
      else
        UIKeyboardTypeDefault
      end
    end

    field.layer.cornerRadius = 4.0
    field.clipsToBounds = true  

    field
  end

  def textRectForBounds(bounds)
    CGRectInset(bounds, 5, 5)
  end

  def editingRectForBounds(bounds)
    CGRectInset(bounds, 5, 5)
  end  

end