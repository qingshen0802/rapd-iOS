class CompanyDetailsPictureCell < BaseCell
  attr_accessor :form_view, :store

  def set_data(data = {})
    super(data)
    self.store = data[:store]
    if check_url(store.cover_photo_url)
      load_pictures
    end 
  end

  def load_pictures
    if store.cover_photo_url.kind_of?(Array)
      images = store.cover_photo_url
    else 
      url = store.cover_photo_url
      images = []
      images[0] = store.cover_photo_url
    end 
    scroll_view = self.outlets["scroll_view"]
    page_control = self.outlets["page_control"]
    page_control.numberOfPages = images.length
    page_control.currentPage = 1
    scroll_view.contentSize = CGSizeMake(scroll_view.frame.size.width * images.length, scroll_view.frame.size.height)
   
      images.each_with_index {|url, i|
        picture = UIImageView.new
        picture.sd_setImageWithURL(NSURL.URLWithString(url),
                placeholderImage: nil, 
                       completed: (lambda do |image, error, cacheType, imageUrl| 
                        rect = CGRectMake(0,0, scroll_view.frame.size.width, scroll_view.frame.size.height)
                        UIGraphicsBeginImageContext(rect.size)
                        if image.blank?
                        else
                          image.drawInRect(rect)
                          pic = UIGraphicsGetImageFromCurrentImageContext();
                          UIGraphicsEndImageContext()
                          image_data = UIImagePNGRepresentation(pic)
                          img = UIImage.imageWithData(image_data)
                          view = UIView.alloc.initWithFrame(CGRectMake(scroll_view.frame.size.width * i, 0, scroll_view.frame.size.width, scroll_view.frame.size.height))
                          view.backgroundColor = UIColor.alloc.initWithPatternImage(img)
                          scroll_view.addSubview(view)
                        end                       
                end ))
        
      } 
  end 

  def scrollViewDidScroll(scrollView)
    self.outlets["page_control"].currentPage =  self.outlets["scroll_view"].contentOffset.x / self.outlets["scroll_view"].frame.size.width
  end

  def  check_url(url)  
    return url =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
  end 

end