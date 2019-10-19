//
//  ViewModel.swift
//  Resume
//
//  Created by Terrence Geernaert on 2019-10-18.
//  Copyright © 2019 tgeernaert. All rights reserved.
//

import Foundation
import UIKit

/// The DescripedViewModel is intended to provide a view heirarchy from a JSON data source.
class DescribedViewModel: ThemedContentViewModel, DecribedViewProvider {
    /// initializer that inforces injection of dependacies, so that this can be uint tested
    ///
    /// The dataFetch, which results in the subsequent callback to contentViewDidChange, is triggered imediately on construction.
    ///
    /// - parameter bindings: A ResumeViewBindings structure, which defines the output callbacks
    /// - parameter dataFetcher: Fetches JSON data that will be parsed into the appropiate type
    /// - parameter notificationCenter: the notification center tha will listen for dynamic type size changes.  Injected so that unit tests can controll obsevation when run in parallel
    init(bindings: ThemedContentViewBindings,
         dataFetcher: JSONDataFetcher,
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.dataFetcher = dataFetcher
        themeDidChange = bindings.themeDidChange
        contentViewDidChange = bindings.contentViewDidChange

        notificationCenter.addObserver(forName: UIContentSizeCategory.didChangeNotification,
                                       object: nil, queue: .main) {[weak self] _ in self?.updateDescribedView() }

        createViewDescriptor()
    }

    // MARK: - DecribedViewProvider
    func createViewDescriptor() {
        dataFetcher.fetch(type: ViewType.self) {
            switch $0 {
            case .success(let viewType):
                self.viewDescriptor = viewType.descriptor
            case .failure(let error):
                print( error )
            }
        }
    }

    // MARK: - ThemedContentViewModel
    var theme: Theme = DefaultTheme() {
        didSet {
            updateDescribedView()
            themeDidChange(theme)
        }
    }

    // MARK: - Private
    private func updateDescribedView() {
        if let view = viewDescriptor?.view(theme) {
            contentViewDidChange(view)
        }
    }

    internal let themeDidChange: (Theme) -> Void
    internal let contentViewDidChange: (UIView) -> Void
    private let dataFetcher: JSONDataFetcher
    private var viewDescriptor: ViewDescriptor? {
        didSet {
            updateDescribedView()
        }
    }
}

/// Define the inteface to themed view model
protocol ThemedContentViewModel {
    /// The theme to use when creating views
    var theme: Theme { get set }
    /// Let the caller know that the theme changed
    /// - parameter Theme: the theme that is to be applied
    var themeDidChange: (Theme) -> Void { get }

    /// Let the caller know that the contentView changed
    /// - parameter UIView: the view that should replacing the previous content
    var contentViewDidChange: (UIView) -> Void  { get }
}

/// Enforces injection of contracted communication through required callbacks
struct ThemedContentViewBindings {
    /// Let the caller know that the theme changed
    /// - parameter Theme: the theme that is to be applied
    var themeDidChange: (Theme) -> Void = {_ in}

    /// Let the caller know that the contentView changed
    /// - parameter UIView: the view that should replacing the previous content
    var contentViewDidChange: (UIView) -> Void = {_ in}
}

/// Defines the interface to use ViewDescriptor loading
protocol DecribedViewProvider {
    /// Loads the data with the provided data fetcher and decodes that into ViewDescriptor
    func createViewDescriptor()
}

extension ViewDescriptor {
    // MARK: - ViewDescriptor
    func view(_ theme: Theme = DefaultTheme()) -> UIView {
        switch self.viewType {
        case .body, .bullet, .heading, .subheading, .title:
            return buildLabel(theme: theme)
        case .stack(let descriptor):
            return buildStackView(theme: theme, stack: descriptor)
        case .space(let descriptor):
            return buildSimpleView(theme: theme, space: descriptor)
        }
    }

    // MARK: - Private
    private func buildLabel(theme: Theme) -> UILabel {
        let label = UILabel(frame: .zero)
        label.font = theme.font(view: viewType)
        label.textColor = theme.forground(view: viewType)
        label.backgroundColor = theme.background(view: viewType)
        label.numberOfLines = canWordWrap ? 0 : 1
        label.lineBreakMode = canWordWrap ? .byWordWrapping : .byTruncatingTail
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        if let provider = (self as? TextProviding) {
            label.text = provider.text
            label.textAlignment = provider.alignment ?? .natural
        } else if let provider = (self as? AttributedTextProviding) {
            label.attributedText = provider.attributedText
        }
        return label
    }

    private var canWordWrap: Bool {
        switch viewType {
        case .body, .bullet:
            return true
        default:
            return false
        }
    }

    private func buildStackView(theme: Theme, stack: Stack) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: stack.subviews.map { $0.descriptor.view(theme) })
        stackView.axis = stack.axis
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }

    private func buildSimpleView(theme: Theme, space: Space) -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = theme.background(view: viewType)
        switch space.value {
        case .fixed(let value):
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(value)).isActive = true
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(value)).isActive = true
        case .flexible:
            view.setContentHuggingPriority(.init(1), for: .horizontal)
            view.setContentHuggingPriority(.init(1), for: .vertical)
        }
        return view
    }
}
