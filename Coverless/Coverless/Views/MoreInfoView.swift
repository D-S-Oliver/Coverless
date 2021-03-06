//
//  MoreInfoView.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 17/09/21.
//

import UIKit

final class MoreInfoView: UIView, Designable {
    
    let designSystem: DesignSystem
    
    //MARK: Views
    private lazy var synopsisHeader: UILabel = {
        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "Synopsis"
        header.accessibilityLabel = "Synopsis"
        header.numberOfLines = 0
        header.stylize(with: designSystem.text.header)
        return header
    }()
    
    private lazy var synopsisField: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.stylize(with: designSystem.text.body)
        tv.adjustsFontForContentSizeCategory = true
        let padding = -tv.textContainer.lineFragmentPadding
        tv.contentInset = .init(top: padding, left: padding, bottom: 0, right: padding)
        
        return tv
    }()
    
    private lazy var otherInfoHeader: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.stylize(with: designSystem.text.header)
        l.numberOfLines = 0
        l.text = "Book info"
        l.accessibilityLabel = "Book info"
        return l
    }()
    
    private lazy var authorLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.stylize(with: designSystem.text.body)
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var publisherLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.stylize(with: designSystem.text.body)
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var discoverButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = designSystem.palette.buttonBackgroundPrimary
        b.setTitle("Discover Book", for: .normal)
        b.accessibilityLabel = "Discover book"
        b.accessibilityHint = "Double tap to add the book to your collection"
        b.setTitleColor(designSystem.palette.buttonTextPrimary, for: .normal)
        b.layer.cornerRadius = 8
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var stackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.translatesAutoresizingMaskIntoConstraints = false
        stv.distribution = .equalSpacing
        stv.spacing = designSystem.spacing.smallPositive
        stv.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        stv.isLayoutMarginsRelativeArrangement = true
        return stv
    }()
    
    private let tabBarHeight: CGFloat
    
    //MARK: Init
    
    init(designSystem: DesignSystem = DefaultDesignSystem.shared, tabBarHeight: CGFloat = 49) {
        self.designSystem = designSystem
        self.tabBarHeight = tabBarHeight
        super.init(frame: .zero)
        stylize(with: designSystem)
        setupHierarchy()
        setupLayout()
        setupAccessibility()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    
    private func setupHierarchy() {
        addSubview(scrollView)
        addSubview(discoverButton)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(synopsisHeader)
        stackView.addArrangedSubview(synopsisField)
        stackView.addArrangedSubview(otherInfoHeader)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(publisherLabel)
    }
    
    private func setupLayout() {
        setupScrollViewConstraints()
        setupScrollViewContentConstraints()
        setupDiscoverButtonConstraints()
    }
    
    private func setupScrollViewConstraints() {
        let constraints: [NSLayoutConstraint] = [
            scrollView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: \.smallPositive),
            scrollView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: discoverButton.topAnchor, constant: \.mediumNegative)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupScrollViewContentConstraints() {
        contentView.strechToBounds(of: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.strechToBounds(of: contentView)
    }
    
    private func setupDiscoverButtonConstraints() {
        let constraints: [NSLayoutConstraint] = [
            discoverButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(tabBarHeight + 12)),
            discoverButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            discoverButton.heightAnchor.constraint(equalToConstant: 44),
            discoverButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.40)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: Bindings
    func setupContent(book: Book) {
        synopsisField.text = book.description
        
        let authorLabelContent = "Author: \(book.author)"
        authorLabel.text = authorLabelContent
        authorLabel.accessibilityLabel = authorLabelContent
        
        let publisherLabelContent = "Publisher: \(book.publisher)"
        publisherLabel.text = publisherLabelContent
        publisherLabel.accessibilityLabel = publisherLabelContent
        
    }
    
    func setupAccessibility() {
        synopsisHeader.accessibilityTraits = .header
        synopsisHeader.isAccessibilityElement = true
        
        synopsisField.isAccessibilityElement = true
        synopsisField.accessibilityTraits = .staticText
        
        otherInfoHeader.accessibilityTraits = .header
        otherInfoHeader.isAccessibilityElement = true
        
        authorLabel.isAccessibilityElement = true
        authorLabel.accessibilityTraits = .staticText
        
        publisherLabel.isAccessibilityElement = true
        publisherLabel.accessibilityTraits = .staticText
        
        discoverButton.isAccessibilityElement = true
        discoverButton.accessibilityTraits = .button
        
        accessibilityElements = [synopsisHeader, synopsisField, otherInfoHeader, authorLabel, publisherLabel, discoverButton]
    }
    
    func setupButtonBinding(_ action: @escaping () -> Void) {
        let uiAction: UIAction = UIAction { _ in action() }
        discoverButton.addAction(uiAction, for: .touchUpInside)
    }
    
    //MARK: Designable Protocol

    func stylize(with designSystem: DesignSystem) {
        backgroundColor = designSystem.palette.backgroundPrimary
    }
    
}

#if DEBUG
import SwiftUI

struct AnyViewRepresentable: UIViewRepresentable {
    typealias UIViewType = UIView
    
    let content: UIView
    
    init(_ view: UIView) {
        content = view
    }
    
    func makeUIView(context: Context) -> UIView {
        content
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct MoreInfo_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            AnyViewRepresentable(MoreInfoView())
                .preferredColorScheme(.dark)
                
            AnyViewRepresentable(MoreInfoView())
                .preferredColorScheme(.dark)
        }
    }
}

#endif
