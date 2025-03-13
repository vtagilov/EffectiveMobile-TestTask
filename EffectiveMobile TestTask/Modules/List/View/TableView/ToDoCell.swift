import UIKit

protocol ToDoCellDelegate: AnyObject {
    func updateModel(_ model: ToDoItem)
    func editButtonTapped(model: ToDoItem)
    func shareButtonTapped(model: ToDoItem)
    func deleteButtonTapped(model: ToDoItem)
}

final class ToDoCell: UITableViewCell {
    static var reuseIdentifier: String = "ToDoCell"
    
    weak var delegate: ToDoCellDelegate?
    
    private var model: ToDoItem!
    private lazy var completeButton = UIButton(frame: .zero)
    private lazy var titleLabel = UILabel(frame: .zero)
    private lazy var descriptionLabel = UILabel(frame: .zero)
    private lazy var dateLabel = UILabel(frame: .zero)
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: ToDoItem) {
        self.model = model
        completeButton.isSelected = model.completed
        completeButton.tintColor = model.completed ? .yellow : .gray
        titleLabel.textColor = model.completed ? .gray : .white
        titleLabel.setStrikethroughText(model.todo, isStrikethrough: model.completed)
        descriptionLabel.text = model.todo
        descriptionLabel.textColor = model.completed ? .gray : .white
    }
    
    @objc private func completeButtonTapped() {
        model?.completed.toggle()
        guard let model else { return }
        delegate?.updateModel(model)
        completeButton.isSelected = model.completed
        completeButton.tintColor = model.completed ? .yellow : .gray
        titleLabel.textColor = model.completed ? .gray : .white
        titleLabel.setStrikethroughText(model.todo, isStrikethrough: model.completed)
        descriptionLabel.textColor = model.completed ? .gray : .white
    }
    
    private func setupContextMenu() {
        let interaction = UIContextMenuInteraction(delegate: self)
        addInteraction(interaction)
    }
    
    private func configureView() {
        backgroundView = nil
        backgroundColor = .clear
        completeButton.setImage(UIImage.symbol("circle", size: 20), for: .normal)
        completeButton.setImage(UIImage.symbol("checkmark.circle", size: 20), for: .selected)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        titleLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 2
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        dateLabel.text = Date().formatted()
        for subview in [completeButton, titleLabel, descriptionLabel, dateLabel] {
            contentView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        configureConstraints()
        setupContextMenu()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            completeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            completeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            completeButton.heightAnchor.constraint(equalToConstant: 48),
            completeButton.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 32),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateLabel.heightAnchor.constraint(equalToConstant: 24),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
}

extension ToDoCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(
                children: [
                    UIAction(
                        title: "Редактировать",
                        image: UIImage(named: "EditImage")?.withTintColor(.white),
                        handler: { [weak self] _ in
                            guard let sSelf = self else { return }
                            sSelf.delegate?.editButtonTapped(model: sSelf.model)
                        }),
                    UIAction(
                        title: "Поделиться",
                        image: UIImage(named: "ShareImage")?.withTintColor(.white),
                        handler: { [weak self] _ in
                            guard let sSelf = self else { return }
                            sSelf.delegate?.shareButtonTapped(model: sSelf.model)
                    }),
                    UIAction(
                        title: "Удалить",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive,
                        handler: { [weak self] _ in
                            guard let sSelf = self else { return }
                            sSelf.delegate?.deleteButtonTapped(model: sSelf.model)
                    })
                ]
            )
        }
    }
}
