//
//  ColorsVC+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 26/12/23.
//

import UIKit

extension ColorsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isColor ? self.viewModel.numberOfColors() : self.viewModel.numberOfMaterial()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as SingleSelectionCell
        cell.selectionStyle = .none
       
            if self.isColor {
                let data = self.viewModel.setColor(row: indexPath.row)
                cell.setColors(data: data)
                if self.isMultipleSelection {
                    
                    let color = self.viewModel.setColor(row: indexPath.row)
                    let commonIDs = Set(self.viewModel.arrColor.compactMap { $0.id })
                        .intersection(Set(self.arrSelect.compactMap { $0.id }))
                    
                    if (self.viewModel.arrColor.count - 1) == self.arrSelect.count {
                        cell.ivCheck.image = .icCheckboxSqr
                    } else {
                        if let colorId = color.id, commonIDs.contains(colorId) {
                            cell.ivCheck.image = .icCheckboxSqr
                        } else {
                            cell.ivCheck.image = .iconUncheckBox
                        }
                    }
                } else {
                    cell.ivCheck.image = (self.viewModel.setColor(row: indexPath.row).id == selectedID) ? .icCheckboxSqr :  .iconUncheckBox
                }
            } else {
                let mData = self.viewModel.setMaterial(row: indexPath.row)
                cell.setColors(data: mData)
                if self.isMultipleSelection {
                    let color = self.viewModel.setMaterial(row: indexPath.row)
                    let commonIDs = Set(self.viewModel.arrMaterial.compactMap { $0.id })
                        .intersection(Set(self.arrSelect.compactMap { $0.id }))
                    if (self.viewModel.arrMaterial.count - 1) == self.arrSelect.count {
                        cell.ivCheck.image = .icCheckboxSqr
                    } else {
                        if let colorId = color.id, commonIDs.contains(colorId) {
                            cell.ivCheck.image = .icCheckboxSqr
                        } else {
                            cell.ivCheck.image = .iconUncheckBox
                        }
                    }
                } else {
                    cell.ivCheck.image = (self.viewModel.setMaterial(row: indexPath.row).id == selectedID) ? .icCheckboxSqr :  .iconUncheckBox
                }
            }
        
        return cell
    }
    
}
