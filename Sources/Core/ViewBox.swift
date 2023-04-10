//
//  ViewBox.swift
//  StackUI
//
//  Created by tony on 2021/11/24.
//

import UIKit

open
class ViewBox: UIView, StackUIView {
    public init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0, viewBuilder: () -> UIView) {
        super.init(frame: .zero)

        let subview = viewBuilder()
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        subview.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottom).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: left).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -right).isActive = true
    }

    public init(paddings: UIEdgeInsets, viewBuilder: () -> UIView) {
        super.init(frame: .zero)

        let subview = viewBuilder()
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        subview.topAnchor.constraint(equalTo: topAnchor, constant: paddings.top).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddings.bottom).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddings.left).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddings.right).isActive = true
    }

    public init(paddings publisher: Publisher<UIEdgeInsets>, viewBuilder: () -> UIView) {
        super.init(frame: .zero)

        let subview = viewBuilder()
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        let top = subview.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        top.isActive = true
        let bottom = subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        bottom.isActive = true
        let left = subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        left.isActive = true
        let right = subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        right.isActive = true
        publisher.addSubscriber { paddings in
            top.constant = paddings.top
            bottom.constant = -paddings.bottom
            left.constant = paddings.left
            right.constant = -paddings.right
        }
    }

    @discardableResult func rebuildViews(_ viewBuilder: () -> UIView) -> Self {
        subviews.forEach({ $0.removeFromSuperview() })
        let subview = viewBuilder()
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        return self
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open func apply(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}
