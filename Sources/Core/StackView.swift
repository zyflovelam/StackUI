//
//  StackView.swift
//  StackUI
//
//  Created by jiaxin on 2021/9/11.
//

import UIKit

@resultBuilder
public struct ViewBuilder {
    public typealias Expression = UIView
    public typealias Component = [UIView]
    public static func buildExpression(_ expression: Expression) -> Component {
        return [expression]
    }

    public static func buildBlock(_ components: Component...) -> Component {
        return components.flatMap { $0 }
    }

    public static func buildBlock(_ components: UIView...) -> Component {
        return components.map { $0 }
    }

    public static func buildOptional(_ component: Component?) -> Component {
        return component ?? []
    }

    public static func buildEither(first component: Component) -> Component {
        return component
    }

    public static func buildEither(second component: Component) -> Component {
        return component
    }

    public static func buildArray(_ components: [Component]) -> Component {
        Array(components.joined())
    }
}

open class HStack: UIStackView, StackUIView {
    public convenience init(distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, @ViewBuilder views: () -> [UIView]) {
        let views = views()
        self.init(arrangedSubviews: views)
        views.forEach { view in
            if let spacer = view as? Spacer {
                spacer.axis = .horizontal
            }
            if let divider = view as? Divider {
                divider.axis = .horizontal
            }
        }
        axis = .horizontal
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }

    public func apply(_ clousre: (Self) -> Void) -> Self {
        clousre(self)
        return self
    }
}

open class HList<T>: HStack {
    public convenience init(distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, withData publisher: Publisher<T>, @ViewBuilder views: @escaping (T) -> [UIView]) {
        self.init(arrangedSubviews: [])
        axis = .horizontal
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        publisher.addSubscriber { [weak self] data in
            guard let self = self else { return }
            self.removeAllArrangedSubviews()
            let views = views(data)
            views.forEach { view in
                if let spacer = view as? Spacer {
                    spacer.axis = .horizontal
                }
                if let divider = view as? Divider {
                    divider.axis = .horizontal
                }
                self.addArrangedSubview(view)
            }
        }
    }
}

open class VStack: UIStackView, StackUIView {
    public convenience init(distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, @ViewBuilder views: () -> [UIView]) {
        let views = views()
        self.init(arrangedSubviews: views)
        views.forEach { view in
            if let spacer = view as? Spacer {
                spacer.axis = .vertical
            }
            if let divider = view as? Divider {
                divider.axis = .vertical
            }
        }
        axis = .vertical
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }

    public func apply(_ clousre: (Self) -> Void) -> Self {
        clousre(self)
        return self
    }
}

open class VList<T>: VStack {
    public convenience init(distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, withData publisher: Publisher<T>, @ViewBuilder views: @escaping (T) -> [UIView]) {
        self.init(arrangedSubviews: [])
        axis = .vertical
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        publisher.addSubscriber { [weak self] data in
            guard let self = self else { return }
            self.removeAllArrangedSubviews()
            let views = views(data)
            views.forEach { view in
                if let spacer = view as? Spacer {
                    spacer.axis = .vertical
                }
                if let divider = view as? Divider {
                    divider.axis = .vertical
                }
                self.addArrangedSubview(view)
            }
        }
    }
}

/// The width and height of `HScrollStack` is required
open class HScrollStack: UIView, StackUIView {
    private let stackView: UIStackView
    public let scrollView: UIScrollView
    public init(distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, @ViewBuilder views: () -> [UIView]) {
        let views = views()
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        stackView = UIStackView(arrangedSubviews: views)
        views.forEach { view in
            if let spacer = view as? Spacer {
                spacer.axis = .horizontal
            }
            if let divider = view as? Divider {
                divider.axis = .horizontal
            }
        }
        stackView.axis = .horizontal
        stackView.distribution = distribution
        stackView.alignment = alignment
        stackView.spacing = spacing
        super.init(frame: .zero)

        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func applyScrollView(_ config: (UIScrollView) -> Void) -> Self {
        config(scrollView)
        return self
    }
}

/// The width and height of `VScrollStack` is required
open class VScrollStack: UIView, StackUIView {
    private let stackView: UIStackView
    public let scrollView: UIScrollView
    public init(distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, @ViewBuilder views: () -> [UIView]) {
        let views = views()
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        stackView = UIStackView(arrangedSubviews: views)
        views.forEach { view in
            if let spacer = view as? Spacer {
                spacer.axis = .vertical
            }
            if let divider = view as? Divider {
                divider.axis = .vertical
            }
        }
        stackView.axis = .vertical
        stackView.distribution = distribution
        stackView.alignment = alignment
        stackView.spacing = spacing
        super.init(frame: .zero)

        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func applyScrollView(_ config: (UIScrollView) -> Void) -> Self {
        config(scrollView)
        return self
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}
