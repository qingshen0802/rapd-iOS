class BrowseStoreCell < BaseCell

    attr_accessor :store
  
    def set_data(data = {})
      super(data)
      
      self.store = data[:store]
      self.backgroundColor = Theme.color('ffffff')
      self.outlets["store_background"].sd_setImageWithURL(NSURL.URLWithString(store.cover_photo_url), placeholderImage: nil)
      self.outlets["store_icon"].sd_setImageWithURL(NSURL.URLWithString(store.photo_url), placeholderImage: nil)
      
      if store.credits_amount
        self.outlets["info_label"].hidden = false
        self.outlets["info_label"].text = "Você tem R$#{store.credits_amount.to_s} em crédito"
      else
        self.outlets["info_label"].hidden = true
      end
      
      self.outlets["name_label"].text = store.full_name
      self.outlets["username_label"].text = "@" + store.username
      self.outlets["distance_label"].text = store.distance
      if store.discount_club_active
        self.outlets["discount_label"].text = "Ganhe #{store.discount_club_bonus_amount} no clube de desconto a cada R$ 20,00 gastos."
        self.outlets["discount_icon"].image = UIImage.imageNamed("images/browse_discount_club_selected")
      else
        self.outlets["discount_label"].text = ""
        self.outlets["discount_icon"].image = nil
      end
    end
  
end