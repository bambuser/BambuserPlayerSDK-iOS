# Multiple players

## UIKit 

For adding single or multiple players to some `UIView` it’s preferable to use `BambuserPlayerUIView`.

Example: [PlayerListViewController.swift](../Demo/UIKit/Demo/Screens/PlayerListViewController.swift).

```swift 
    let playerView = BambuserPlayerUIView(showId: "some show id")
    yourView.addSubview(playerView)
```
 

## SwiftUI

For displaying multiple players in SwiftUI it’s possible to wrap `UITableView` or `UICollectionView` with players using `UIViewRepresentable`.

```swift

struct PlayerListView: UIViewRepresentable {

    let dataSource = PlayerListViewDataSource()

    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.register(PlayerListCell.self, forCellReuseIdentifier: "PlayerListCell")
        tableView.dataSource = dataSource
        // add other configuration...

        return tableView
    }

    func updateUIView(_ view: UITableView, context: Context) {}
}

class PlayerListViewDataSource: NSObject, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlayerListCell.id,
            for: indexPath
        ) as? PlayerListCell else { return UITableViewCell() }

        cell.configure(showId: showId)
        return cell
    }

    // ....
}

class PlayerListCell: UITableViewCell {

    private var playerView: BambuserPlayerUIView?
    
    func configure(showId: String) {
        playerView?.removeFromSuperview()

        let playerView = BambuserPlayerUIView(showId: showId)
        self.playerView = playerView
        addSubview(playerView)

        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: topAnchor),
            playerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            playerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
```