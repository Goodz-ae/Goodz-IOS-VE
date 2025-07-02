//
//  SubCategory+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit

extension SubCategoryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyAccountCell.reuseIdentifier) as! MyAccountCell
        cell.selectionStyle = .none
        let data = self.viewModel.setSubCategories(row: indexPath.row)
        cell.setSubCategory(data: data, lastRow: self.viewModel.numberOfRows(), currentRow: indexPath.row)
        let selectedCategory = customizationModel?.selectedItemsList?.filter{ $0.id == data.categoriesSubId }.first?.selectedSubItemsList?.compactMap{ $0.name }.joined(separator: ", ")
        cell.lblDescription.isHidden = false
        cell.lblDescription.text = opeonType == .comeFrromCustomization ? selectedCategory : nil
        return cell
    }
    
}
