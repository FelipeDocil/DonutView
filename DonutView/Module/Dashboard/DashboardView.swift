// 
//  DashboardView.swift
//  DonutView
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

import UIKit
import HGCircularSlider

private struct Constant {
    struct AccessibilityIdentifier {
        static let dashboardView = "dashboard_view"
        static let progressView = dashboardView + "_progress_view"
        static let scoreValueLabel = dashboardView + "_score_value_label"
        static let maximumLabel = dashboardView + "_maximum_label"
    }

    struct Text {
        static let title = "Dashboard"
        static let scoreText = "Your credit score is"
        static let maximumText = "out of %i"
        static let initialScoreValueText = "-"
        static let unavailableText = "unavailable. Try again later!"
    }
    
    struct Color {
        static let score = UIColor(red: 253/255, green: 180/255, blue: 118/255, alpha: 1)
        static let error = UIColor(red: 207/255, green: 64/255, blue: 51/255, alpha: 1)
    }
}


protocol DashboardViewInput: AnyObject {
    func setupProgressState(with score: Int, and maximumValue: Int)
    func showErrors()
}

class DashboardView: UIViewController, DashboardViewInput {
    var presenter: DashboardPresenterInput
    
    private lazy var progressView: CircularSlider = {
        let tmpView = CircularSlider(frame: .zero)
        tmpView.translatesAutoresizingMaskIntoConstraints = false
        tmpView.accessibilityIdentifier = Constant.AccessibilityIdentifier.progressView
        tmpView.backgroundColor = .clear
        tmpView.lineWidth = 4
        tmpView.trackFillColor = Constant.Color.score
        tmpView.diskColor = .clear
        tmpView.diskFillColor = .clear
        tmpView.trackColor = .clear
        tmpView.endThumbImage = UIImage()
        tmpView.backtrackLineWidth = 4
        tmpView.numberOfRounds = 1
        tmpView.isUserInteractionEnabled = false
        tmpView.minimumValue = 0
        tmpView.maximumValue = 101
        tmpView.endPointValue = 0
        
        return tmpView
    }()
    
    private lazy var scoreLabel: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.translatesAutoresizingMaskIntoConstraints = false
        tmpLabel.numberOfLines = 1
        tmpLabel.textColor = .black
        tmpLabel.textAlignment = .center
        tmpLabel.font = UIFont.systemFont(ofSize: 24)
        tmpLabel.text = Constant.Text.scoreText
        
        return tmpLabel
    }()
    
    private lazy var scoreValueLabel: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.translatesAutoresizingMaskIntoConstraints = false
        tmpLabel.accessibilityIdentifier = Constant.AccessibilityIdentifier.scoreValueLabel
        tmpLabel.numberOfLines = 1
        tmpLabel.textColor = Constant.Color.score
        tmpLabel.textAlignment = .center
        tmpLabel.font = UIFont.systemFont(ofSize: 72)
        tmpLabel.text = Constant.Text.initialScoreValueText
        
        return tmpLabel
    }()
    
    private lazy var maximumLabel: UILabel = {
        let tmpLabel = UILabel()
        tmpLabel.translatesAutoresizingMaskIntoConstraints = false
        tmpLabel.accessibilityIdentifier = Constant.AccessibilityIdentifier.maximumLabel
        tmpLabel.numberOfLines = 1
        tmpLabel.textColor = .black
        tmpLabel.textAlignment = .center
        tmpLabel.font = UIFont.systemFont(ofSize: 24)
        tmpLabel.text = String(format: Constant.Text.maximumText, 0)
        
        return tmpLabel
    }()
    
    private lazy var circleView: CircularSlider = {
        let tmpView = CircularSlider(frame: .zero)
        tmpView.translatesAutoresizingMaskIntoConstraints = false
        tmpView.isUserInteractionEnabled = false
        tmpView.backgroundColor = .clear
        tmpView.diskColor = .clear
        tmpView.diskFillColor = .clear
        tmpView.trackColor = .black
        tmpView.endThumbImage = UIImage()
        tmpView.backtrackLineWidth = 4
        tmpView.endPointValue = 0
        
        return tmpView
    }()

    init(presenter: DashboardPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        presenter.viewIsReady()
    }

    // MARK: DashboardViewInput
    func setupProgressState(with score: Int, and maximumValue: Int) {
        DispatchQueue.main.async {
            let realScore: CGFloat = CGFloat(score) / CGFloat(maximumValue)
            
            self.progressView.endPointValue = realScore * 100
            self.scoreValueLabel.text = "\(score)"
            self.maximumLabel.text = String(format: Constant.Text.maximumText, maximumValue)
        }
    }
    
    func showErrors() {
        DispatchQueue.main.async {
            self.scoreValueLabel.textColor = Constant.Color.error
            self.maximumLabel.text = Constant.Text.unavailableText
        }
    }
    
    // MARK: Layout
    private func setupLayout() {
        view.accessibilityIdentifier = Constant.AccessibilityIdentifier.dashboardView
        view.backgroundColor = .white
        title = Constant.Text.title
        
        view.addSubview(circleView)
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            circleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            circleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            circleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: circleView.topAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: circleView.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: -16),
            progressView.bottomAnchor.constraint(equalTo: circleView.bottomAnchor, constant: -16),
        ])
        
        let tmpStack = UIStackView()
        tmpStack.translatesAutoresizingMaskIntoConstraints = false
        tmpStack.axis = .vertical
        tmpStack.spacing = 16
        tmpStack.alignment = .center
        
        view.addSubview(tmpStack)
        NSLayoutConstraint.activate([
            tmpStack.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            tmpStack.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
        ])
        
        tmpStack.addArrangedSubview(scoreLabel)
        tmpStack.addArrangedSubview(scoreValueLabel)
        tmpStack.addArrangedSubview(maximumLabel)
    }
}
