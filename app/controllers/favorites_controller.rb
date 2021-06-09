class FavoritesController < JsonController

  attr_accessor :favorites, :profile, :query
  
  def viewDidLoad
    self.title = "Seus Favoritos"
    super
    load_favorites
    back_button = self.load_back_button
    title_label = self.load_title    
    unless settings[:title_color].nil?
      title_label.textColor = Theme.color(settings[:title_color])
    end
  end
  
  def noContentLabelColor
    UIColor.whiteColor
  end
  
  def performSearch
    load_favorites
  end
  
  def load_favorites
    favorite_manager = FavoriteManager.shared_manager
    favorite_manager.delegate = self
    favorite_manager.fetch_all(profile_id: profile.remote_id, query: query)
  end
  
  def items_fetched(favorites)
    self.favorites = favorites
    self.data_table_view.reloadData
  end
  
  def favorites_rows
    favorites.map{|favorite|
      profile_photo = favorite.favorited.photo_url if !favorite.favorited.nil? && !favorite.favorited.photo_url.nil?
      {cell_type: "profile", name: favorite.favorited.full_name, username: favorite.favorited.username, photo: profile_photo, id: favorite.remote_id, profile_type: favorite.favorited.profile_type, action: "select_profile", action_param: favorite.favorited, inverse: true, disclosure: true}
    }
  end
  
  def table_data
    if self.favorites.nil? || self.favorites.to_a.count == 0
      []
    else
      [{rows: favorites_rows}]
    end
  end
  
  def show_profile(profile)
    public_profile_form = PublicProfileForm.new
    public_profile_form.profile = profile
    self.navigationController.pushViewController(public_profile_form, animated: true)
  end

end