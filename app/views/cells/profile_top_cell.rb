class ProfileTopCell < BaseCell

  def set_data(data = {})
    super(data)
    self.selectionStyle = UITableViewCellSelectionStyleNone

    if data[:show_gear]
      gear = UIButton.new
      gear.setImage(UIImage.imageNamed("images/white_gear.png"), forState: UIControlStateNormal)
      self.container_view.addSubview(gear)
      gear.place_auto_layout(center_y: -80, trailing: -10, width: 25, height: 25)
      gear.addTarget(self.delegate, action: NSSelectorFromString("showProfiles"), forControlEvents: UIControlEventTouchUpInside)
    end
    
    if data[:update_photo]
      camera = UIButton.new
      camera.setImage(UIImage.imageNamed("images/white-camera.png"), forState: UIControlStateNormal)
      self.container_view.addSubview(camera)
      camera.place_auto_layout(center_y: -5, center_x: 0, width: 36, height: 36)
      camera.addTarget(self.delegate, action: NSSelectorFromString("selectPhoto"), forControlEvents: UIControlEventTouchUpInside)
    end
    
    unless data[:photo].nil?
      self.outlets["profile_image"].image = data[:photo]
    else
      self.outlets["profile_image"].sd_setImageWithURL(NSURL.URLWithString(data[:profile_photo]), placeholderImage: UIImage.imageNamed("images/profile_placeholder.png"))
    end

    self.outlets["name_label"].text = data[:profile_name]
    self.outlets["username_label"].text = data[:profile_username]
    self.outlets["ttt"].text = data[:profile_type]
  end

end