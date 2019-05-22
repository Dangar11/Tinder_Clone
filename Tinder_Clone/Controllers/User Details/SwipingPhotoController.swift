//
//  SwipingPhotoController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/17/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class SwipingPhotoController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    
    var controllers = [UIViewController]() //blank array
    
    fileprivate let isCardViewMode: Bool
    
    init(isCardViewMode: Bool = false) {
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            setViewControllers([controllers.first!], direction: .forward, animated: false)
            
            setupBarViews()
        }
    }
    
    
    fileprivate let barsStackView = UIStackView(arrangedSubviews: [])
    fileprivate let deselectBarColor = UIColor(white: 0, alpha: 0.3)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        dataSource = self
        delegate = self
        
        if isCardViewMode {
            disableSwipingAbility()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    
    fileprivate func disableSwipingAbility() {
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    
    @objc fileprivate func handleTap(gesture: UIGestureRecognizer) {
        let currentController = viewControllers!.first!
        if let index = controllers.firstIndex(of: currentController) {
            
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectBarColor})
            
            if gesture.location(in: view).x > view.frame.width / 2 {
                let nextIndex = min(index + 1, controllers.count - 1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: false)
                //bar forwards
                barsStackView.arrangedSubviews[nextIndex].backgroundColor = .white
                
            } else {
                let prevIndex = max(0, index - 1)
                let prevController = controllers[prevIndex]
                setViewControllers([prevController], direction: .forward, animated: false)
                //bar backwards
                barsStackView.arrangedSubviews[prevIndex].backgroundColor = .white
            }
            
        }
    }
    
    
    fileprivate func setupBarViews()  {
        
        cardViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = deselectBarColor
            barView.layer.cornerRadius = 2
            barsStackView.addArrangedSubview(barView)
        }
        var paddingTop : CGFloat = 8
        if !isCardViewMode {
           paddingTop += UIApplication.shared.statusBarFrame.height
        }
        
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        view.addSubview(barsStackView)
        barsStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom:0, right: 8),
                             size: .init(width: 0, height: 4))
        
    }

    //MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == 0 { return nil}
        return controllers[index - 1]
    }
    
    
    //MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}) {
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectBarColor})
           barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    

}


//Class with init for photo picker
class PhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "avatar_placeholder"))
    
    //provide initializer that takes in url instead
    
    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
