//
//  CodeView.swift
//  VerificationCode
//
//  Created by Asun on 2018/8/10.
//  Copyright © 2018年 Asun. All rights reserved.
//

import UIKit

enum Length: AsunFloct {
    case onceWidth  = 40  //横线宽度
    case onceHeight = 1 //横线高度
    case spaceWidth = 10 //间隔宽度
}

class CodeView: UIView {
    
    var callBacktext:((String)->())?
    
    lazy var Base:AsunBasicAttributes = AsunBasicAttributes()
    
    lazy var textFiled = AsunText()
    
    lazy var lineArr:[UIView] = []
    
    lazy var labelArr:[UILabel] = []
    
    lazy var layerArr:[CALayer] = []
    
    var errorOrclean:String!
    
    lazy var width:CGFloat = CGFloat()
    lazy var height:CGFloat = CGFloat()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatTextView()
        creatInputLabel()
        creatLineView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        creatTextView()
        creatLineView()
        creatInputLabel()
    }
}

//MARK: CreatUI
extension CodeView {
    // MARK: CreatTextView
    fileprivate func creatTextView() {
        width = self.frame.size.width
        height = self.frame.size.height
        textFiled = Base.textFiled
        textFiled.becomeFirstResponder()
        textFiled.autocapitalizationType = .none
        textFiled.keyboardType = .numberPad
        addSubview(textFiled)
        
        textFiled.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    //MARK: CreatLineView
    fileprivate func creatLineView() {
        for num in 0 ..< Int(Base.codeNum) {
            //表达式太长 拆分两步骤
            let x = CGFloat(num)*Length.onceWidth.rawValue
            let x1 = CGFloat(num)*(width-Base.codeNum*Length.onceWidth.rawValue)/(Base.codeNum-1)
            let lineView = UIView(frame: CGRect(x: x+x1, y: height -  Length.onceHeight.rawValue, width: Length.onceWidth.rawValue, height: Length.onceHeight.rawValue))
            lineView.backgroundColor = Base.lineColor
            addSubview(lineView)
            lineArr.append(lineView)
        }
    }
    //MARK: CreatLabel
    fileprivate func creatInputLabel() {
        for num in 0 ..< Int(Base.codeNum) {
            //表达式太长 拆分两步骤
            let x = CGFloat(num)*Length.onceWidth.rawValue
            let x1 = CGFloat(num)*(width-Base.codeNum*Length.onceWidth.rawValue)/(Base.codeNum-1)
            let label = UILabel(frame: CGRect(x:x+x1, y: 0, width: Length.onceWidth.rawValue, height: height -  2))
            label.textColor = Base.textColor
            label.font = Base.fontNum
            label.textAlignment = .center
            let path = UIBezierPath(rect: CGRect(x: (label.frame.width-2)/2, y: 5, width: 2, height: label.frame.height-10))
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.fillColor = Base.cursorColor.cgColor
            addSubview(label)
            if num == 0 {
                lineLayer.isHidden = false
            } else {
                lineLayer.isHidden = true
            }
            label.layer.addSublayer(lineLayer)
            lineLayer.add(alphaChangge(), forKey: "alpha")
            labelArr.append(label)
            layerArr.append(lineLayer)
        }
    }
}

//MARK: Action
extension CodeView {
    @objc fileprivate func textFieldDidChange(filed:AsunText) {
        labelArr.forEach {
            $0.text = nil
        }
        for i in 0 ..< (textFiled.text?.count)! {
            (labelArr[i] as UILabel).isHidden = false
            (labelArr[i] as UILabel).text = textFiled.text?.subString(start: i, length: 1)
        }
        if errorOrclean == "error" {
            self.lineArr.forEach({ (view) in
                view.backgroundColor = self.Base.errorlineViewColor
                loadShakeAnimationForView(view: view)
            })
            
            UIView.animate(withDuration: 1) {
                self.lineArr.forEach({ (view) in
                    view.backgroundColor = self.Base.lineColor
                })
                for i in 0 ..< (self.textFiled.text?.count)! {
                    (self.lineArr[i] as UIView).backgroundColor = self.Base.lineInputColor
                }
            }
            errorOrclean = ""
        } else {
            lineArr.forEach { (view) in
                view.backgroundColor = self.Base.lineColor
            }
            for i in 0 ..< (self.textFiled.text?.count)! {
                (self.lineArr[i] as UIView).backgroundColor = self.Base.lineInputColor
            }
            
        }
        layerArr.forEach { (layer) in
            layer.isHidden = true
        }
        
        if (textFiled.text?.count)! < Int(Base.codeNum) {
            layerArr[(textFiled.text?.count)!].isHidden = false
        }
        
        if (textFiled.text?.count)! == Int(Base.codeNum) {
            if let call = self.callBacktext {
                call(textFiled.text!)
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textFiled.resignFirstResponder()
            return false
        } else if string.isEmpty {
            return true
        } else if (textField.text?.count)! >= Int(Base.codeNum) {
            return false
        } else {
            return true
        }
    }
    
    func clearnText(error:String) {
        self.errorOrclean = error
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {[unowned self] in
            self.textFiled.text = ""
            self.textFieldDidChange(filed: self.textFiled)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textFiled.becomeFirstResponder()
    }
}

//MARK: Animation
extension CodeView {
    public func alphaChangge() -> CABasicAnimation{
        let alpheAnimation = CABasicAnimation()
        alpheAnimation.keyPath = "opacity"
        alpheAnimation.fromValue = 1.0
        alpheAnimation.toValue = 0.0
        alpheAnimation.duration = 1.0
        alpheAnimation.repeatCount = MAXFLOAT
        alpheAnimation.fillMode = kCAFillModeForwards
        alpheAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        alpheAnimation.isRemovedOnCompletion = false
        return alpheAnimation
    }
    
    public func loadShakeAnimationForView(view:UIView) {
        let layer = view.layer
        let point = layer.position
        let y = CGPoint(x: point.x - 2, y: point.y)
        let x = CGPoint(x: point.x + 2, y: point.y)
        let animation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = x
        animation.toValue = y
        animation.autoreverses = true
        animation.duration = 0.1
        animation.repeatCount = 1
        layer.add(animation, forKey: nil)
    }
}
