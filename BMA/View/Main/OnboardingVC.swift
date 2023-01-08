//
//  OnboardingVC.swift
//  BMA
//
//  Created by MACBOOK on 28/06/21.
//

import UIKit

class OnboardingVC: UIViewController {
    
    private var selectedPage = 0

    //OUTLETS
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageControll.currentPage = 0
        infoCollectionView.reloadData()
    }

    //MARK: - configUI
    private func configUI() {
        nextBtn.sainiCornerRadius(radius: 10)
        skipBtn.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1), borderWidth: 1, cornerRadius: 10)
        infoCollectionView.register(UINib(nibName: COLLECTION_VIEW_CELL.OnboardingCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.OnboardingCVC.rawValue)
        
        delay(0.1) {
            DispatchQueue.main.async { [weak self] in
              self?.infoCollectionView.reloadData()
            }
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToSkip(_ sender: Any) {
        let vc: LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.LoginVC.rawValue) as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - clickTONext
    @IBAction func clickTONext(_ sender: Any) {
        if selectedPage != 2 {
           selectedPage += 1
           infoCollectionView.scrollToItem(at: IndexPath(item: selectedPage, section: 0), at: .right, animated: true)
        }else{
            clickToSkip(self)
        }
    }
}

//MARK: - Collection View DataSource and Delegate MEthods
extension OnboardingVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ONBOARDING_TEXT.allCases.count
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.OnboardingCVC.rawValue, for: indexPath) as? OnboardingCVC else {
            return UICollectionViewCell()
        }
//        cell.titleLbl.text = ONBOARDING_TEXT.allCases[indexPath.row].rawValue
//        cell.imgView.image = UIImage.init(named: ONBOARDING_IMAGES.allCases[indexPath.row].rawValue)
        cell.bgImageView.image = UIImage(named: ONBOARDING_BG_IMAGES.allCases[indexPath.row].rawValue)
        return cell
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = infoCollectionView.bounds.width
        let itemHeight = infoCollectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
     
}

//MARK: - UIScrollViewDelegate
extension OnboardingVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.infoCollectionView.contentOffset, size: self.infoCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.infoCollectionView.indexPathForItem(at: visiblePoint) {
            self.pageControll.currentPage = visibleIndexPath.row
            selectedPage = visibleIndexPath.row
            if selectedPage == 2 {
                skipBtn.isHidden = true
                nextBtn.setTitle("Get Started", for: .normal)
            }
            else{
                skipBtn.isHidden = false
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
}

