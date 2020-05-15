/*
   MainCollectionViewController.swift
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

class MainCollectionViewController: UICollectionViewController, DITaskDelegate {

    var localConcurrentQueue = DispatchQueue(label: "com.cgbits.LocalConcurrentQueue", attributes: .concurrent)
    var localSerialQueue = DispatchQueue(label: "com.cgbits.LocalDispatchQueue")
    var dispatchQoS: DispatchQoS = .userInitiated

    var globalTasks = [DITask]()
    var concurrentTasks = [DITask]()
    var serialTasks = [DITask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Dispatch-inator"
    }

    
    
    //MARK: - DispatchQueue Helper Methods
    
    @objc func addBarrierButtonTapped(sender: AnyObject?) {
        if let addButton = sender as? UIButton {
            addNewDITask(addButton.tag, true)
        }
    }
    
    @objc func addButtonTapped(sender: AnyObject?) {
        if let addButton = sender as? UIButton {
            addNewDITask(addButton.tag, false)
        }
    }

    func addNewDITask(_ section:Int, _ addBarrier:Bool = false ) {

        var row = 0

        let diTask = DITask()
        diTask.delegate = self
        var flags:DispatchWorkItemFlags = []
        if(addBarrier) {
            flags = .barrier
        }
        
        switch(section) {
            case 1:
                globalTasks.append(diTask)
                row = globalTasks.count - 1
                diTask.startAsync(queue: DispatchQueue.global(), qos: self.dispatchQoS, flags: flags)
                break
            case 2:
                concurrentTasks.append(diTask)
                row = concurrentTasks.count - 1
                diTask.startAsync(queue: localConcurrentQueue, qos: self.dispatchQoS, flags: flags)
                break
            case 3:
                serialTasks.append(diTask)
                row = serialTasks.count - 1
                diTask.startAsync(queue: localSerialQueue, qos: self.dispatchQoS, flags: flags)
                break
            default:
                break
        }

        self.collectionView.insertItems(at: [IndexPath(row: row, section: section)])
    }


    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch(section) {
            case 0:
                return 4
            case 1:
                return globalTasks.count
            case 2:
                return concurrentTasks.count
            case 3:
                return serialTasks.count
            default:
                return 0
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DIHeaderView", for: indexPath) as! DIHeaderView

        switch(indexPath.section) {
            case 0:
                headerView.label?.text = "Dispatch Quality of Service"
                headerView.addButton?.isHidden = true
                headerView.addBarrierButton?.isHidden = true
                break
            case 1:
                headerView.label?.text = "Global Dispatch Queue"
                headerView.addButton?.isHidden = false
                headerView.addBarrierButton?.isHidden = false
                
                // set the UIButton tags to the corresponding row where the items should be places when added
                headerView.addButton?.tag = 1
                headerView.addBarrierButton?.tag = 1
                headerView.addButton?.addTarget(self, action: #selector(addButtonTapped), for: UIControl.Event.touchUpInside)
                headerView.addBarrierButton?.addTarget(self, action: #selector(addBarrierButtonTapped), for: UIControl.Event.touchUpInside)
                break
            case 2:
                headerView.label?.text = "Concurrent Dispatch Queue"
                headerView.addButton?.isHidden = false
                headerView.addBarrierButton?.isHidden = false

                // same as case 1 above
                headerView.addButton?.tag = 2
                headerView.addBarrierButton?.tag = 2
                headerView.addButton?.addTarget(self, action: #selector(addButtonTapped), for: UIControl.Event.touchUpInside)
                headerView.addBarrierButton?.addTarget(self, action: #selector(addBarrierButtonTapped), for: UIControl.Event.touchUpInside)
                break
            case 3:
                headerView.label?.text = "Serial Dispatch Queue"
                headerView.addButton?.isHidden = false
                headerView.addBarrierButton?.isHidden = false

                // same as case 1 above
                headerView.addButton?.tag = 3
                headerView.addBarrierButton?.tag = 3
                headerView.addButton?.addTarget(self, action: #selector(addButtonTapped), for: UIControl.Event.touchUpInside)
                headerView.addBarrierButton?.addTarget(self, action: #selector(addBarrierButtonTapped), for: UIControl.Event.touchUpInside)
                break
            default:
                headerView.label?.text = nil
        }
        
        return headerView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch(indexPath.section) {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QoSCell", for: indexPath) as! QoSCell
                switch(indexPath.row) {
                    case 0:
                        cell.dispatchQoS = .userInteractive
                        break
                    case 1:
                        cell.dispatchQoS = .userInitiated
                        break
                    case 2:
                        cell.dispatchQoS = .utility
                        break
                    case 3:
                        cell.dispatchQoS = .background
                        break
                    default:
                        cell.dispatchQoS = .default
                        break
                }
                
                return cell

            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DITaskCell", for: indexPath) as! DITaskCell
                let item = globalTasks[indexPath.row]
                cell.updateFromTask(task: item)
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DITaskCell", for: indexPath) as! DITaskCell
                let item = concurrentTasks[indexPath.row]
                cell.updateFromTask(task: item)
                return cell
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DITaskCell", for: indexPath) as! DITaskCell
                let item = serialTasks[indexPath.row]
                cell.updateFromTask(task: item)
                return cell

            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DITaskCell", for: indexPath) as! DITaskCell
                return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 0) {
            let cell = self.collectionView.cellForItem(at: indexPath) as! QoSCell
            self.dispatchQoS = cell.dispatchQoS
        }
    }

    
    // MARK: - CDItemProgressDelegate Methods

    func progressMade(item: DITask, dispatchQueue: DispatchQueue?) {

        // switch to the main thread and update the DITask's cell
        DispatchQueue.main.async {
            if(dispatchQueue == self.localConcurrentQueue) {
                if let itemIndex = self.concurrentTasks.firstIndex(of: item) {
                    if let cell = self.collectionView.cellForItem(at: IndexPath(row: itemIndex, section: 2)) as? DITaskCell {
                        cell.updateFromTask(task: item)
                    }
                }
            } else if(dispatchQueue == self.localSerialQueue) {
                if let itemIndex = self.serialTasks.firstIndex(of: item) {
                    if let cell = self.collectionView.cellForItem(at: IndexPath(row: itemIndex, section: 3)) as? DITaskCell {
                        cell.updateFromTask(task: item)
                    }
                }
            } else {
                if let itemIndex = self.globalTasks.firstIndex(of: item) {
                    if let cell = self.collectionView.cellForItem(at: IndexPath(row: itemIndex, section: 1)) as? DITaskCell {
                        cell.updateFromTask(task: item)
                    }
                }
            }
        }
    }

    
    func finished(item: DITask, dispatchQueue: DispatchQueue?) {

        // switch to the main thread and remove the DITask's cell
        DispatchQueue.main.async {
            if(dispatchQueue == self.localConcurrentQueue) {
                if let itemIndex = self.concurrentTasks.firstIndex(of: item) {
                    self.concurrentTasks.remove(at: itemIndex)
                    self.collectionView.deleteItems(at: [IndexPath(row: itemIndex, section: 2)])
                }
            } else if(dispatchQueue == self.localSerialQueue) {
                if let itemIndex = self.serialTasks.firstIndex(of: item) {
                    self.serialTasks.remove(at: itemIndex)
                    self.collectionView.deleteItems(at: [IndexPath(row: itemIndex, section: 3)])
                }
            } else {
                if let itemIndex = self.globalTasks.firstIndex(of: item) {
                    self.globalTasks.remove(at: itemIndex)
                    self.collectionView.deleteItems(at: [IndexPath(row: itemIndex, section: 1)])
                }
            }
        }
    }

}
