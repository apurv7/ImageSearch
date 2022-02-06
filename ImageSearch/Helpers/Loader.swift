//
//  Loader.swift
//  ImageSearch
//
//  Created by apurv on 07/02/2022.
//

import UIKit

//MARK:- extension for adding/removing loader
extension UIView {
    
    func showLoader() {
        let loader = Loader(frame: frame)
        self.addSubview(loader)
    }

    func removeLoader() {
        if let loader = subviews.first(where: { $0 is Loader }) {
            loader.removeFromSuperview()
        }
    }
}


class Loader: UIView {

    var effectView: UIView?

    override init(frame: CGRect) {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = frame
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.effectView = view
        super.init(frame: frame)
        addSubview(view)
        addLoader()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addLoader() {
        guard let effectView = effectView else { return }
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        effectView.addSubview(activityIndicator)
        activityIndicator.center = effectView.center
        activityIndicator.startAnimating()
    }
}
