import UIKit
import BambuserPlayerSDK

final class PlayerListCell: UITableViewCell {
    
    static let id = "PlayerListCell"
    
    var recentlyReused = false
    var onPlayerEvent: ((BambuserPlayerEvent) -> Void)?
    
    private var playerView: BambuserPlayerUIView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: ViewModel) {
        recentlyReused = playerView != nil
        playerView?.removeFromSuperview()

        let playerView = BambuserPlayerUIView(
            showId: viewModel.showId,
            environment: viewModel.environment,
            config: viewModel.playerConfiguration,
            context: viewModel.context,
            productDetailsDataSource: viewModel.productDetailsDataSource,
            playerCartDataSource: viewModel.playerCartDataSource,
            playerCartDelegate: viewModel.playerCartDelegate,
            handlePlayerEvent: onPlayerEvent
        )
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

extension PlayerListCell {
    struct ViewModel {
        var showId: String
        var environment: BambuserEnvironment?
        var playerConfiguration: PlayerConfiguration
        var context: BambuserPlayerContext?
        var productDetailsDataSource: ProductDetailsDataSource?
        var playerCartDataSource: PlayerCartDataSource?
        var playerCartDelegate: PlayerCartDelegate?
    }
}
