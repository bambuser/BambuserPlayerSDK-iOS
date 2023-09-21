//
//  HomeViewController+LoadCells.swift
//  Demo
//
//  Created by Anton Yereshchenko on 08.06.2023.
//  Copyright © 2023 Bambuser AB. All rights reserved.
//

import UIKit

extension HomeViewController {
    func updateHeaderTitles() {
        headerTitles = [
            "Player",
            "Localization",
            "Configuration",
            settings.automaticallyLoadNextShow ? "Upcoming shows" : nil,
            "Picture-In-Picture",
            "UI Overlays",
            "Action Bar",
            "Products"
        ].compactMap({ $0 })
    }
    
    func upcomingCells() -> [UITableViewCell]? {
        var upcomingCells: [UITableViewCell] = []
        
        // Cells with show ids
        for (index, id) in settings.upcomingShows.enumerated() {
            let imageName = "\(index + 1).circle.fill"
            
            let item = HomeCellViewModel(
                title: String(),
                image: UIImage(systemName: imageName),
                value: id,
                onValueChanged: { [weak self] value in
                    self?.settings.upcomingShows[index] = value
                }
            )
            
            upcomingCells.append(
                HomeTextFieldCell(item: item)
            )
        }
        
        // Cell with Plus button
        upcomingCells.append(
            HomeCenteredImageCell(
                image: UIImage(systemName: "plus")
            )
        )
        
        return upcomingCells
    }
}
