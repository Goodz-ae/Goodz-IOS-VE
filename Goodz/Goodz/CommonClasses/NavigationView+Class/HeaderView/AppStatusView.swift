//
//  AppStatusView.swift
//  Goodz
//
//  Created by Priyanka Poojara on 01/01/24.
//

import UIKit

class AppStatusView: UIView {
    
    // --------------------------------------------
    // MARK: - outlets
    // --------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables
    // --------------------------------------------
    
    var backButtonClicked : () -> Void = { }
    var rightButtonClicked : () -> Void = { }
    
    @IBInspectable open var textTitle : String = "Title" {
        didSet {
            self.updateTitle()
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    @IBAction func actionBtnBack(_ sender: UIButton) {
        backButtonClicked()
    }
    
    @IBAction func actionBtnRight(_ sender: UIButton) {
        rightButtonClicked()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    // Performs the initial setup.
    private func setupView() {
        
        let view = viewFromNibForClass()
        view.frame = bounds
        
        // Auto-layout stuff.
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Show the view.
        self.addSubview(view)
        self.updateUI()
        self.updateTitle()
        self.btnRight.isHidden = true
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    // --------------------------------------------
    
    private func updateTitle() {
        self.lblTitle.text = textTitle
    }
    
    // --------------------------------------------
    
    private func updateUI() {
        self.lblTitle.textColor = .themeBlack
        self.lblTitle.font(font: FontName.regular, size: .size16)
    }
    
}
