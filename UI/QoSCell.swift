/*
    QoSCell.swift
    dispatchinator

    Created by Calvin Gaisford on 5/5/20.
   
    MIT License

    Copyright (c) 2020 Calvin Gaisford

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
*/

import UIKit

class QoSCell: DIBaseCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.darkGray.cgColor
    }

    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set(newValue) {
            super.isSelected = newValue
            if(newValue == true) {
                self.layer.borderColor = UIColor(named: "selectedBorder")?.cgColor
                self.layer.borderWidth = 1.5
            } else {
                self.layer.borderColor = UIColor.darkGray.cgColor
                self.layer.borderWidth = 0.5
            }
        }
    }
    
    override func updateCellForQOS() {
        super.updateCellForQOS()
        switch(dispatchQoS) {
            case .background:
                self.label?.text = "BG"
                break
            case .utility:
                self.label?.text = "UT"
                break
            case .userInteractive:
                self.label?.text = "UI"
                break
            case .userInitiated:
                self.label?.text = "IN"
                break
            default:
                self.label?.text = "UN"
                break
        }
    }
}
