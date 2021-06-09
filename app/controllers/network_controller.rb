class NetworkController < JsonController
  
  attr_accessor :profile
  
  def viewDidLoad
    self.navigationController.navigationBar.hidden = true
    self.title = "Meus Contatos"
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
        # {cell_type: "icon_title_subtitle", icon: "images/network_contacts_icon.png", title: "Meus Contatos", subtitle: "Seus amigos que estão no aplicativo", disclosure: true, action: "manageContacts"},
        # {cell_type: "icon_title_subtitle", icon: "images/network_favorite_icon.png", title: "Meus Favoritos", subtitle: "Seus amigos favoritos no aplicativo", disclosure: true, action: "manageFavorites"},
        # {cell_type: "icon_title_subtitle", icon: "images/network_lists_icon.png", title: "Listas de Pagamentos", subtitle: "Gerencie listas com várias pessoas", disclosure: true, action: "manageLists"},
        {cell_type: "icon_title_subtitle", icon: "images/network_invite_icon.png", title: "Convide Seus Amigos", subtitle: "Compartilhe o Tratto com seus amigos", disclosure: true, action: "share"},
        {cell_type: "icon_title_subtitle", icon: "images/network_referrals_icon.png", title: "Meus Indicados", subtitle: "Pessoas indicadas por você que se cadastraram", disclosure: true, action: "manageReferrals"},
        {cell_type: "icon_title_subtitle", icon: "images/network_favorite_icon.png", title: "Meus Funcionários", subtitle: "Gerencie os funcionários do seu negócio", disclosure: true, action: "manageEmployees"},
      ]}
    ]
  end
  
  def displayManageBankAccounts
    bank_account_controller = BankAccountController.new
    bank_account_controller.profile = profile
    bank_account_controller.account_controller = self
    self.navigationController.pushViewController(bank_account_controller, animated: true)
  end
  
 # def manageContacts
 #   contacts_controller = ContactsController.new
 #   contacts_controller.profile = profile
 #   self.navigationController.pushViewController(contacts_controller, animated: true)
 # end
  
 # def manageFavorites
 #   favorites_controller = FavoritesController.new
 #   favorites_controller.profile = profile
 #   self.navigationController.pushViewController(favorites_controller, animated: true)
 # end
  
 # def manageLists
 #   puts "Manage Lists"
 # end
  

  def share
    share_controller = ShareController.new
    share_controller.profile = profile
    self.navigationController.pushViewController(share_controller, animated: true)
  end
  
  def manageReferrals
    referrals_controller = ReferralsController.new
    referrals_controller.profile = profile
    self.navigationController.pushViewController(referrals_controller, animated: true)
  end
  
  def manageEmployees
    contacts_controller = ContactsController.new
    contacts_controller.profile = profile
    contacts_controller.manage_employees = true
    self.navigationController.pushViewController(contacts_controller, animated: true)
  end
  
end