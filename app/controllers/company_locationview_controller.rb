class GoogleMapsController < JsonController
    attr_accessor :coordinates, :store

    def viewDidLoad 
        self.title = store.full_name
        title_label = self.load_title
        self.navigationItem.titleView = title_label

        super
        load_backbutton
    end 

    def loadView
        camera = GMSCameraPosition.cameraWithLatitude(40.730610, longitude: -73.935242, zoom: 10)
        @map_view = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        @map_view.myLocationEnabled = false
        self.view = @map_view

        geocoder = CLGeocoder.alloc.init
        geocoder.geocodeAddressString store.address,
            completionHandler: lambda { |places, error|
                if !places.blank?
                    coordinates = places.first.location.coordinate
                    p store
                    camera = GMSCameraPosition.cameraWithLatitude(coordinates.latitude, longitude: coordinates.longitude, zoom: 10)
                    @map_view.animateToCameraPosition(camera)
                    marker = GMSMarker.alloc.init
                    marker.position = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
                    marker.title = store.full_name
                    marker.snippet = store.description
                    marker.map = @map_view
                end
            }
    end

    def load_backbutton
        button = UIButton.new
        self.view.addSubview(button)
        button.place_auto_layout(top: 20, leading: 10, width: 35, height: 35)
        button.setImage(UIImage.imageNamed("images/back-button.png"), forState: UIControlStateNormal)
        button.addTarget(self, action: NSSelectorFromString("back"), forControlEvents: UIControlEventTouchUpInside)
        back_button = UIBarButtonItem.alloc.initWithCustomView(button)
        self.navigationItem.leftBarButtonItem = back_button
    end

    def back
        self.navigationController.popViewControllerAnimated(true)
    end
end