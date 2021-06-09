class WebController < BaseController

  attr_accessor :url, :web_view

  def viewDidLoad
    super
    self.web_view = UIWebView.alloc.init
    self.view.addSubview(self.web_view)
    self.web_view.place_expanded_into_view(self.view)
    self.web_view.loadRequest(NSURLRequest.requestWithURL(NSURL.URLWithString(self.url)))
    self.setup_right_nav_button("Fechar", "close")
  end

  def close
    self.dismissModalViewControllerAnimated(true, completion: nil)
  end

end