//
//  AlbumData.swift
//  album
//
//  Created by 林華淵 on 2022/3/31.
//

import Foundation

struct AlbumData {
    var pageIndex: Int?
    var idDatas: [AlbumIDData] = []
}

struct AlbumIDData {
    var modifiedTime: String?{
        didSet{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let inputDate = formatter.date(from: modifiedTime!)
            formatter.dateFormat = "dd, M月 yyyy"
            modifiedTime = formatter.string(from: inputDate!)
        }
    }
    var picUrl: [String] = []
}
