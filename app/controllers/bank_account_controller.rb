class BankAccountController < JsonController

  attr_accessor :form_view, :user, :profile, :bank_account, :account_controller

  def viewDidLoad
    self.title = "Meus dados bancários"
    
    self.form_view = FormView.get_form(delegate: self)
    self.view.addSubview(self.form_view)
    self.form_view.place_auto_layout(top: 0, bottom: 0, leading: 0, trailing: 0)
    self.container_view = self.form_view
    self.load_back_button
    title_label = self.load_title  
    
    
    super
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    get_all_bank_names
    preload_bank_account
  end
  
  def picker_view_data
    {
      "bank_name_select" => [["", "Banco do Brasil", "Bradesco", "Itaú"]],
      "account_type_select" => [["", "Conta Corrente", "Conta Poupança"]]
    }
  end

  def get_all_bank_names
    
  end
  
  def preload_bank_account
    unless profile.bank_account_id.nil?
      bank_account_manager = BankAccountManager.shared_manager
      bank_account_manager.delegate = self
      bank_account_manager.fetch(profile.bank_account_id)
    end
  end
  
  def item_fetched(bank_account)
    self.bank_account = bank_account
    
    self.outlets["bank_name_select"].text = self.bank_account.bank_name
    self.outlets["bank_name_select"].textColor = Theme.secondary_color
    self.outlets["account_type_select"].text = self.bank_account.account_type
    self.outlets["account_type_select"].textColor = Theme.secondary_color
    self.outlets["branch_field"].text = self.bank_account.branch_number
    self.outlets["branch_field"].textColor = Theme.secondary_color
    self.outlets["branch_digit_field"].text = self.bank_account.branch_digit
    self.outlets["branch_digit_field"].textColor = Theme.secondary_color
    self.outlets["account_number_field"].text = self.bank_account.account_number
    self.outlets["account_number_field"].textColor = Theme.secondary_color
    self.outlets["account_digit_field"].text = self.bank_account.account_digit
    self.outlets["account_digit_field"].textColor = Theme.secondary_color
  end

  def save
    self.bank_account = BankAccount.new if self.bank_account.nil?

    self.bank_account.bank_name = self.outlets["bank_name_select"].text
    self.bank_account.account_type = self.outlets["account_type_select"].text
    self.bank_account.branch_number = self.outlets["branch_field"].text
    self.bank_account.branch_digit = self.outlets["branch_digit_field"].text
    self.bank_account.account_number = self.outlets["account_number_field"].text
    self.bank_account.account_digit = self.outlets["account_digit_field"].text
    self.bank_account.profile_id = profile.remote_id
    
    self.show_loading("Carregando...")
    bank_account_manager = BankAccountManager.shared_manager
    bank_account_manager.delegate = self
    
    if bank_account.new_record?
      bank_account_manager.create_resource(bank_account)
    else
      bank_account_manager.update_resource(bank_account)
    end
      
  end
  
  def resource_created(bank_account)
    self.account_controller.load_profile
    self.dismiss_loading
    self.bank_account = bank_account
    self.app_delegate.display_message("Sucesso", "Conta criada com sucesso!")
    
    self.navigationController.popViewControllerAnimated(true)
  end
  
  def resource_updated(bank_account)
    self.account_controller.load_profile
    self.dismiss_loading
    self.bank_account = bank_account
    self.app_delegate.display_message("Sucesso", "Conta atualizada com sucesso!")
    
    self.navigationController.popViewControllerAnimated(true)
  end

end