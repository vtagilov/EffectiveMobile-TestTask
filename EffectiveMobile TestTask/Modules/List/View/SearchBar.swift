import UIKit

protocol SearchBarDelegate: AnyObject {
    func textDidChange(text: String)
    func microphoneButtonTapped(_ isSelected: Bool)
}

final class SearchBar: UIView {
    weak var searchDelegate: SearchBarDelegate?
    
    var text: String? {
        get {
            searchBar.text
        }
        set {
            searchBar.text = newValue
        }
    }
    
    private lazy var searchBar = UISearchBar(frame: .zero)
    private lazy var microphoneButton = UIButton(frame: .zero)
    private lazy var cancelButton = UIButton(frame: .zero)
    
    private var trailingConstraint: NSLayoutConstraint!

    init() {
        super.init(frame: .zero)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cancelButtonAction() {
        text = nil
        searchDelegate?.textDidChange(text: "")
        searchBar.resignFirstResponder()
    }
    
    private func configureView() {
        backgroundColor = .primaryBackground
        searchBar.searchTextField.enablesReturnKeyAutomatically = false
        searchBar.delegate = self
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.placeholder = "Search"
        searchBar.searchTextField.textColor = .white
        
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 14)
        cancelButton.alpha = 0
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        if let image = UIImage(named: "microphone") {
            microphoneButton.setImage(image, for: .normal)
        }
        if let image = UIImage(named: "microphone.fill") {
            microphoneButton.setImage(image, for: .selected)
        }
        microphoneButton.addTarget(self, action: #selector(microphoneButtonTapped), for: .touchUpInside)
        
        for subview in [searchBar, microphoneButton, cancelButton] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
        configureConstraints()
    }
    
    private func configureConstraints() {
        trailingConstraint = searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8)
        trailingConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -8),
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            microphoneButton.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -4),
            microphoneButton.topAnchor.constraint(equalTo: topAnchor),
            microphoneButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            microphoneButton.widthAnchor.constraint(equalTo: microphoneButton.heightAnchor),
            
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            cancelButton.topAnchor.constraint(equalTo: topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func updateConstraints(isEditing: Bool) {
        trailingConstraint.isActive = false
        if isEditing {
            trailingConstraint = searchBar.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -8)
        } else {
            trailingConstraint = searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8)
        }
        trailingConstraint.isActive = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.cancelButton.alpha = !isEditing ? 0 : 1
            self.layoutIfNeeded()
        })

    }
    
    @objc private func microphoneButtonTapped() {
        microphoneButton.isSelected.toggle()
        searchDelegate?.microphoneButtonTapped(microphoneButton.isSelected)
    }
}

extension SearchBar: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        microphoneButton.isHidden = !(text?.isEmpty ?? true)
        updateConstraints(isEditing: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        microphoneButton.isHidden = !(text?.isEmpty ?? true)
        updateConstraints(isEditing: false)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        microphoneButton.isHidden = !(text?.isEmpty ?? true)
        searchDelegate?.textDidChange(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

