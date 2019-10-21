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

    @IBOutlet weak var themeButton: UIBarButtonItem!

    @IBAction func changeTheme() {
        if viewModel.theme as? DefaultTheme == nil {
            viewModel.theme = DefaultTheme()
        } else {
            viewModel.theme = AlternativeTheme()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        buildScrollView()

        bindViewModel()
    }

    private func bindViewModel() {

        let themeDidChange: (Theme) -> Void = { [unowned self] theme in
            self.view.backgroundColor = theme.background
            self.navigationController?.navigationBar.barTintColor = theme.background
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: theme.forground]
            self.themeButton.tintColor = theme.action
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

    private func buildScrollView() {
        scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
    }

    private func replaceScrollableContent(_ view: UIView) {
        contentView?.removeFromSuperview()
        scrollView.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leftAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor).isActive = true

        contentView = view
    }

    private var viewModel: ThemedContentViewModel!
}

