//
//  SwipingPhotoController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/17/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class SwipingPhotoController: UIPageViewController, UIPageViewControllerDataSource {

    
    let controllers = [
    PhotoController(image: #imageLiteral(resourceName: "igor")),
    PhotoController(image: #imageLiteral(resourceName: "tanya")),
    PhotoController(image: #imageLiteral(resourceName: "tanya3")),
    PhotoController(image: #imageLiteral(resourceName: "igor2")),
    PhotoController(image: #imageLiteral(resourceName: "tanya2"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        dataSource = self

        
        setViewControllers([controllers.first!], direction: .forward, animated: false)
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        print(index)
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        print(index)
        if index == 0 { return nil}
        return controllers[index - 1]
    }

}


class PhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "igor"))
    
    
    init(image: UIImage) {
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
