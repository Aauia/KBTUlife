import UIKit

class FiltersViewController: UIViewController {
    var onApply: (([String: String]) -> Void)?
    
    private let freeSwitch = UISwitch()
    private let categoryPicker = UIPickerView()
    private let categories = ["Все", "Ярмарки", "Семинары", "Guest lectures", "Психолог", "Выездное", "Parties", "Games"]
    private var selectedCategory = "Все"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Фильтры"
        view.backgroundColor = .systemBackground
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        let applyButton = UIBarButtonItem(title: "Применить", style: .done, target: self, action: #selector(applyFilters))
        navigationItem.rightBarButtonItem = applyButton
        
        let freeRow = createRow(title: "Бесплатные", control: freeSwitch)
        let categoryRow = createRow(title: "Категория", control: categoryPicker)
        
        let stack = UIStackView(arrangedSubviews: [freeRow, categoryRow])
        stack.axis = .vertical
        stack.spacing = 30
        stack.alignment = .fill
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // Правильный метод — возвращает UIView с UILabel + control
    private func createRow(title: String, control: UIView) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17)
        
        let hStack = UIStackView(arrangedSubviews: [titleLabel, control])
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.spacing = 10
        
        return hStack
    }
    
    @objc private func applyFilters() {
        var filters: [String: String] = [:]
        
        if freeSwitch.isOn {
            filters["is_free"] = "true"
        }
        
        if selectedCategory != "Все" {
            // Подгони под backend category field (в репо это "category")
            filters["category"] = selectedCategory.lowercased()
        }
        
        onApply?(filters)
        dismiss(animated: true)
    }
}

// MARK: UIPickerViewDataSource & Delegate
extension FiltersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
    }
}
