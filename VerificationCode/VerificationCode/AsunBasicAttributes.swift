//
//  Extension-View.swift
//  VerificationCode
//
//  Created by Asun on 2018/8/10.
//  Copyright © 2018年 Asun. All rights reserved.
//

import UIKit

typealias AsunText = UITextField
typealias AsunFloct = CGFloat

protocol AsunCodeProtocol {
    // 输入框
    var textFiled:AsunText {get}
    // 位数
    var codeNum:AsunFloct {get set}
    // 未输入的下划线颜色
    var lineColor:UIColor {get set}
    // 输入的下划线颜色
    var lineInputColor:UIColor {get set}
    // 输入错误下划线x颜色
    var errorlineViewColor:UIColor {get set}
    // 光标颜色
    var cursorColor:UIColor {get set}
    // 文本字体大小
    var fontNum:UIFont {get set}
    // 文本颜色
    var textColor:UIColor {get set}
    
    // 更改属性的方法
    mutating func changeViewBasicAttributes(lineColor:UIColor,lineInputColor:UIColor,cursorColor:UIColor,errorColor:UIColor,fontNum:UIFont,textColor:UIColor)
    
    mutating func changeInputNum(num:AsunFloct)
}
//属性默认值
struct AsunBasicAttributes:AsunCodeProtocol {
    var textFiled: AsunText = UITextField()
    var codeNum: AsunFloct = 0
    var lineColor: UIColor = UIColor.gray
    var lineInputColor: UIColor = UIColor.blue
    var errorlineViewColor: UIColor = UIColor.red
    var cursorColor: UIColor = UIColor.black
    var fontNum: UIFont = UIFont.systemFont(ofSize: 17)
    var textColor: UIColor = UIColor.black
}

extension AsunBasicAttributes {
   mutating func changeViewBasicAttributes( lineColor: UIColor, lineInputColor: UIColor, cursorColor: UIColor, errorColor: UIColor, fontNum: UIFont, textColor: UIColor) {
        self.lineColor = lineColor
        self.lineInputColor = lineInputColor
        self.cursorColor = cursorColor
        self.fontNum = fontNum
        self.textColor = textColor
        self.errorlineViewColor = errorColor
    }
    mutating func changeInputNum(num: AsunFloct) {
        self.codeNum = num
    }
}

extension String {
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
}
