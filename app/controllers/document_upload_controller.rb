class DocumentUploadController < JsonController
  
  attr_accessor :profile, :image_picker, :current_picker_position, 
                :top_photo, :top_photo_mime_type, :bottom_photo, 
                :bottom_photo_mime_type, :front_document, :back_document,
                :current_document_upload, :document_manager, 
                :front_document_changed, :back_document_changed,
                :check_controller, :documents
  
  def viewDidLoad
    self.navigationController.navigationBar.hidden = true
    self.title = "Enviar documentos"
    super
    self.outlets["save_button"].enabled = false
    self.outlets["save_button"].alpha = 0.5
    self.load_back_button
    title_label = self.load_title  
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
    loadDocuments
  end

  def loadDocuments
    document_manager = DocumentManager.shared_manager
    document_manager.delegate = self
    document_manager.fetch_all(profile_id: profile.remote_id)
  end
  
  def items_fetched(documents)
    self.documents = documents
    
    if self.documents.count > 0
      self.documents.each do |document|
        self.front_document = document if document.position == "front"
        self.back_document = document if document.position == "back"
      end
    end
    
    unless front_document.nil?  
      self.outlets["top_square_image"].sd_setImageWithURL(NSURL.URLWithString(front_document.attachment_url), placeholderImage: nil)
      self.outlets["top_document_icon"].hidden = true
      self.outlets["top_label"].hidden = true      
    end
    
    unless back_document.nil?
      self.outlets["bottom_square_image"].sd_setImageWithURL(NSURL.URLWithString(back_document.attachment_url), placeholderImage: nil)
      self.outlets["bottom_document_icon"].hidden = true
      self.outlets["bottom_label"].hidden = true      
    end
  end
  
  def sendDocumentFront
    self.current_picker_position = 'top'
    selectPhoto
  end
  
  def sendDocumentBack
    self.current_picker_position = 'bottom'
    selectPhoto
  end
  
  def selectPhoto
    self.image_picker = UIImagePickerController.new
    self.image_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary
    self.image_picker.delegate = self
    self.presentViewController(image_picker, animated: true, completion: nil)
  end
  
  def imagePickerController(picker, didFinishPickingMediaWithInfo: imageInfo)
    extension = imageInfo[UIImagePickerControllerReferenceURL].absoluteString.split("=").last
    
    case current_picker_position
    when 'top'
      self.front_document_changed = true
    when 'bottom'
      self.back_document_changed = true
    end
    
    self.send("#{current_picker_position}_photo=", imageInfo[UIImagePickerControllerOriginalImage])
    self.send("#{current_picker_position}_photo_mime_type=", extension == "JPG" ? "image/jpeg" : "image/png")
    self.outlets["#{current_picker_position}_square_image"].image = self.send("#{current_picker_position}_photo")
    self.outlets["#{current_picker_position}_document_icon"].hidden = true
    self.outlets["#{current_picker_position}_label"].hidden = true
    
    self.image_picker.dismissViewControllerAnimated(true, completion: nil)

    check_both_photos
  end    
  
  def check_both_photos
    if self.top_photo.is_a?(UIImage) && self.bottom_photo.is_a?(UIImage)
      self.outlets["save_button"].enabled = true
      self.outlets["save_button"].alpha = 1.0
    elsif self.documents.count > 0
      self.outlets["save_button"].enabled = true
      self.outlets["save_button"].alpha = 1.0      
    end
  end
  
  def sendPhotos
    self.front_document = Document.new if self.front_document.nil?
    self.front_document.attachment = top_photo
    self.front_document.attachment_mime_type = top_photo_mime_type
    self.front_document.profile_id = profile.remote_id
    self.front_document.position = 'front'
    self.front_document.approval_status = 'pending'

    self.back_document = Document.new if self.back_document.nil?
    self.back_document.attachment = bottom_photo
    self.back_document.attachment_mime_type = bottom_photo_mime_type
    self.back_document.profile_id = profile.remote_id
    self.back_document.position = 'back'
    self.front_document.approval_status = 'pending'
    
    self.document_manager = DocumentManager.shared_manager
    self.document_manager.delegate = self
  
    if self.front_document_changed
      uploadDocument('front')
    elsif self.back_document_changed
      uploadDocument('back')
    end
  end
  
  def uploadDocument(position)
    self.show_loading("Carregando...")

    self.current_document_upload = position
    
    unless position.nil?
      if self.send("#{position}_document").new_record?
        self.document_manager.create_resource(send("#{position}_document"))
      else
        self.document_manager.update_resource(send("#{position}_document"))
      end
    end
  end
  
  def resource_created(resource)
    self.dismiss_loading
    self.send("#{current_document_upload}_document=", resource)
    
    case current_document_upload
    when 'front'
      self.current_document_upload = nil
      self.front_document_changed = false
      if self.back_document_changed
        uploadDocument('back')
      else
        uploadsFinished
      end
    when 'back'
      self.current_document_upload = nil
      self.back_document_changed = false
      if self.front_document_changed
        uploadDocument('front')
      else
        uploadsFinished
      end
    end
  end
  
  def resource_updated(resource)
    self.dismiss_loading
    self.send("#{current_document_upload}_document=", resource)
    
    case current_document_upload
    when 'front'
      self.current_document_upload = nil
      self.front_document_changed = false
      if self.back_document_changed
        uploadDocument('back')
      else
        uploadsFinished
      end
    when 'back'
      self.current_document_upload = nil
      self.back_document_changed = false
      if self.front_document_changed
        uploadDocument('front')
      else
        uploadsFinished
      end
    end
  end
  
  def uploadsFinished
    self.check_controller.load_profile
    self.navigationController.popViewControllerAnimated(true)
  end
  
end