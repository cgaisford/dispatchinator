/*
   QoSCell.swift
   dispatchinator

   Created by Calvin Gaisford on 5/5/20.
   Copyright 2020 Calvin Gaisford

   Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
   to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
   and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
   IN THE SOFTWARE.
*/

import UIKit

class QoSCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel?

    private var internalDispatchQoS: DispatchQoS = DispatchQoS.default
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.darkGray.cgColor
    }

    var dispatchQoS: DispatchQoS {
        get {
            return self.internalDispatchQoS
        }
        set(newValue) {
            self.internalDispatchQoS = newValue
            self.updateFromQOS()
        }
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
    
    private func updateFromQOS() {

        switch(dispatchQoS) {
            case .background:
                self.label?.text = "BG"
                self.backgroundColor = UIColor.systemPurple
                break
            case .utility:
                self.label?.text = "UT"
                self.backgroundColor = UIColor.systemIndigo
                break
            case .userInteractive:
                self.label?.text = "UI"
                self.backgroundColor = UIColor.systemOrange
                break
            case .userInitiated:
                self.label?.text = "IN"
                self.backgroundColor = UIColor.systemGreen
                break
            default:
                self.label?.text = "UN"
                self.backgroundColor = UIColor.gray
                break
        }
    }
}
