import UIKit

final class MembershipViewController: UIViewController {
    private let tableView = UITableView()
    private var memberships: [Membership] = []
    let clubId: Int

    init(clubId: Int) {
        self.clubId = clubId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("🎯✅ MEMBERSHIP VC LOADED! clubId = \(clubId)")
        title = "Заявки на вступление"
        view.backgroundColor = .systemYellow  // чтобы видеть экран!
        setupTable()
        fetchMemberships()
    }

    private func setupTable() {
        tableView.register(MembershipCell.self, forCellReuseIdentifier: MembershipCell.reuseID)
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

    private func fetchMemberships() {
        print("📡 Fetching memberships for club \(clubId)…")
        NetworkManager.shared.getPendingMemberships(clubId: clubId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    print("✅ Got \(data.count) memberships")
                    self?.memberships = data
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("❌ Error fetching memberships: \(error.localizedDescription)")
                }
            }
        }
    }

    private func updateStatus(at index: Int, status: String) {  // ✅ теперь правильно внутри класса
        let membership = memberships[index]
        print("Updating membership \(membership.id) to \(status)")

        NetworkManager.shared.updateMembershipStatus(
            clubId: clubId,
            membershipId: membership.id,
            status: status
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ Status updated, removing from list")
                    self?.memberships.remove(at: index)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("❌ Update failed: \(error)")
                }
            }
        }
    }
}

extension MembershipViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = memberships.count
        print("📊 Table rows: \(count)")
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MembershipCell.reuseID,
            for: indexPath
        ) as! MembershipCell

        let membership = memberships[indexPath.row]
        cell.configure(with: membership)

 
       /// cell.onAccept = { [weak self] in
           // self?.updateStatus(at: indexPath.row, status: "accepted")
       // }
       // cell.onReject = { [weak self] in
       //     self?.updateStatus(at: indexPath.row, status: "rejected")
       // }

        return cell
    }
}
