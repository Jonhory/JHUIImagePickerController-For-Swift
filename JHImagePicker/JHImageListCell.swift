//
//  JHImageListCell.swift
//  EaseImagePickerController
//
//  Created by Jonhory on 2017/7/14.
//
//

import UIKit

let JHCellHeight: CGFloat = 57

private let JHImageListCellID = "JHImageListCellID"

class JHImageListCell: UITableViewCell {

    class func configWith(table: UITableView) -> JHImageListCell {
        var cell = table.dequeueReusableCell(withIdentifier: JHImageListCellID)
        if cell == nil {
            cell = JHImageListCell(style: .default, reuseIdentifier: JHImageListCellID)
        }
        return cell as! JHImageListCell
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        loadUI()
    }
    
    var item: JHListtem? {
        didSet {
            if item == nil { return }
            if let text = item!.title {
                titleLabel.text = text
            }
            countLabel.text = String.init(format: "(%d)", item!.result.count)
            
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint(x: titleLabel.center.x, y: JHCellHeight/2)
            
            countLabel.frame = CGRect(x: titleLabel.frame.maxX + 10, y: 0.0, width: 10.0, height: JHCellHeight)
            countLabel.sizeToFit()
            countLabel.center = CGPoint(x: countLabel.center.x, y: JHCellHeight/2)
        }
    }
    
    lazy var iconIV = UIImageView()
    lazy var titleLabel = UILabel()
    lazy var countLabel = UILabel()
    lazy var arrowIV = UIImageView()
    
    private func loadUI() {
        contentView.addSubview(iconIV)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(arrowIV)
        
        iconIV.frame = CGRect(x: 0, y: 0, width: JHCellHeight, height: JHCellHeight)
        iconIV.contentMode = .scaleAspectFill
        iconIV.clipsToBounds = true
        iconIV.image = UIImage(named: "jh_defaultIV")
        
        titleLabel.frame = CGRect(x: iconIV.frame.maxX + 5.0, y: 0.0, width: 10.0, height: JHCellHeight)
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor.black
        
        countLabel.frame = CGRect(x: titleLabel.frame.maxX + 10, y: 0.0, width: 10.0, height: JHCellHeight)
        countLabel.font = UIFont.systemFont(ofSize: 16)
        countLabel.textColor = UIColor.lightGray
        
        let arrowWH: CGFloat = 16
        arrowIV.image = UIImage(named: "jh_arrow")
        arrowIV.frame = CGRect(x: jhSCREEN.width - 11 - arrowWH, y: (JHCellHeight - arrowWH)/2, width: arrowWH, height: arrowWH)
        
        let line = UIView()
        line.backgroundColor = rgb(224, 224, 224)
        line.frame = CGRect(x: 20, y: JHCellHeight - 0.5, width: jhSCREEN.width - 20, height: 0.5)
        contentView.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
