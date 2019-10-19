//
//  ViewController.swift
//  Resume
//
//  Created by Terrence Geernaert on 2019-10-17.
//  Copyright © 2019 tgeernaert. All rights reserved.
//

import UIKit

class ResumeViewController: UIViewController {

    var scrollView: UIScrollView!
    var contentView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        buildScrollView()

        bindViewModel()
    }

    // MARK: - Actions
    @IBAction func didTapView() {
        if viewModel.theme as? DefaultTheme == nil {
            viewModel.theme = DefaultTheme()
        } else {
            viewModel.theme = AlternativeTheme()
        }
    }

    // MARK: - Private
    private func buildScrollView() {
        scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
    }

    // Create all the ResumeViewBinding closures to be injected into the ViewModel
    private func bindViewModel() {

        let themeDidChange: (Theme) -> Void = { [unowned self] theme in
            self.view.backgroundColor = theme.background
            self.view.setNeedsDisplay()
        }

        let contentDidChange: (UIView) -> Void = { [ unowned self] in
            self.replaceScrollableContent($0)
        }

        let dataFetcher = GistResumeDataFetcher()
        viewModel = DescribedViewModel(bindings: ThemedContentViewBindings(themeDidChange: themeDidChange,
                                                                           contentViewDidChange: contentDidChange),
                                       dataFetcher: dataFetcher)
    }

    private func replaceScrollableContent(_ view: UIView) {
        contentView?.removeFromSuperview()
        scrollView.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        contentView = view
    }

    private var viewModel: ThemedContentViewModel!
}

