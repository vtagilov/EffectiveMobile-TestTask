import UIKit

protocol DetailsView: BaseView {
    func configure(_ model: ToDoItem)
}

final class DetailsViewController: UIViewController, DetailsView {
    var presenter: DetailsPresenter!
    
    private lazy var titleLabel = UILabel()
    private lazy var dateLabel = UILabel()
    private lazy var textView = UITextView()
    
    override func viewDidLoad() {
        configureView()
    }
    
    func configure(_ model: ToDoItem) {
        titleLabel.text = model.todo
        textView.text = model.todo
    }

    @objc private func backAction() {
        presenter.navigateBack()
    }

    private func configureView() {
        view.backgroundColor = .primaryBackground
        navigationItem.backAction = UIAction(handler: { [weak self] _ in
            self?.presenter.navigateBack()
        })
        navigationController?.navigationBar.tintColor = .yellow
        
        titleLabel.text = (titleLabel.text?.isEmpty ?? true) ? "Задачи" : titleLabel.text
        titleLabel.font = .boldSystemFont(ofSize: 34)
        titleLabel.textAlignment = .left
        
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        dateLabel.text = Date().formattedDate()
        
        textView.font = .systemFont(ofSize: 16)
        textView.delegate = self
        
        for subview in [titleLabel, dateLabel, textView] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 56),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 24),
            
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 24),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension DetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter.updateText(textView.text)
        titleLabel.text = textView.text
    }
}
