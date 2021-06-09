class SettingsController < JsonController
  
  attr_accessor :profile
  
  def viewDidLoad
    self.navigationController.navigationBar.hidden = true
    self.title = "Configurações"
    self.table_data = load_table_data
    super
    
    back_button = self.load_back_button
    unless settings[:back_button].nil?
      back_button.setImage(UIImage.imageNamed(settings[:back_button]), forState: UIControlStateNormal)
    end
        
    title_label = self.load_title
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
  end
  
  def load_table_data
    [
      {rows: [
        {cell_type: "icon_title_subtitle", icon: "images/settings_security_icon.png", title: "Segurança", subtitle: "Deixe sua conta mais segura", disclosure: true, action: "security"},
        {cell_type: "icon_title_subtitle", icon: "images/settings_notifications_icon.png", title: "Notificações", subtitle: "Receba alertas sobre eventos", disclosure: true, action: "notifications"},
        # {cell_type: "icon_title_subtitle", icon: "images/settings_automatic_bonus_icon.png", title: "Bonificação Automática", subtitle: "Veja se você está sendo bonificado", disclosure: true, action: "bonification"},
        {cell_type: "icon_title_subtitle", icon: "images/settings_club_icon.png", title: "Clube de Desconto", subtitle: "Configure o clube de desconto do seu estabelecimento", disclosure: true, action: "discountClub"},
        {cell_type: "icon_title_subtitle", icon: "images/settings_coupon_icon.png", title: "Cupons de Crédito", subtitle: "Resgate recompensas", disclosure: true, action: "coupons"},
        {cell_type: "icon_title_subtitle", icon: "images/account_key_icon.png", title: "Redefinir senha", subtitle: "Altere sua senha de acesso", disclosure: true, action: "displayEditPassword"},

      ]}
    ]
  end
  
  def security
    c = SettingsSecurityController.new
    c.profile = self.profile
    self.navigationController.pushViewController(c, animated: true)
  end
  
  def notifications
    c = SettingsNotificationsController.new
    c.profile = self.profile
    self.navigationController.pushViewController(c, animated: true)
  end

 # def bonification
 #   c = SettingsAutomaticBonusController.new
 #   c.profile = self.profile
 #   self.navigationController.pushViewController(c, animated: true)
 # end
  
  def discountClub
    c = SettingsDiscountClubController.new
    c.profile = self.profile
    self.navigationController.pushViewController(c, animated: true)
  end

  def displayEditPassword
    edit_controller = ResetPasswordController.new
    edit_controller.from_profile = true
    self.navigationController.pushViewController(edit_controller, animated: true)
  end

  def coupons
  end

end