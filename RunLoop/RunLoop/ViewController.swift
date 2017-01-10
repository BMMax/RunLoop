//
//  ViewController.swift
//  RunLoop
//
//  Created by user on 17/1/9.
//  Copyright © 2017年 mobin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate static let CellHeight: CGFloat = 150.0
    //lazy var path: String = String()
    fileprivate static var imagePath : String = Bundle.main.path(forResource: "spaceship", ofType: "jpg") ?? ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }

    
    
}
 //MARK: - TableView代理
extension ViewController: UITableViewDelegate ,UITableViewDataSource{
    private static let isUseRunLoop = true
    private static let identifier = "CellID"

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 339
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ViewController.CellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ViewController.identifier)
        
        if cell == nil {
        
            cell = UITableViewCell(style: .default, reuseIdentifier: ViewController.identifier)
            
        }
        
        ViewController.task_5(cell: cell!, indexPaht: indexPath)
        ViewController.task_1(cell: cell, indexPaht: indexPath)
        if ViewController.isUseRunLoop { //使用runloop优化
            
            cell?.currentIndexPath = indexPath
            print("get------\(cell?.currentIndexPath)")

            let current = cell?.currentIndexPath
            MBRunLoopDitribution.share.addTask(unit: { () -> Bool in
                
                if current != indexPath{
                    
                    return false
                }
                
                let imageview1 = UIImageView(frame: CGRect(x: 105, y: 30, width: 85, height: 85))
                imageview1.tag = 2
                imageview1.image = UIImage(contentsOfFile: ViewController.imagePath)
                
                
                UIView.transition(with: (cell?.contentView)!, duration: 0.3, options: [.curveEaseInOut,.transitionCrossDissolve], animations: {
                    
                    cell?.contentView.addSubview(imageview1)
                }, completion: nil)
                
                return true
                
            }, key: indexPath)
           
            
            MBRunLoopDitribution.share.addTask(unit: { () -> Bool in
                if current != indexPath{
                
                    return false
                }
                let imageview2 = UIImageView(frame: CGRect(x: 200, y: 30, width: 85, height: 85))
                imageview2.tag = 4
                
                imageview2.image = UIImage(contentsOfFile: ViewController.imagePath)
                UIView.transition(with: (cell?.contentView)!, duration: 0.3, options: [.curveEaseInOut,.transitionCrossDissolve], animations: {
                    cell?.contentView.addSubview(imageview2)
                }, completion: nil)
               // ViewController.task_3(cell: cell, indexPaht: indexPath)
                return true
            
            }, key: indexPath)
            
            MBRunLoopDitribution.share.addTask(unit: { () -> Bool in
                
                if current != indexPath{
                
                    return false
                }
                
                let label2 = UILabel(frame: CGRect(x: 5, y: 115, width: 300, height: 35))
                label2.backgroundColor = UIColor.clear
                label2.lineBreakMode = .byWordWrapping
                label2.numberOfLines = 0
                label2.textColor = UIColor.blue
                label2.text = "Drawing \(indexPath.row) is top priority.Should be distributed into different run loop passes"
                label2.font = UIFont.boldSystemFont(ofSize: 13)
                label2.tag = 3
                cell?.contentView.addSubview(label2)
                
                
                let imageview3 = UIImageView(frame: CGRect(x: 5, y: 30, width: 85, height: 85))
                imageview3.tag = 5
                imageview3.image = UIImage(contentsOfFile: ViewController.imagePath)
                
                UIView.transition(with: (cell?.contentView)!, duration: 0.3, options: [.curveEaseInOut,.transitionCrossDissolve], animations: {
                    
                    cell?.contentView.addSubview(imageview3)
                }, completion: nil)
                
                //ViewController.task_4(cell: cell, indexPaht: indexPath)
                return true
                
            
            }, key: indexPath)
            print("Current---------\(RunLoop.current.currentMode)")
            return cell!
            
        
        }else{ //卡顿
            
            
            let imageview1 = UIImageView(frame: CGRect(x: 105, y: 30, width: 85, height: 85))
            imageview1.tag = 2
            let path = Bundle.main.path(forResource: "spaceship", ofType: "jpg") ?? ""
            imageview1.image = UIImage(contentsOfFile: path)
            
            cell?.contentView.addSubview(imageview1)
            
            
            let label2 = UILabel(frame: CGRect(x: 5, y: 115, width: 300, height: 35))
            label2.backgroundColor = UIColor.clear
            label2.lineBreakMode = .byWordWrapping
            label2.numberOfLines = 0
            label2.textColor = UIColor.blue
            label2.text = "Drawing \(indexPath.row) is top priority.Should be distributed into different run loop passes"
            label2.font = UIFont.boldSystemFont(ofSize: 13)
            label2.tag = 3
            cell?.contentView.addSubview(label2)
            
            let imageview2 = UIImageView(frame: CGRect(x: 200, y: 30, width: 85, height: 85))
            imageview2.tag = 4
            imageview2.image = UIImage(contentsOfFile: path)
            
            cell?.contentView.addSubview(imageview2)
            
            let imageview3 = UIImageView(frame: CGRect(x: 5, y: 30, width: 85, height: 85))
            imageview3.tag = 5
            imageview3.image = UIImage(contentsOfFile: path)
            cell?.contentView.addSubview(imageview3)
            
            print("Current---------\(RunLoop.current.currentMode)")

            return cell!;

        
        }
        
    }
}


