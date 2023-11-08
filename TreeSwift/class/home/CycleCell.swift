//
//  CycleCell.swift
//  TreeSwift
//
//  Created by 冯子丰 on 2023/11/7.
//

import UIKit
class CycleCell: UICollectionViewCell {
    
    var urlImage: String = ""
    var imageView = UIImageView()
    var labelTitle = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubviews(frame: CGRect){
        imageView = UIImageView.init(frame: CGRectMake(25, 10, frame.size.width - 50, frame.size.height - 20))
        self.contentView.addSubview(imageView)
        
        labelTitle = UILabel.init(frame: CGRectMake(10, 10, 30, 30))
        imageView.addSubview(labelTitle)
    }
//    override func applyLayoutAttributes(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//        // do you something
//        
//    }
}
