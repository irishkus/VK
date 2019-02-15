//
//  MyGroupCell.swift
//  VK_SolovievaIrina
//
//  Created by Ирина on 25.12.2018.
//  Copyright © 2018 Ирина. All rights reserved.
//

import UIKit

class MyGroupCell: UITableViewCell {

    @IBOutlet weak var fotoGroup: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3, height: 3)
    //        {
    //        didSet {
    //            setNeedsDisplay()
    //        }
    //    }
    
    /// Прозрачность тени
    @IBInspectable var shadowOpacity: Float = 0.3
    //        {
    //        didSet {
    //            setNeedsDisplay()
    //        }
    //    }
    
    /// Радиус блура тени
    @IBInspectable var shadowRadius: CGFloat = 10
    //        {
    //        didSet {
    //            setNeedsDisplay()
    //        }
    //    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
