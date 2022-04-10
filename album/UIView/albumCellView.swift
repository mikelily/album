//
//  albumCellView.swift
//  album
//
//  Created by 林華淵 on 2022/4/5.
//

import UIKit
import SnapKit

class AlbumCellView: UIView {

    var modifiedTime: String?
    var picUrl: [String] = []
    var picViews: [UIImageView] = []
    
    func loadImage(){
        for index in 0..<picViews.count{
            if picViews[index].image == UIImage(systemName: "rays"){
                picViews[index].downloaded(from: picUrl[index],contentMode: .scaleToFill)
            }
        }
    }

    func setCell(){
        let num = picUrl.count
        picViews = [] // init
        for index in 0..<num{
            let level = index / 10
            let posion = index % 10
            
            let picView = UIImageView()
            picView.layer.cornerRadius = 5
            self.addSubview(picView)
            picViews.append(picView)
            
            picView.backgroundColor = .lightGray
            picView.image = UIImage(systemName: "rays")
            
            switch posion{
            case 0:
                picView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(
                        cellPadding +
                        (cellPadding*2 + cellHeightBig*2) * CGFloat(level)
                    )
                    make.left.equalToSuperview().offset(cellPadding)
                    make.width.equalTo(cellWidthBig)
                    make.height.equalTo(cellHeightBig)
                }
            case 1,2,3,4:
//                print("1~4")
                picView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(
                        cellPadding +
                        (cellPadding*2 + cellHeightBig*2) * CGFloat(level) +
                        (cellHeightLittle + cellPadding) * CGFloat((posion - 1)/2)
                    )
                    make.left.equalTo(self.snp.centerX).offset(
                        cellPadding/2 +
                        CGFloat((posion - 1)%2) * (cellWidthLittle + cellPadding)
                    )
                    make.width.equalTo(cellWidthLittle)
                    make.height.equalTo(cellHeightLittle)
                }
            case 5,6,7,8:
//                print("5~8")
                picView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(
                        cellPadding*2 +
                        cellHeightBig +
                        (cellPadding*2 + cellHeightBig*2) * CGFloat(level) +
                        (cellHeightLittle + cellPadding) * CGFloat((posion - 5)/2)
                    )
                    make.left.equalToSuperview().offset(
                        cellPadding +
                        CGFloat((posion - 1)%2) * (cellWidthLittle + cellPadding)
                    )
                    make.width.equalTo(cellWidthLittle)
                    make.height.equalTo(cellHeightLittle)
                }
            case 9:
//                print("9")
                picView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(
                        cellPadding*2 +
                        cellHeightBig +
                        (cellPadding*2 + cellHeightBig*2) * CGFloat(level)
                    )
                    make.right.equalToSuperview().offset(-cellPadding)
                    make.width.equalTo(cellWidthBig)
                    make.height.equalTo(cellHeightBig)
                }
            default:
                print("Error @ switch posion")
            }
            
        }
    }
}
