class FormView < UIScrollView

  attr_accessor :delegate

  def self.get_form(options = {})
    form = new

    form.delegate = options[:delegate] unless options[:delegate].nil?
    form.backgroundColor = UIColor.whiteColor
    form.userInteractionEnabled = true

    unless options[:skip_gesture]
      gesture = UITapGestureRecognizer.alloc.initWithTarget(form, action: NSSelectorFromString("touched"))
      gesture.numberOfTapsRequired = 1
      gesture.numberOfTouchesRequired = 1
      form.addGestureRecognizer(gesture)
    end

    form
  end

  def resetPosition(animated =  true)
    self.setContentOffset(CGPointMake(0,-20), animated: animated)
  end

  def touched
    self.delegate.dismissKeyboard
  end

end