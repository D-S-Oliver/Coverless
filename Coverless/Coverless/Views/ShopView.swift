//
//  ShopView.swift
//  Coverless
//
//  Created by Beatriz Duque on 23/09/21.
//

import UIKit

class ShopView: UIView{
    
    let designSystem: DesignSystem
    
    private let imageLogo: UIImageView
    public var url: String
    public let shopTitle: UILabel
    public let priceValue: UILabel
    public let shopButton: UIButton
    
    private lazy var normalLayout = [
        imageLogo.topAnchor.constraint(equalTo: self.topAnchor),
        imageLogo.heightAnchor.constraint(equalToConstant: 80),
        imageLogo.widthAnchor.constraint(equalToConstant: 80),
        imageLogo.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        imageLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        
        shopTitle.topAnchor.constraint(equalTo: self.topAnchor),
        shopTitle.leadingAnchor.constraint(equalTo: imageLogo.trailingAnchor, constant: \.smallPositive),
        shopTitle.trailingAnchor.constraint(equalTo: shopButton.leadingAnchor, constant: \.smallNegative),

        priceValue.leadingAnchor.constraint(equalTo: shopTitle.leadingAnchor),
        priceValue.topAnchor.constraint(equalTo: shopTitle.bottomAnchor, constant: \.smallPositive),

        shopButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: \.smallNegative),
        shopButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        shopButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2)
    ]
    
    private lazy var accessibilityLayout = [
        imageLogo.topAnchor.constraint(equalTo: self.topAnchor),
        imageLogo.heightAnchor.constraint(equalToConstant: 100),
        imageLogo.widthAnchor.constraint(equalToConstant: 100),
        imageLogo.bottomAnchor.constraint(equalTo: shopTitle.topAnchor),
        imageLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        
        shopTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: \.smallPositive),
        shopTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: \.smallNegative),
        shopTitle.bottomAnchor.constraint(equalTo: priceValue.topAnchor,constant: \.smallNegative),
        
        priceValue.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: \.smallPositive),
        priceValue.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        priceValue.bottomAnchor.constraint(equalTo: shopButton.topAnchor,constant: \.smallNegative),

        shopButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: \.smallNegative),
        shopButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: \.smallPositive),
        shopButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: \.smallNegative),
        shopButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2)
    ]
    
    // fazer constraints para textos maiores!!!
    
    
    init() {
        imageLogo = UIImageView()
        shopTitle = UILabel()
        priceValue = UILabel()
        shopButton = UIButton()
        url = String()
        designSystem = DefaultDesignSystem()
        super.init(frame: .zero)
        setupLayout()
        stylize(with: designSystem)
        addSubview(imageLogo)
        addSubview(shopTitle)
        addSubview(priceValue)
        addSubview(shopButton)
        activateConstraints()
        setupActions()
        
        
    }
    /// passa as informacoes de compra para a view
    init(image: UIImage, titulo: String, price: String,url: String, designSystem: DesignSystem = DefaultDesignSystem()){
        self.url = url
        self.designSystem = designSystem
        
        imageLogo = UIImageView()
        imageLogo.image = image
        
        shopTitle = UILabel()
        shopTitle.text = titulo
        
        priceValue = UILabel()
        priceValue.text = "R$\(price)"
        
        shopButton = UIButton()
        
        super.init(frame: .zero)
        
        setupLayout()
        stylize(with: designSystem)
        
        addSubview(imageLogo)
        addSubview(shopTitle)
        addSubview(priceValue)
        addSubview(shopButton)
        
        activateConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        ///imagem
        layer.masksToBounds = true
        imageLogo.translatesAutoresizingMaskIntoConstraints = false
        shopButton.translatesAutoresizingMaskIntoConstraints = false
        shopTitle.translatesAutoresizingMaskIntoConstraints = false
        priceValue.translatesAutoresizingMaskIntoConstraints = false
        
        //imageView.clipsToBounds = true
        imageLogo.frame = bounds
        imageLogo.contentMode = .scaleAspectFit
        imageLogo.layer.cornerRadius = 14.5

        ///botao
        shopButton.backgroundColor = designSystem.palette.buttonBackgroundPrimary
        shopButton.setTitle("Shop", for: .normal)
        shopButton.setTitleColor(designSystem.palette.buttonTextPrimary, for: .normal)
        shopButton.layer.cornerRadius = 8
    }
    
    func stylize(with designSystem: DesignSystem) {
        shopTitle.stylize(with: designSystem.text.title)
        priceValue.stylize(with: designSystem.text.header)
        setAccessibility()
    }
    
    func activateConstraints(){
        if (traitCollection.preferredContentSizeCategory
                < .accessibilityMedium) { // Default font sizes
            accessibilityLayout.forEach{
                $0.isActive = false
            }
            NSLayoutConstraint.activate(normalLayout)
            
        } else { // Accessibility font sizes
            normalLayout.forEach{
                $0.isActive = false
            }
            NSLayoutConstraint.activate(accessibilityLayout)
        }
        
    }
    
    private func setupActions(){
        shopButton.addTarget(self, action: #selector(openURL), for: .touchUpInside)
    }
    
    @objc func openURL(){
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func setAccessibility(){
        shopTitle.isAccessibilityElement = true
        priceValue.isAccessibilityElement = true
        shopButton.isAccessibilityElement = true
        shopButton.accessibilityHint = "click to be redirected"
        
        
        self.accessibilityElements = [shopTitle,priceValue,shopButton]
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        activateConstraints()
    }
}
