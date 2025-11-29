//
//  OnboardingController.swift
//  OnboardingKit
//
//  Created by Jarrod Norwell on 21/9/2025.
//

import ColourKit
import SwiftUI
import UIKit

open class OnboardingController : UIViewController {
    public struct Onboarding {
        public struct Button {
            public typealias Handler = ((UIButton, UIViewController) async -> Void)
            
            public struct Configuration {
                public var configuration: UIButton.Configuration? = nil
                
                public var image: UIImage? = nil
                public var text: String? = nil
                
                public var handler: Handler? = nil
                
                public init(configuration: UIButton.Configuration? = nil, image: UIImage? = nil, text: String? = nil, handler: Handler? = nil) {
                    self.configuration = configuration
                    self.image = image
                    self.text = text
                    self.handler = handler
                }
            }
        }
        
        public struct Configuration {
            public var buttons: [Button.Configuration]
            
            public var colours: [Colour] = Colour.vibrantGreens
            
            public var image: UIImage? = nil
            public var useCustomSymbolEffect: Bool = false
            
            public var text: String
            public var secondaryAttributedText: AttributedString? = nil
            public var secondaryText: String? = nil, tertiaryText: String? = nil
            
            public init(buttons: [Button.Configuration], colours: [Colour], image: UIImage? = nil, useCustomSymbolEffect: Bool = false,
                 text: String, secondaryAttributedText: AttributedString? = nil, secondaryText: String? = nil, tertiaryText: String? = nil) {
                self.buttons = buttons
                self.colours = colours
                self.image = image
                self.useCustomSymbolEffect = useCustomSymbolEffect
                self.text = text
                self.secondaryAttributedText = secondaryAttributedText
                self.secondaryText = secondaryText
                self.tertiaryText = tertiaryText
            }
        }
    }
    
    public var imageView: UIImageView? = nil
    private var visualEffectView: UIVisualEffectView? = nil,
                tintingVisualEffectView: UIVisualEffectView? = nil
    
    public var configuration: Onboarding.Configuration
    public init(configuration: Onboarding.Configuration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = traitCollection.userInterfaceStyle
        
        if #available(iOS 18, *) {
            let meshGradientView: UIHostingController = .init(rootView: MeshGradientView(colours: configuration.colours))
            meshGradientView.view.translatesAutoresizingMaskIntoConstraints = false
            addChild(meshGradientView)
            view.addSubview(meshGradientView.view)
            meshGradientView.didMove(toParent: self)
            
            meshGradientView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            meshGradientView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            meshGradientView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            meshGradientView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        } else {
            view.backgroundColor = .systemBackground
        }
        
