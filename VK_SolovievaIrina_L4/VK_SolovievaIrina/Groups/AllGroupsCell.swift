//
//  AllGroupsCell.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 25.12.2018.
//  Copyright © 2018 Ирина. All rights reserved.
//

import UIKit

class AllGroupsCell: UITableViewCell {
 
    @IBOutlet weak var allGroupName: UILabel!
    @IBOutlet weak var allGroupFoto: UIImageView!
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3, height: 3)

    // Прозрачность тени
    @IBInspectable var shadowOpacity: Float = 0.3

    //Радиус блура тени
    @IBInspectable var shadowRadius: CGFloat = 10

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
