import UIKit

protocol BottomViewDelegate: AnyObject {
    func createNewItem()
}

final class MainBottomView: UIView {
    weak var delegate: BottomViewDelegate?
    
    private lazy var itemsCountLabel = UILabel(frame: .zero)
    private lazy var newItemButton = UIButton(frame: .zero)
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateItemsCount(_ count: Int) {
        itemsCountLabel.text = "\(count) задач"
    }
    
    @objc private func newItemButtonAction() {
        delegate?.createNewItem()
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        sender.tintColor = .gray
    }
    
    @objc func buttonReleased(_ sender: UIButton) {
        sender.tintColor = .yellow
    }
    
    private func configureView() {
        backgroundColor = .bottom
        
        itemsCountLabel.text = "0 задач"
        itemsCountLabel.font = .systemFont(ofSize: 13)
        itemsCountLabel.textColor = .white
        
        newItemButton.addTarget(self, action: #selector(newItemButtonAction), for: .touchUpInside)
        newItemButton.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        newItemButton.addTarget(self, action: #selector(buttonReleased), for: .touchUpOutside)

        let image = UIImage.symbol("square.and.pencil", size: 25)
        newItemButton.setImage(image, for: .normal)
        newItemButton.imageView?.tintColor = .yellow
        
        for subview in [itemsCountLabel, newItemButton] {
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            itemsCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            itemsCountLabel.topAnchor.constraint(equalTo: topAnchor),
            itemsCountLabel.heightAnchor.constraint(equalToConstant: 49),
            
            newItemButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            newItemButton.topAnchor.constraint(equalTo: topAnchor),
            newItemButton.heightAnchor.constraint(equalTo: itemsCountLabel.heightAnchor),
            newItemButton.widthAnchor.constraint(equalTo: newItemButton.heightAnchor, multiplier: 1.0)
        ])
    }
}


