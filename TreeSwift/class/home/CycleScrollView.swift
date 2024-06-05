//
//  CycleScrollView.swift
//  TreeSwift
//
//  Created by 冯子丰 on 2023/11/7.
//


import UIKit
import Kingfisher

let sectionNum: Int = 100
let cellIdentifier: String = "cellIdentifier"
let width = ScreenWidth
let height = ScreenWidth
// 协议
protocol CycleViewDelegate {
    func didSelectIndexCollectionViewCell(index: Int)->Void

}

class CycleScrollView: UIView, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var delegate: CycleViewDelegate?
    var cycleCollectionView: UICollectionView?
    var images: [String] = Array()
    var pageControl = UIPageControl()
    var flowlayout = UICollectionViewFlowLayout()
    var timer:Timer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 创建collectionview
    func createSubviews(frame: CGRect){
        cycleCollectionView = UICollectionView.init(frame: CGRectMake(0, 0, frame.size.width, frame.size.height), collectionViewLayout: flowlayout)
        flowlayout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
        flowlayout.minimumInteritemSpacing = 0;
        flowlayout.minimumLineSpacing = 0;
        flowlayout.scrollDirection = UICollectionView.ScrollDirection.horizontal;

        cycleCollectionView!.backgroundColor = HexColor(value: 0xaa2d1b)
        cycleCollectionView!.isPagingEnabled = true
        cycleCollectionView!.dataSource  = self
        cycleCollectionView!.delegate = self
        cycleCollectionView!.showsHorizontalScrollIndicator = false
        cycleCollectionView!.showsVerticalScrollIndicator = false
        cycleCollectionView?.register(CycleCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.addSubview(cycleCollectionView!)
        
        pageControl = UIPageControl.init(frame: CGRectMake(0, 0, frame.size.width / 2, 30))
        pageControl.center = CGPointMake(frame.size.width / 2, frame.size.height - 20);
        self.addSubview(pageControl);
        self.addTimer()
    }
    func addTimer(){
        let timer1 = Timer.init(timeInterval: 1, target: self, selector: #selector(nextPageView), userInfo: nil, repeats: true)
        RunLoop.current.add(timer1, forMode: RunLoop.Mode.common)
        timer = timer1
    }
    
    func removeTimer(){
        self.timer!.invalidate()
    }
    
    func returnIndexPath()->IndexPath{
        var currentIndexPath = cycleCollectionView!.indexPathsForVisibleItems.last
        currentIndexPath = IndexPath.init(row: currentIndexPath!.row, section: sectionNum / 2)
        cycleCollectionView?.scrollToItem(at: currentIndexPath!, at: UICollectionView.ScrollPosition.left, animated: false)
        return currentIndexPath!;
    }
    
    @objc func nextPageView(){

        let indexPath = self.returnIndexPath()
        var item = indexPath.row + 1;
        var section = indexPath.section;
        if item == images.count {
            item = 0
            section+=1
        }
        self.pageControl.currentPage = item;
        let nextIndexPath = IndexPath.init(row: item, section: section)
        
        cycleCollectionView!.scrollToItem(at: nextIndexPath, at: UICollectionView.ScrollPosition.left, animated: true)

    }
    // Delegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CycleCell
        cell.labelTitle.text = NSString(format: "%d", indexPath.row) as String
        let url:String = self.images[indexPath.row] as! String
        cell.imageView.kf.setImage(with: URL(string: url))

        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionNum
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = images.count
        return images.count
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.addTimer()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.removeTimer()

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = (Int(scrollView.contentOffset.x) / Int(width)) % images.count
        pageControl.currentPage = page
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectIndexCollectionViewCell(index: indexPath.row)
    }
    
}
