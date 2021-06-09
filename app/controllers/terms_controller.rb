class TermsController < JsonController

    def viewDidLoad
        self.navigationController.navigationBar.hidden = true    
        self.title = "Termos de uso"
        loadbackbutton
        title_label = self.load_title

        super
    end

    def viewDidAppear(animated)
        super(animated)
    end

    def close
        self.dismissModalViewControllerAnimated(true, completion: nil)
    end

    def loadbackbutton
        button = UIButton.new
        self.view.addSubview(button)
        button.place_auto_layout(top: 20, leading: 10, width: 35, height: 35)
        button.setImage(UIImage.imageNamed("images/back-button.png"), forState: UIControlStateNormal)
        button.addTarget(self, action: NSSelectorFromString("close"), forControlEvents: UIControlEventTouchUpInside)
    end
    
end