        visualEffectView = if #available(iOS 26, *) {
            .init(effect: UIGlassEffect(style: .regular))
        } else {
            .init(effect: UIBlurEffect(style: .systemMaterial))
        }
        guard let visualEffectView else {
            return
        }
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 26, *) {
            visualEffectView.cornerConfiguration = .corners(radius: .containerConcentric())
        }
        view.addSubview(visualEffectView)
        
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        if #available(iOS 18, *) {
            tintingVisualEffectView = .init(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .systemMaterial)))
            guard let tintingVisualEffectView else {
                return
            }
            tintingVisualEffectView.translatesAutoresizingMaskIntoConstraints = false
            visualEffectView.contentView.addSubview(tintingVisualEffectView)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                tintingVisualEffectView.topAnchor.constraint(equalTo: visualEffectView.contentView.topAnchor, constant: 20).isActive = true
                tintingVisualEffectView.bottomAnchor.constraint(equalTo: visualEffectView.contentView.bottomAnchor, constant: -20).isActive = true
                tintingVisualEffectView.widthAnchor.constraint(equalTo: visualEffectView.contentView.widthAnchor, multiplier: 2 / 3).isActive = true
                tintingVisualEffectView.centerXAnchor.constraint(equalTo: visualEffectView.contentView.centerXAnchor).isActive = true
            } else {
                tintingVisualEffectView.topAnchor.constraint(equalTo: visualEffectView.contentView.topAnchor, constant: 20).isActive = true
                tintingVisualEffectView.leadingAnchor.constraint(equalTo: visualEffectView.contentView.leadingAnchor, constant: 20).isActive = true
                tintingVisualEffectView.bottomAnchor.constraint(equalTo: visualEffectView.contentView.bottomAnchor, constant: -20).isActive = true
                tintingVisualEffectView.trailingAnchor.constraint(equalTo: visualEffectView.contentView.trailingAnchor, constant: -20).isActive = true
            }
        }
        
        let constraintView: UIView = tintingVisualEffectView?.contentView ?? view
        
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = if #available(iOS 17, *) {
            .bold(.extraLargeTitle)
        } else {
            .bold(.largeTitle)
        }
        label.numberOfLines = 2
        label.text = configuration.text
        label.textAlignment = .center
        if #unavailable(iOS 18) {
            label.textColor = .label
        }
        constraintView.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: constraintView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: constraintView.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: constraintView.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        let topCenteringView: UIView = .init()
        topCenteringView.translatesAutoresizingMaskIntoConstraints = false
        constraintView.addSubview(topCenteringView)
        
        topCenteringView.topAnchor.constraint(equalTo: constraintView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        topCenteringView.leadingAnchor.constraint(equalTo: constraintView.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        topCenteringView.bottomAnchor.constraint(equalTo: label.safeAreaLayoutGuide.topAnchor, constant: -20).isActive = true
        topCenteringView.trailingAnchor.constraint(equalTo: constraintView.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        imageView = .init(image: configuration.image)
        guard let imageView else {
            return
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        if #unavailable(iOS 18) {
            imageView.tintColor = .label
        }
        topCenteringView.addSubview(imageView)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            imageView.topAnchor.constraint(equalTo: topCenteringView.safeAreaLayoutGuide.topAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: topCenteringView.safeAreaLayoutGuide.leadingAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: topCenteringView.safeAreaLayoutGuide.bottomAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: topCenteringView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        } else {
            imageView.centerXAnchor.constraint(equalTo: topCenteringView.safeAreaLayoutGuide.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: topCenteringView.safeAreaLayoutGuide.centerYAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: topCenteringView.safeAreaLayoutGuide.widthAnchor,
                                             multiplier: 2 / 3).isActive = true
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        }
        
        let secondaryLabel: UILabel = .init()
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.font = .preferredFont(forTextStyle: .body)
        secondaryLabel.numberOfLines = 3
        if let secondaryAttributedText = configuration.secondaryAttributedText {
            secondaryLabel.attributedText = .init(secondaryAttributedText)
        } else {
            secondaryLabel.text = configuration.secondaryText
        }
        secondaryLabel.textAlignment = .center
        if #unavailable(iOS 18) {
            secondaryLabel.textColor = .secondaryLabel
        }
        constraintView.addSubview(secondaryLabel)
        
        secondaryLabel.topAnchor.constraint(equalTo: label.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        secondaryLabel.leadingAnchor.constraint(equalTo: constraintView.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        secondaryLabel.trailingAnchor.constraint(equalTo: constraintView.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        let tertiaryLabel: UILabel = .init()
        tertiaryLabel.translatesAutoresizingMaskIntoConstraints = false
        tertiaryLabel.font = .preferredFont(forTextStyle: .footnote)
        tertiaryLabel.numberOfLines = 3
        tertiaryLabel.text = configuration.tertiaryText
        tertiaryLabel.textAlignment = .center
        if #unavailable(iOS 18) {
            tertiaryLabel.textColor = .tertiaryLabel
        }
        constraintView.addSubview(tertiaryLabel)
        
        tertiaryLabel.leadingAnchor.constraint(equalTo: constraintView.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        tertiaryLabel.bottomAnchor.constraint(equalTo: constraintView.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        tertiaryLabel.trailingAnchor.constraint(equalTo: constraintView.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        let centeringView: UIView = .init()
        centeringView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centeringView)
        
        centeringView.topAnchor.constraint(equalTo: secondaryLabel.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
        centeringView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        centeringView.bottomAnchor.constraint(equalTo: tertiaryLabel.safeAreaLayoutGuide.topAnchor, constant: -20).isActive = true
        centeringView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        let mapped: [UIButton] = configuration.buttons.map { configuration in
            if let custom = configuration.configuration {
                let button: UIButton = .init(configuration: custom)
                return button
            } else {
                var conf: UIButton.Configuration = if #available(iOS 26, *) { .glass() } else { .filled() }
                conf.buttonSize = .large
                conf.cornerStyle = .capsule
                if #unavailable(iOS 26) {
                    if #available(iOS 18, *) {
                        conf.baseBackgroundColor = .systemBackground.withAlphaComponent(2 / 3)
                        conf.baseForegroundColor = .label
                    } else {
                        conf.baseBackgroundColor = .label
                        conf.baseForegroundColor = .systemBackground
                    }
                }
                if let image = configuration.image {
                    conf.image = image
                } else if let text = configuration.text {
                    conf.title = text
                }
                
                let button: UIButton = .init(configuration: conf, primaryAction: .init(handler: { action in
                    guard let button = action.sender as? UIButton, let handler = configuration.handler else {
                        return
                    }
                    
                    if #available(iOS 17.5, *) {
                        UIImpactFeedbackGenerator(view: button).impactOccurred()
                    } else {
                        UIImpactFeedbackGenerator().impactOccurred()
                    }
                    
                    Task {
                        await handler(button, self)
                    }
                }))
                if #unavailable(iOS 26) {
                    button.overrideUserInterfaceStyle = self.traitCollection.userInterfaceStyle
                    
                    button.layer.shadowColor = UIColour.black.cgColor
                    button.layer.shadowOpacity = 1 / 5
                    button.layer.shadowRadius = 20
                    button.layer.shadowOffset = .init(width: 0, height: 10)
                }
                return button
            }
        }
        
        let stackView: UIStackView = .init(arrangedSubviews: mapped)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        centeringView.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: centeringView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centeringView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        stackView.leadingAnchor.constraint(greaterThanOrEqualTo: centeringView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(lessThanOrEqualTo: centeringView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    public var animationHasPlayed: Bool = false
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !animationHasPlayed && !configuration.useCustomSymbolEffect {
            guard let imageView else {
                return
            }
            
            if #available(iOS 17, *) {
                imageView.addSymbolEffect(.bounce)
            }
            
            animationHasPlayed.toggle()
        }
    }
    
    public override var prefersStatusBarHidden: Bool { true }
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
}
