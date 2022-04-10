//
//  GlobalVar.swift
//  album
//
//  Created by 林華淵 on 2022/4/5.
//

import Foundation
import UIKit

/// 取得裝置大小
let fullScreenSize = UIScreen.main.bounds.size

let statusBarHeight = UIApplication.shared.statusBarFrame.height
let bottomSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0

/// 設定 cell 大小
let cellPadding: CGFloat = 10
let cellWidthBig = fullScreenSize.width/2 - cellPadding*1.5
let cellWidthLittle = (fullScreenSize.width/2 - cellPadding*2.5) / 2

let cellHeightLittle = cellWidthLittle
let cellHeightBig = cellWidthLittle * 2 + cellPadding


