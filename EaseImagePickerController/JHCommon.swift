//
//  JHCommon.swift
//  RxSwiftLearn
//
//  Created by Jonhory on 2017/6/20.
//  Copyright © 2017年 jonhory. All rights reserved.
//

import Foundation
import UIKit

//MARK: - 常量
let SCREEN = UIScreen.main.bounds.size
let SCREEN_W = SCREEN.width
let SCREEN_H = SCREEN.height

let CurrentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let SandboxVersion = UserDefaults.standard.object(forKey: "CFBundleShortVersionString") as? String ?? ""

//MARK: - 常用方法
func rgb(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat) -> UIColor {
    return rgba(r, g, b, 1.0)
}

func rgba(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func iPhone5() -> Bool {
    return SCREEN_W < 375
}

func iPhonePlus() -> Bool {
    return SCREEN_W > 375
}

/// 限制文本输入长度的方法，因为用了NS，所以单独抽出来方便以后修改
func wtextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, maxLength max: Int) -> Bool {
    let currentString: NSString = textField.text! as NSString
    let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
    return newString.length <= max
}

/// 字符串长度
func count(_ string: String?) -> Int {
    if string == nil { return 0 }
    return string!.characters.count
}

/// 自定义Log
///
/// - Parameters:
///   - messsage: 正常输出内容
///   - file: 文件名
///   - funcName: 方法名
///   - lineNum: 行数
func WLog<T>(_ messsage: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName):(\(lineNum))======>>>>>>\n\(messsage)")
    #endif
}

//MARK: - Extension

extension Optional {
    var orNil : String {
        if self == nil {
            return ""
        }
        if "\(Wrapped.self)" == "String" {
            return "\(self!)"
        }
        return "\(self!)"
    }
}

extension UIColor {
    //返回随机颜色
    open class var randomColor:UIColor{
        get{
            let red = CGFloat(arc4random() % 256) / 255.0
            let green = CGFloat(arc4random() % 256) / 255.0
            let blue = CGFloat(arc4random() % 256) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}


extension String {
    // url encode
    var urlEncode:String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    // url decode
    var urlDecode :String? {
        return self.removingPercentEncoding
    }
    
    func sizeWidth(btn: UIButton) -> Double {
        return Double(self.size(attributes: [NSFontAttributeName:
            UIFont(name: (btn.titleLabel?.font.fontName)!, size: (btn.titleLabel?.font.pointSize)!)!]).width)
    }
    
    /**
     生成随机字符串,
     
     - parameter length: 生成的字符串的长度
     
     - returns: 随机生成的字符串
     */
    static func randomStr(length: Int) -> String {
        var ranStr = ""
        let randomStr = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(randomStr.characters.count)))
            ranStr.append(randomStr[randomStr.index(randomStr.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
}

