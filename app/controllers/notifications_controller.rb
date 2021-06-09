class NotificationsController < JsonController
  
  attr_accessor :notifications, :filter_type, :filter_order, :query, :filter_name
  
  def viewDidLoad
    self.title = "Atividades"
    
    super
    
    load_title_button
    load_right_button(title: "Filtrar", action: "toggle_filter")
  end
  
  def viewDidAppear(animated)
    super(animated)
    load_notifications
  end

  def viewWillAppear animated
    super
    self.navigationController.navigationBar.hidden = true
    loadMainTitle
  end

  def loadMainTitle
    label = UILabel.new
    self.view.addSubview(label)
    label.place_auto_layout(top: 30, width: 270, height: 45, leading: 20)
    label.font = Fonts.font_named("Roboto-Black", 30)
    label.text = self.title
    label.textAlignment = NSTextAlignmentLeft
    label.textColor = UIColor.blackColor

    button = UIButton.new
    button.setTitle("Filtrar", forState: UIControlStateNormal)
    self.view.addSubview(button) 
    button.setTitleColor(Theme.main_color, forState: UIControlStateNormal)
    button.titleLabel.font = Fonts.font_named("Roboto-Medium", 18)
    button.place_auto_layout(top: 35, trailing: -20, width: 65, height: 35)
    button.addTarget(self, action: NSSelectorFromString("toggle_filter"), forControlEvents: UIControlEventTouchUpInside)  
  end
  
  def toggle_filter
    controller = FilterController.new
    controller.delegate = self
    self.navigationController.pushViewController(controller, animated: true)
  end
  
  def load_notifications
    manager = NotificationManager.shared_manager
    manager.delegate = self
    manager.fetch_all(type: self.filter_type, order: self.filter_order, query: self.query, profile_id: app_delegate.current_profile_id)
  end
  
  def items_fetched(elements)
    self.notifications = elements
    self.table_data = load_table_data
    self.data_table_view.reloadData if self.data_table_view.present?
    self.dismiss_loading
    if self.data_table_view.present?
      self.outlets['name_label'].text = self.filter_name.present? ? self.filter_name : "Todas as notificações"
    end
  end
  
  def load_table_data
    rows = []
    
    if self.notifications && self.notifications.length > 0
      self.notifications.each do |notification|
        rows << {cell_type: "notification", notification: notification, action: "view_notification", action_param: notification}
      end
    end

    [{rows: rows}]
  end
  
  def view_notification(notification)
    puts notification.title
    if notification.type.include? "WarningNotification"
      c = NotificationWarningController.new
      c.notification = notification
      self.navigationController.pushViewController(c, animated: true)
    elsif notification.type.include? "PaymentRequestNotification" and notification.title.include? "Solicitação de Pagamento"
      a = NotificationRequestAcceptController.new
      a.notification = notification
      self.navigationController.pushViewController(a, animated: true)
    elsif notification.type.include? "PaymentRequestNotification" and notification.title.include? "Recebeu sua solicitação de Pagamento"
      b = NotificationRequestCancelController.new
      b.notification = notification
      self.navigationController.pushViewController(b, animated: true)
    elsif notification.type.include? "MentionNotification"
      d = NotificationMentionController.new
      d.notification = notification
      self.navigationController.pushViewController(d, animated: true)
    elsif notification.type.include? "MessageNotification"
      e = NotificationMessageController.new
      e.notification = notification
      self.navigationController.pushViewController(e, animated: true)
    elsif notification.type.include? "PromotionNotification"
      f = NotificationPromotionController.new
      f.notification = notification
      self.navigationController.pushViewController(f, animated: true)
    elsif notification.type.include? "PaymentNotification"
      g = NotificationPaymentController.new
      g.notification = notification
      self.navigationController.pushViewController(g, animated: true)
    elsif notification.type.include? "ReceiptNotification"
      h = NotificationReceiptController.new
      h.notification = notification
      self.navigationController.pushViewController(h, animated: true)
    end
    
  end
  
  def performSearch
    load_notifications
  end
  
end
