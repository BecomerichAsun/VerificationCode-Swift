//
//  ViewController.Swift
//  验证码输入框
//
//  Created by Asun on 2018/8/14.
//  Copyright © 2018年 Asun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let code = CodeView(frame: CGRect(x: 63, y: 100, width: self.view.frame.size.width - 63*2, height: 40))
        
        //Change Basic Attributes
        /*
         code.Base.changeViewBasicAttributes(codeNum: 4, lineColor: UIColor.blue, lineInputColor: UIColor.black, cursorColor: UIColor.red, errorColor: UIColor.red, fontNum: UIFont.systemFont(ofSize: 20), textColor: UIColor.black)
        
         or
         
        code.Base.changeInputNum(num: 4)
         */
        
        //To obtain Input Text
        code.callBacktext = { str in
            if str == "1234" {
                
            } else {
                code.clearnText(error: "error")
            }
        }
        view.addSubview(code)
    }
}
