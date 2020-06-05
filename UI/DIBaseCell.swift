/*
    DIBaseCell.swift
    dispatchinator

    Created by Calvin Gaisford on 6/5/20.
   
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

class DIBaseCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel?

    private var internalDispatchQoS: DispatchQoS = DispatchQoS.default

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
    }
    
    var dispatchQoS: DispatchQoS {
        get {
            return self.internalDispatchQoS
        }
        set(newValue) {
            self.internalDispatchQoS = newValue
            self.updateCellForQOS()
        }
    }

    func updateCellForQOS() {
        switch(dispatchQoS) {
            case .background:
                self.backgroundColor = UIColor.systemPurple
                break
            case .utility:
                self.backgroundColor = UIColor.systemIndigo
                break
            case .userInteractive:
                self.backgroundColor = UIColor.systemOrange
                break
            case .userInitiated:
                self.backgroundColor = UIColor.systemGreen
                break
            default:
                self.backgroundColor = UIColor.gray
                break
        }
    }

}
