//
//  ViewController.swift
//  album
//
//  Created by 林華淵 on 2022/3/28.
//

import UIKit

class ViewController: UIViewController{
    
    var vcPageIndex: Int?
    let shardInstance = AlbumManager.shardInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBasicViews()
        loadData {
            print("First load end")
        }
    }
    
    let headerLabel = UILabel()
    let containerView = UIView()
    var refreshControl: UIRefreshControl!
    func setBasicViews(){
        headerLabel.text = ""
        headerLabel.textColor = .black
        headerLabel.font = .systemFont(ofSize: 25)
        view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(statusBarHeight+10)
        }
        
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomSafeAreaHeight)
        }
        
        // 生成 refreshControl
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(ViewController.refresh), for: UIControl.Event.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "loading...")
        scrollView.addSubview(self.refreshControl)
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    @objc func refresh() {
        self.loadData {
            self.refreshControl.endRefreshing()
        }
    }
    
    func loadData(completion : @escaping ()->()){
        vcPageIndex = vcPageIndex == nil ? 1 : vcPageIndex! + 1
        shardInstance.pageIndex = vcPageIndex!
        shardInstance.getData {
            self.setContainerView()
            
            completion()
        }
    }
    
    var cellViews: [AlbumCellView] = []
    var heightArray: [CGFloat] = []
    func setContainerView(){
        
        for sv in containerView.subviews{
            sv.removeFromSuperview()
        }
        headerLabel.text = shardInstance.albumDatas[vcPageIndex! - 1].idDatas[0].modifiedTime
        let idDatas: [AlbumIDData] = shardInstance.albumDatas[vcPageIndex! - 1].idDatas
        
        // init
        cellViews = []
        heightArray = []
        
        var tempHeight: CGFloat = 0
        
        for index in 0..<idDatas.count{
            let cellView = AlbumCellView()
            cellView.modifiedTime = idDatas[index].modifiedTime
            cellView.picUrl = idDatas[index].picUrl
            cellView.setCell()
            
            cellView.tag = index    // for check
            
            containerView.addSubview(cellView)
            cellViews.append(cellView)
            
            /// 幾層 cell
            let level = (idDatas[index].picUrl.count - 1) / 5 + 1
            var cellViewHeight: CGFloat = CGFloat(level)*cellHeightBig  + CGFloat(level+1)*cellPadding
            
            if idDatas[index].picUrl.count % 10 == 6 || idDatas[index].picUrl.count % 10 == 7{
                cellViewHeight = cellViewHeight - cellPadding - cellHeightLittle
            }
            
            tempHeight += cellViewHeight
            heightArray.append(tempHeight)
            
            if index == 0{
                // first
                cellView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(cellPadding)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(cellViewHeight)
                }
            }else if index != idDatas.count - 1{
                // mid
                cellView.snp.makeConstraints { make in
                    make.top.equalTo(cellViews[index - 1].snp.bottom)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(cellViewHeight)
                }
            }else{
                // last
                cellView.snp.makeConstraints { make in
                    make.top.equalTo(cellViews[index - 1].snp.bottom)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(cellViewHeight)
                    make.bottom.equalToSuperview().offset(-cellPadding)
                }
            }
            
            // 先讀五筆
            if index < 5 {
                cellView.loadImage()
            }
        }
    }
    
    func isVisible(view: UIView) -> Bool {
        func isVisible(view: UIView, inView: UIView?) -> Bool {
            guard let inView = inView else { return true }
            let viewFrame = inView.convert(view.bounds, from: view)
            if viewFrame.intersects(inView.bounds) {
                return isVisible(view: view, inView: inView.superview)
            }
            return false
        }
        return isVisible(view: view, inView: view.superview)
    }
}

extension ViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if vcPageIndex! == shardInstance.albumDatas.count{
            for index in 0..<heightArray.count{
                if index == 0{
                    if y < heightArray[0]{
                        headerLabel.text = shardInstance.albumDatas[vcPageIndex! - 1].idDatas[0].modifiedTime
                    }
                }else{
                    if y > heightArray[index - 1] && y < heightArray[index]{
                        headerLabel.text = shardInstance.albumDatas[vcPageIndex! - 1].idDatas[index].modifiedTime
                    }
                }
            }

        }
        
        for cellView in cellViews{
            if isVisible(view: cellView){
                cellView.loadImage()
//                print(cellView.tag)
            }
        }
    }
    
}
