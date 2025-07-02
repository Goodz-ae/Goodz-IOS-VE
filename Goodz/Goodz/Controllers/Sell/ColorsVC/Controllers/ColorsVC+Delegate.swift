//
//  ColorsVC+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 26/12/23.
//

import UIKit

extension ColorsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isMultipleSelection {
            
            if self.isColor {
                let selectedColor = self.viewModel.setColor(row: indexPath.row)
                if selectedColor.id == self.viewModel.arrColor.first?.id ?? "" {
                    if let index = self.arrSelect.firstIndex(where: {$0.id == selectedColor.id}) {
                        self.arrSelect.removeAll()
                        selectALL = false
                    } else {
                        self.arrSelect = self.viewModel.arrColor
                        selectALL = true
                    }
                } else {
                    if selectALL {
                        selectALL = false
                        self.arrSelect.removeFirst()
                    }
                    if let index = self.arrSelect.firstIndex(where: {$0.id == selectedColor.id}) {
                        self.arrSelect.remove(at: index)
                    } else {
                        self.arrSelect.append(selectedColor)
                    }
                }
            } else {
                let selectedMat = self.viewModel.setMaterial(row: indexPath.row)
                if selectedMat.id == self.viewModel.arrMaterial.first?.id ?? "" {
                    if let index = self.arrSelect.firstIndex(where: {$0.id == selectedMat.id}) {
                        self.arrSelect.removeAll()
                        selectALL = false
                    } else {
                        self.arrSelect = self.viewModel.arrMaterial
                        selectALL = true
                    }
                } else {
                    if selectALL {
                        selectALL = false
                        self.arrSelect.removeFirst()
                    }
                    if let index = self.arrSelect.firstIndex(where: {$0.id == selectedMat.id}) {
                        self.arrSelect.remove(at: index)
                    } else {
                        self.arrSelect.append(selectedMat)
                    }
                }
            }
        } else {
            if self.selectedIndex == indexPath.row {
                self.selectedID = ""
                self.selectedIndex = -1
                
            } else {
                if self.isColor {
                    self.selectedID = self.viewModel.setColor(row: indexPath.row).id ?? ""
                } else {
                    self.selectedID = self.viewModel.setMaterial(row: indexPath.row).id ?? ""
                }
                self.selectedIndex = indexPath.row
            }
        }
        self.tbvColors.reloadData()
    }
}
