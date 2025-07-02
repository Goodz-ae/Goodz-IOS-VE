import UIKit

class CountyDetailCell: UITableViewCell {
    
    // --------------------------------------------
    // MARK: Outlets
    // --------------------------------------------
    
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func applyStyle() {
        self.lblTitle.font(font: .medium, size: .size14)
        self.lblTitle.color(color: .themeBlack)
        
        self.lblCountryCode.font(font: .medium, size: .size14)
        self.lblCountryCode.color(color: .themeBlack)
    }
    
    // --------------------------------------------
    
    func setData(data: CountryListModel) {
        self.lblTitle.text = data.countryName
        self.lblCountryCode.text = data.countryCode
    }
    
    // --------------------------------------------
    
}
