//
//  AlbumManager.swift
//  album
//
//  Created by 林華淵 on 2022/3/31.
//

import Foundation
import Alamofire
import SwiftyJSON

class AlbumManager: NSObject{
    static let shardInstance = AlbumManager()
    
    var albumDatas: [AlbumData] = []
    var pageIndex: Int = 1
    
    let apiUrl = "https://travel.tycg.gov.tw/open-api/zh-tw/Media/Album?page="
    var header: HTTPHeaders = ["Accept": "application/json"]
    func getData(completion : @escaping ()->()){
        let urlString = apiUrl + "\(pageIndex)"
        AF.request(urlString, method: .get,headers: header)
            .responseJSON { responseJSON in
                switch responseJSON.result{
                case .success(let respData):
                    var tempAlbumData = AlbumData(pageIndex: self.pageIndex, idDatas: [])
                    var tempIdDatas: [AlbumIDData] = []
                    
                    let respDataJSON = JSON(respData)
                    let idDataArray = respDataJSON["Infos"]["Info"].arrayObject
                    
                    for idData in idDataArray!{
                        var tempAlbumIDData = AlbumIDData()
                        
                        let idDataJSON = JSON(idData)
                        tempAlbumIDData.modifiedTime = idDataJSON["Modified"].string ?? ""
                        
                        let imageDataArray = idDataJSON["Images"]["Image"].arrayObject
                        /// 如果只有一張圖片，arrayObject 會有問題
                        if imageDataArray == nil{
                            tempAlbumIDData.picUrl.append(idDataJSON["Images"]["Image"]["Src"].string ?? "")
                        }else{
                            for imageData in imageDataArray!{
                                let imageDataJSON = JSON(imageData)
                                tempAlbumIDData.picUrl.append(imageDataJSON["Src"].string ?? "")
                            }
                        }
                        
                        tempIdDatas.append(tempAlbumIDData)
                    }
                    tempAlbumData.idDatas = tempIdDatas
                    self.albumDatas.append(tempAlbumData)
                    completion()
                case .failure(let error):
                    print(error)
                    completion()
                }
            }
    }
}
