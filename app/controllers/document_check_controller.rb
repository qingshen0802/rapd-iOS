class DocumentCheckController < JsonController
  
  attr_accessor :profile, :documents
  
  def viewDidLoad
    self.navigationController.navigationBar.hidden = true
    self.title = "Meus documentos"
    super
    
    self.load_back_button
    title_label = self.load_title  
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    load_profile
  end
  
  def load_profile
    profile_manager = ProfileManager.shared_manager
    profile_manager.delegate = self
    profile_manager.fetch(app_delegate.current_profile_id)
  end
  
  def item_fetched(profile)
    self.profile = profile
    displayDocuments
  end
  
  def displayDocuments
    case profile.current_document_status
    when 'never_sent'
      neverSent
    when 'all_approved'
      allApproved
      loadDocuments
    when 'contains_pending'
      containsPending
    when 'contains_declined'
      containsDeclined
      loadDocuments
    end    
  end
  
  def loadDocuments
    document_manager = DocumentManager.shared_manager
    document_manager.delegate = self
    document_manager.fetch_all(profile_id: profile.remote_id)
  end
  
  def items_fetched(documents)
    self.documents = documents
    self.data_table_view.reloadData
  end
  
  def document_rows
    self.documents ||= []
    return [] if self.documents.count == 0
    
    documents.map do |document|
      translated_position = document.position == 'front' ? 'A frente' : 'O verso'
      noun = document.position == 'front' ? 'a' : 'o'

      if document.approved?
        title = "Documento aprovado"
        subtitle = "#{translated_position} do documento foi aprovad#{noun} e você não precisa realizar nenhuma ação"
      else
        title = "Documento rejeitado"
        subtitle = "#{translated_position} do documento não foi aceit#{noun}. A imagem não está legível. Por favor, re-envie"
      end

      {cell_type: "document_status", title: title, subtitle: subtitle, status_icon: document.approved? ? "images/approved_document.png" : nil, disclosure: !document.approved?, disabled: document.approved?, action: "checkDocuments"}
    end
  end
  
  def table_data
    [{rows: document_rows}]
  end
  
  def neverSent
    self.outlets["document_icon"].image = UIImage.imageNamed("images/document_icon.png")
    self.outlets["confirm_label"].text = "Precisamos confirmar sua\nidentidade para aprovar seus\nresgates"
    self.outlets["save_button"].hidden = false
    self.outlets["instructions_label"].hidden = false
    self.data_table_view.hidden = true
  end
  
  def containsPending
    self.outlets["document_icon"].image = UIImage.imageNamed("images/document_approval_pending.png")
    self.outlets["confirm_label"].text = "Estamos analizando os documents\nenviados. Quando aprovados, os\npróximos resgates serão automáticos"
    self.outlets["save_button"].hidden = true
    self.outlets["instructions_label"].hidden = true
    self.data_table_view.hidden = true
  end  
  
  def allApproved
    self.outlets["document_icon"].image = UIImage.imageNamed("images/document_approved.png")
    self.outlets["confirm_label"].text = "Documentos estão ok!"
    self.outlets["save_button"].hidden = true
    self.outlets["instructions_label"].hidden = true
    self.data_table_view.hidden = false
  end
  
  def containsDeclined
    self.outlets["document_icon"].image = UIImage.imageNamed("images/alert_sign.png")
    self.outlets["confirm_label"].text = "Há algo de errado com o envio\ndos seus documentos. Por favor,\nverifique abaixo"    
    self.outlets["save_button"].hidden = true
    self.outlets["instructions_label"].hidden = true
    self.data_table_view.hidden = false
  end
  
  def continue
    document_controller = DocumentUploadController.new
    document_controller.profile = self.profile
    document_controller.check_controller = self
    self.navigationController.pushViewController(document_controller, animated: true)
  end
  
  def checkDocuments
    continue
  end
  
end