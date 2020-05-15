/*
    DITask.swift
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

protocol DITaskDelegate : class {
    func progressMade(item: DITask, dispatchQueue: DispatchQueue?)
    func finished(item: DITask, dispatchQueue: DispatchQueue?)
}

class DITask: NSObject {

    public weak var delegate:DITaskDelegate?

    // create a DispatchQueue to protect our count variable and make it concurrent
    // this will allow multiple threads to read at the same time but the .barrier sync
    // on the write will protect it.  This is just an example of how to protect a variable
    // using a DispatchQueue
    private let internalQueue = DispatchQueue(label: "com.cgbits.dispatchinator.varlock", attributes: .concurrent )
    private var internalCount: Int = Int.random(in: 2 ..< 30)
    private var internalQualityOfService: DispatchQoS = DispatchQoS.unspecified
    private var internalIsBarrier: Bool = false
    private weak var taskQueue: DispatchQueue?

    var count: Int {
        get {
            return internalQueue.sync { self.internalCount }
        }
        set(newValue) {
            internalQueue.sync(flags: .barrier) { self.internalCount = newValue }
        }
    }

    var dispatchQoS: DispatchQoS {
        get {
            return self.internalQualityOfService
        }
    }

    var isBarrier: Bool {
        get {
            return self.internalIsBarrier
        }
    }

    
    func startAsync(queue: DispatchQueue, qos:DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = []) {

        self.taskQueue = queue
        self.internalQualityOfService = qos
        if(flags.contains(.barrier)) {
            self.internalIsBarrier = true
        }
        
        queue.async(qos: qos, flags: flags) {

            switch(Thread.current.qualityOfService) {
                case .background:
                    self.internalQualityOfService = DispatchQoS.background
                    break
                case .default:
                    self.internalQualityOfService = DispatchQoS.default
                    break
                case .userInitiated:
                    self.internalQualityOfService = DispatchQoS.userInitiated
                    break
                case .userInteractive:
                    self.internalQualityOfService = DispatchQoS.userInteractive
                    break
                case .utility:
                    self.internalQualityOfService = DispatchQoS.utility
                    break
                default:
                    self.internalQualityOfService = DispatchQoS.unspecified
            }
            
            while(self.count > 0 ) {
                Thread.sleep(forTimeInterval: 1)
                self.count -= 1
                self.delegate?.progressMade(item: self, dispatchQueue: self.taskQueue)
            }

            self.delegate?.finished(item: self, dispatchQueue: self.taskQueue)
        }
    }
    
}



