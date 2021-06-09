class ShareController < JsonController
  
  include MotionSocial::Sharing
  
  attr_accessor :profile, :contacts, :addressbook_contacts, :query, :addressbook_contact_manager, :current_sms_recipient
  
  def viewDidLoad
    self.title = "Indique-nos"
    super
    back_button = self.load_back_button
    title_label = self.load_title
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    load_addressbook_contacts
  end
  
  def load_addressbook_contacts
    self.addressbook_contact_manager = AddressbookContactManager.shared_manager
    self.addressbook_contact_manager.delegate = self
    self.addressbook_contact_manager.fetch_all
  end
  
  def items_fetched(addressbook_contacts)
    self.addressbook_contacts = addressbook_contacts
    self.data_table_view.reloadData
  end
  
  def performSearch
    @contact_rows = nil
    self.data_table_view.reloadData
  end  
  
  def table_data
    [{rows: contacts_rows}]
  end
  
  def contacts_rows
    return @contact_rows if @contact_rows.present?

    self.contacts ||= []
    filtered_contacts = contacts
    filtered_contacts = filtered_contacts.map{|c| c if "#{c.first_name} #{c.last_name}".downcase =~ /#{query.downcase}/}.compact if query.present?

    @contact_rows = filtered_contacts.map do |contact|
      iphones = contact.phones.map{|p| p if p[:label].to_s.downcase == 'iphone'}.compact
      mobiles = contact.phones.map{|p| p if p[:label].to_s.downcase == 'mobile'}.compact
      mobile_phone_number = iphones.count > 0 ? iphones.first : mobiles.first
      existing_addressbook_contact = addressbook_contacts.map{|c| c if c.phone_number == mobile_phone_number[:value].gsub(/[^0-9]*/, '')}.compact.first
      status = existing_addressbook_contact.try(:status)

      {cell_type: "phone_contact", name: "#{contact.first_name} #{contact.last_name}", status: status, action: "share_sms", action_param: mobile_phone_number}
    end
  end
  
  def disableSocial(toggle_state)
    self.outlets["top_square"].hidden = toggle_state
    self.outlets["liked_title_label"].hidden = toggle_state
    self.outlets["liked_subtitle_label"].hidden = toggle_state
    self.outlets["social_label"].hidden = toggle_state
    self.outlets["social_button"].hidden = toggle_state
    
    self.outlets["shared_link_title_label"].hidden = !toggle_state
    self.outlets["shared_link_square"].hidden = !toggle_state
    self.outlets["shared_link_label"].hidden = !toggle_state
    self.data_table_view.hidden = !toggle_state
    self.outlets["search_view"].hidden = !toggle_state
  end
  
  def showFacebookTab
    disableSocial(false)
    self.outlets["social_button"].removeTarget(nil, action: nil, forControlEvents: UIControlEventAllEvents)
    self.outlets["social_button"].addTarget(self, action: NSSelectorFromString("post_to_facebook"), forControlEvents: UIControlEventTouchUpInside)
    
    self.outlets["social_label"].text = "Compartilhe no Facebook e indique para seus amigos. Nós não enviamos SPAM."
    self.outlets["social_button"].setBackgroundColor(Theme.color("3c5a96"), forState: UIControlStateNormal)
    self.outlets["social_button"].setTitle("Compartilhar no Facebook", forState: UIControlStateNormal)
  end
  
  def showTwitterTab
    disableSocial(false)
    self.outlets["social_button"].removeTarget(nil, action: nil, forControlEvents: UIControlEventAllEvents)
    self.outlets["social_button"].addTarget(self, action: NSSelectorFromString("post_to_twitter"), forControlEvents: UIControlEventTouchUpInside)
        
    self.outlets["social_label"].text = "Compartilhe no Twitter e indique para seus amigos. Nós não enviamos SPAM."
    self.outlets["social_button"].setBackgroundColor(Theme.color("3da8e3"), forState: UIControlStateNormal)
    self.outlets["social_button"].setTitle("Compartilhar no Twitter", forState: UIControlStateNormal)
  end
  
  def showPhoneTab
    disableSocial(true)
    self.outlets["shared_link_title_label"].hidden = true
    self.outlets["shared_link_square"].hidden = true
    self.outlets["shared_link_label"].hidden = true
    self.outlets["search_view"].hidden = false
    self.data_table_view.hidden = false
    
    if AddressBook.authorized?
      import_contacts
    else
      if AddressBook.request_authorization
        import_contacts
      else
        app_delegate.display_error("Precisamos da sua permissão para importar os contatos")
      end
    end
  end

  def showLinkTab
    disableSocial(true)
    self.data_table_view.hidden = true
    self.outlets["search_view"].hidden = true
    self.outlets["shared_link_title_label"].hidden = false
    self.outlets["shared_link_square"].hidden = false
    self.outlets["shared_link_label"].hidden = false
    self.outlets["shared_link_label"].text = profile.referral_link
  end
  
  def import_contacts
    ab = AddressBook::AddrBook.new
    self.contacts = ab.people.reject{|c| c.try(:phones).to_a.count == 0 || (!c.phones.map{|p| p[:label]}.include?("mobile") && !c.phones.map{|p| p[:label].to_s.downcase}.include?("iphone"))}
    self.app_delegate.display_message("Contatos", "Foram encontrados #{self.contacts.count} contatos com número de celular cadastrado")
    self.data_table_view.reloadData
  end  
  
  def sharing_message
    "Gostaria de convidá-los para conhecer o Tratto, sua carteira digital"
  end

  def sharing_url
    profile.referral_link
  end

  def sharing_image
    nil
  end

  def controller
    self # This is so that we can present the dialogs. 
  end
  
  def share_sms(phone)
    send_sms(phone[:value])
  end
  
  def send_sms(recipient)
    self.current_sms_recipient = recipient
    
    MFMessageComposeViewController.alloc.init.tap do |sms|
      sms.messageComposeDelegate = self
      sms.recipients = [recipient]
      sms.body = "#{sharing_message} - #{sharing_url}"
      self.presentModalViewController(sms, animated: true)
    end if MFMessageComposeViewController.canSendText
  end

  def messageComposeViewController(controller, didFinishWithResult:result)
    recipient = self.current_sms_recipient
    self.current_sms_recipient = nil
    
    case result.to_s
    when '0'
    when '1'
      addressbook_contact = AddressbookContact.new
      addressbook_contact.phone_number = recipient
      addressbook_contact.status = 'invited'
      addressbook_contact_manager.create_resource(addressbook_contact)
    end
    
    controller.dismissModalViewControllerAnimated(true)    
  end  
  
  def resource_created(addresbook_contact)
    load_addressbook_contacts
  end
  
end