// MARK: - Task
extension ViewController{


    class func task_5(cell: UITableViewCell?, indexPaht: IndexPath) {
        
        for i in 1...5 {
            cell?.contentView.viewWithTag(i)? .removeFromSuperview()
        }
    }
    class func task_4(cell: UITableViewCell?, indexPaht: IndexPath) {
        
        let label2 = UILabel(frame: CGRect(x: 5, y: 115, width: 300, height: 35))
        label2.backgroundColor = UIColor.clear
        label2.lineBreakMode = .byWordWrapping
        label2.numberOfLines = 0
        label2.textColor = UIColor.blue
        label2.text = "Drawing \(indexPaht.row) is top priority.Should be distributed into different run loop passes"
        label2.font = UIFont.boldSystemFont(ofSize: 13)
        label2.tag = 3
        cell?.contentView.addSubview(label2)
        
        
        let imageview3 = UIImageView(frame: CGRect(x: 5, y: 30, width: 85, height: 85))
        imageview3.tag = 5
        imageview3.image = UIImage(contentsOfFile: ViewController.imagePath)
        
        UIView.transition(with: (cell?.contentView)!, duration: 0.3, options: [.curveEaseInOut,.transitionCrossDissolve], animations: { 
            
            cell?.contentView.addSubview(imageview3)
        }, completion: nil)
        
        
        
    }
    class func task_3(cell: UITableViewCell?, indexPaht: IndexPath) {
        
        let imageview2 = UIImageView(frame: CGRect(x: 200, y: 30, width: 85, height: 85))
        imageview2.tag = 4
    
        imageview2.image = UIImage(contentsOfFile: ViewController.imagePath)
        UIView.transition(with: (cell?.contentView)!, duration: 0.3, options: [.curveEaseInOut,.transitionCrossDissolve], animations: { 
            cell?.contentView.addSubview(imageview2)
        }, completion: nil)
        
    }
    func task_2(cell: UITableViewCell?, indexPaht: IndexPath) {
        
        let imageview1 = UIImageView(frame: CGRect(x: 105, y: 30, width: 85, height: 85))
        imageview1.tag = 2
        imageview1.image = UIImage(contentsOfFile: ViewController.imagePath)
        
        
        UIView.transition(with: (cell?.contentView)!, duration: 0.3, options: [.curveEaseInOut,.transitionCrossDissolve], animations: {
            
            cell?.contentView.addSubview(imageview1)
        }, completion: nil)
        
        
        
        
    }
    class func task_1(cell: UITableViewCell?, indexPaht: IndexPath) {
        
        let label1 = UILabel(frame: CGRect(x: 5, y: 5, width: 300, height: 25))
        label1.backgroundColor = UIColor.clear
        label1.textColor = UIColor.red
        label1.text = "Drawing \(indexPaht.row) is top priority"
        label1.font = UIFont.boldSystemFont(ofSize: 13)
        label1.tag = 1
        cell?.contentView.addSubview(label1)

    }

}
