//
//  ModalView.swift
//  iOSApp
//
//  Created by Cristian Carlassare.
//

import UIKit


protocol ModalViewDelegate {
    func openModalView()
    func dismissModalView()
}


class ModalView: UIView {
    
    let contentView : UIView?
    let backgroundView : UIView?
    
    
    required init(frame: CGRect, contentView: UIView) {
        self.contentView = contentView
        self.backgroundView = UIView(frame: frame)
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func createView() {
        self.contentView!.frame = CGRect(x: self.frame.minX, y: self.frame.maxY, width: self.frame.width, height: 530)
    }
}


extension ModalView: ModalViewDelegate{
    
    func openModalView() {
        self.backgroundView!.backgroundColor = .black
        self.backgroundView!.alpha = 0
        self.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissModalView)))
        self.addSubview(backgroundView!)
        self.addSubview(contentView!)
        
        self.createView()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView?.alpha = 0.5
            self.contentView!.frame = CGRect(x: self.frame.minX, y: self.frame.maxY - 530, width: self.frame.width, height: 530)
        })
    }
    
    
    @objc func dismissModalView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView?.alpha = 0
            self.contentView?.layoutSubviews()
            self.contentView!.frame = CGRect(x: self.frame.minX, y: self.frame.maxY, width: self.frame.width, height: 530)
        }, completion: { (finished: Bool) in
            self.removeFromSuperview()
        })
    }
}
