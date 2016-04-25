//
//  StatusesCell.swift
//  SwiftWeiBo
//
//  Created by Imanol on 16/4/18.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit
import SDWebImage

let collectionCellIdentifer = "cellIdentifer"
class StatusesCell: UITableViewCell {
    
    var widthConstraint : NSLayoutConstraint?
    var heightConstraint : NSLayoutConstraint?
    var statuses : Statuses?
        {
        didSet{
            context.text = statuses?.text
            name.text = statuses?.user?.name
            iconImageView.sd_setImageWithURL(statuses?.user?.avatarURL)
            userType.image = statuses?.user?.verifiedImage
            sourceFrom.text = statuses?.source
            date.text = statuses?.created_at
            mbrankImageView.image = statuses?.user?.mbrankImage
            
            let caculateSize = calculateSize()
            //picView的总体大小
            widthConstraint?.constant = caculateSize.totalSize.width
            heightConstraint?.constant = caculateSize.totalSize.height
            // cell的大小
            if caculateSize.itemSize == CGSizeZero
            {
                picLayout.itemSize = CGSizeMake(1, 1)
            }else{
                picLayout.itemSize = calculateSize().itemSize
            }
            // 刷新表格
            picViews.reloadData()

        }
    }
    
    func rowHeight(status : Statuses) ->CGFloat{
    
        //为了计算行高
        self.statuses = status
        //刷新 cell
        self.layoutIfNeeded()
        //返回底部最大的Y值
        return CGRectGetMaxY(bottomView.frame)
    }
    
    func calculateSize()->(totalSize:CGSize,itemSize:CGSize){
    
        // 取出配图个数
        let count = statuses?.picURLS?.count
        // 如果没有配图zero
        if count == 0 || count == nil
        {
            return (CGSizeZero,CGSizeZero)
        }
        //如果只有一张
        if count == 1
        {
            // 取出缓存的图片
            let key = statuses?.picURLS!.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            // 3.2返回缓存图片的尺寸
            return (image.size,image.size)

        }
        //如果有4张
        let width = 90
        let margin = 10
        if count == 4
        {
            let viewWidth = width * 2 + margin
            return (CGSize(width: viewWidth, height: viewWidth),CGSize(width: width, height: width))
        }
        
        //如果是其他张数
        // 列数
        let colNumber = 3
        // 计算行数
        //               (8 - 1) / 3 + 1
        let rowNumber = (count! - 1) / 3 + 1
        // 宽度 = 列数 * 图片的宽度 + (列数 - 1) * 间隙
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        // 高度 = 行数 * 图片的高度 + (行数 - 1) * 间隙
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return (CGSize(width: viewWidth, height: viewHeight),CGSize(width: width, height: width))

    }
    
    func setupPicViews(){
        picViews.registerClass(collectionCell.self, forCellWithReuseIdentifier: collectionCellIdentifer)
        picViews.dataSource = self
        picLayout.minimumInteritemSpacing = 10
        picLayout.minimumLineSpacing = 10
        picViews.backgroundColor = UIColor.whiteColor()
    }
    
    func setupUI(){
        
        iconImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(10)
        }
        
        userType.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.bottom.equalTo(iconImageView.snp_bottom).offset(5)
            make.right.equalTo(iconImageView.snp_right).offset(5)
        }
        
        name.snp_makeConstraints { (make) -> Void in
            //make.width.equalTo(100)
            make.left.equalTo(iconImageView.snp_right).offset(10)
            make.top.equalTo(iconImageView)
            
        }
        
        mbrankImageView.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(name.snp_right).offset(10)
            make.top.equalTo(name)
            
        }
        
        
        date.snp_makeConstraints { (make) -> Void in
            //make.width.equalTo(100)
            make.left.equalTo(iconImageView.snp_right).offset(10)
            make.top.equalTo(name.snp_bottom).offset(5)
            
        }
        
        sourceFrom.snp_makeConstraints { (make) -> Void in
           // make.width.equalTo(100)
            make.left.equalTo(date.snp_right).offset(10)
            make.top.equalTo(date)
            
        }
        
        context.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(iconImageView.snp_bottom).offset(10)
            make.left.equalTo(iconImageView)
            make.right.equalTo(contentView).offset(-15)
            
        }
        
        picViews.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(context.snp_bottom).offset(10)
            make.left.equalTo(context)
        }
        
        widthConstraint = NSLayoutConstraint(item: picViews, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150)
        heightConstraint = NSLayoutConstraint(item: picViews, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150)
        picViews.addConstraint(widthConstraint!)
        picViews.addConstraint(heightConstraint!)
        
        bottomView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(contentView)
            make.left.equalTo(contentView)
            make.top.equalTo(picViews.snp_bottom).offset(10)
            make.height.equalTo(35)
            //make.bottom.equalTo(contentView.snp_bottom).offset(-10)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(iconImageView)
        contentView.addSubview(userType)
        contentView.addSubview(name)
        contentView.addSubview(date)
        contentView.addSubview(sourceFrom)
        contentView.addSubview(context)
        contentView.addSubview(bottomView)
        contentView.addSubview(mbrankImageView)
        contentView.addSubview(picViews)
        //bottomView.backgroundColor = UIColor.grayColor()
        setupPicViews()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    ///MARK: - LAZY LOADING
    lazy var iconImageView : UIImageView = UIImageView()
    lazy var userType : UIImageView = UIImageView()
    
    lazy var name : UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        return label
    }()
    
    lazy var context : UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var sourceFrom : UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 13)
        return label
    }()
    
    lazy var date : UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 13)
        return label
    }()
    
    lazy var bottomView : statusBottomView = statusBottomView()
    lazy var mbrankImageView : UIImageView = UIImageView()
    lazy var picLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var picViews : UICollectionView = UICollectionView(frame: CGRectMake(0, 0, 100, 100), collectionViewLayout: self.picLayout)

}

extension StatusesCell : UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellIdentifer, forIndexPath: indexPath) as! collectionCell
        cell.imageURL = statuses?.picURLS![indexPath.row]
        //cell.backgroundColor = UIColor.greenColor()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statuses?.picURLS?.count ?? 0
    }
    
}

class collectionCell : UICollectionViewCell
{
    // jie收外界传入的数据
    var imageURL: NSURL?
        {
        didSet{
            imageView.sd_setImageWithURL(imageURL!)
        }
    }
    
    func setupUI(){
    
        contentView.addSubview(imageView)
        imageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView : UIImageView = UIImageView()
}


