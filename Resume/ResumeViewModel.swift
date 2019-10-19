//
//  ViewModel.swift
//  Resume
//
//  Created by Terrence Geernaert on 2019-10-18.
//  Copyright © 2019 tgeernaert. All rights reserved.
//

import Foundation
import UIKit

///
class DescribedViewModel: ResumeViewModel, DecribedViewProvider {

    init(bindings: ResumeViewBindings) {
        themeDidChange = bindings.themeDidChange
        contentViewDidChange = bindings.contentViewDidChange

        updateDescribedView()

        NotificationCenter.default.addObserver(forName: UIContentSizeCategory.didChangeNotification,
                                               object: nil, queue: .main) {_ in
            self.updateDescribedView()
        }

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - ResumeViewModel protocol
    func handleTapGesture() {
    }


    //MARK: - DecribedViewProvider
    func loadViewDescriptor() -> ViewDescriptor? {
        do {

            guard let url = Bundle.main.url(forResource: "resume", withExtension: "json") else {
                throw ResumeError.missingResource
            }

            return try JSONDecoder().decode(ViewType.self, from: Data(contentsOf: url)).descriptor
        } catch {
            print(error)
            return nil
        }
    }

    func updateDescribedView() {
        if let view = viewDescriptor?.view(theme) {
            contentViewDidChange(view)
        }
    }

    // MARK: - Private
    private var themeDidChange: (Theme) -> Void = {_ in}
    private var contentViewDidChange: (UIView) -> Void = {_ in}
    private lazy var viewDescriptor: ViewDescriptor? = loadViewDescriptor()

    var theme: Theme = DefaultTheme() {
        didSet {
            updateDescribedView()
            themeDidChange(theme)
        }
    }


}

enum ResumeError: Error {
    case missingResource
}

protocol ResumeViewModel {
    var theme: Theme { get set }
}

struct ResumeViewBindings {
    var themeDidChange: (Theme) -> Void = {_ in}
    var contentViewDidChange: (UIView) -> Void = {_ in}
}

protocol DecribedViewProvider {
    func loadViewDescriptor() -> ViewDescriptor?
    func updateDescribedView()
}

extension ViewDescriptor {

    /// The view builder for the view descriptor
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
