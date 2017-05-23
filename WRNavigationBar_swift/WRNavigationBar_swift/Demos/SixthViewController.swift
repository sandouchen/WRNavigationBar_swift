//
//  SixthViewController.swift
//  WRNavigationBar_swift
//
//  Created by wangrui on 2017/4/19.
//  Copyright © 2017年 wangrui. All rights reserved.
//

import UIKit

private let NAVBAR_TRANSLATION_POINT:CGFloat = 0

class SixthViewController: UIViewController
{
    lazy var tableView:UITableView = {
        let table:UITableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.view.bounds.height), style: .plain)
        table.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        table.delegate = self
        table.dataSource = self
        return table
    }()
    lazy var imageView:UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "image2"))
        return imgView
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "看90行代码"
        view.backgroundColor = UIColor.red
        view.addSubview(tableView)
        tableView.tableHeaderView = imageView
    }
}


// MARK: - viewWillAppear .. ScrollViewDidScroll
extension SixthViewController
{
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // 必须在view完全加载好再调用这个方法，否则就会出现白块的状况
        scrollViewDidScroll(self.tableView)
        tableView.delegate = self;
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        tableView.delegate = nil
        navigationController?.navigationBar.wr_setTranslationY(translationY: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let offsetY = scrollView.contentOffset.y
        // 向上滑动的距离
        let scrollUpHeight = offsetY - NAVBAR_TRANSLATION_POINT
        // 除数表示 -> 导航栏从完全不透明到完全透明的过渡距离
        let progress = scrollUpHeight / CGFloat(kNavBarHeight)
        if (offsetY > NAVBAR_TRANSLATION_POINT)
        {
            if (scrollUpHeight > CGFloat(kNavBarHeight)) {
                setNavigationBarTransformProgress(progress: 1)
            }
            else {
                setNavigationBarTransformProgress(progress: progress)
            }
        }
        else
        {
            self.setNavigationBarTransformProgress(progress: 0)
        }
    }
    
    // private
    func setNavigationBarTransformProgress(progress:CGFloat)
    {
        navigationController?.navigationBar.wr_setTranslationY(translationY: -CGFloat(kNavBarHeight) * progress)
        // 没有系统返回按钮，所以 hasSystemBackIndicator = NO
        // 如果这里不设置为NO，你会发现，导航栏无缘无故多出来一个返回按钮
        navigationController?.navigationBar.wr_setBarButtonItemsAlpha(alpha: 1 - progress, hasSystemBackIndicator: false)
    }
}


extension SixthViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: nil)
        let str = String(format: "WRNavigationBar %zd", indexPath.row)
        cell.textLabel?.text = str
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 做成这种样式，最好不要有点击事件
    }
}
