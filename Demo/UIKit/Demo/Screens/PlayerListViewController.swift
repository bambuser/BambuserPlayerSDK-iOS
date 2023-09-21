import UIKit
import BambuserPlayerSDK

final class PlayerListViewController: UIViewController {
    
    private let settings: DemoSettings
    private let playerConfig: PlayerConfiguration
    
    private var showIds: [String]
    private var visibleCellIndex: Int?
    private var playerStates: [PlayerState]
    private var keyboardShown = false
    
    private let tableView = UITableView()

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        }
        return [.portrait, .portraitUpsideDown]
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        }
        return super.preferredInterfaceOrientationForPresentation
    }
    
    init(settings: DemoSettings) {
        self.settings = settings
        self.playerConfig = settings.playerConfiguration.copy() ?? PlayerConfiguration()
        self.playerConfig.pipConfig.isEnabled = false
        self.playerConfig.uiConfig.ignoreSystemInsets = true
        self.playerConfig.uiConfig.closeButton = .hidden
        self.playerConfig.uiConfig.chatSize = CGSize(width: 0.7, height: 0.5)
        
        self.showIds = [settings.showId] + settings.upcomingShows
        self.playerStates = self.showIds.map {
            PlayerState(showId: $0)
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        if #available(iOS 16.0, *) {
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            let orientationValue = preferredInterfaceOrientationForPresentation.rawValue
            UIDevice.current.setValue(orientationValue, forKey: "orientation")
        }
    }
    
    func setupViews() {

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.register(PlayerListCell.self, forCellReuseIdentifier: PlayerListCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.decelerationRate = .fast
        tableView.bounces = false
    }
    
    func setupListeners() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.willBecomeInactive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func playerStateAt(_ index: Int?) -> PlayerState? {
        index.flatMap { playerStates[safe: $0] }
    }
    
    private func showIdAt(_ index: Int?) -> String? {
        index.flatMap { showIds[safe: $0] }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Handling app state

extension PlayerListViewController {
    
    @objc private func didBecomeActive() {
        guard
            let state = playerStateAt(visibleCellIndex) ?? playerStates.first
        else { return }
        if state.playWhenForeground {
            state.playWhenVisible = true
            state.resume()
        }
    }
    
    @objc private func willBecomeInactive() {
        guard
            let state = playerStateAt(visibleCellIndex) ?? playerStates.first
        else { return }
        state.playWhenForeground = state.playWhenVisible
    }
}

extension PlayerListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlayerListCell.id,
            for: indexPath
        ) as? PlayerListCell else { return UITableViewCell() }

        let index = indexPath.row
        let showId = showIds[index]

        let viewModel = PlayerListCell.ViewModel(
            showId: showId,
            environment: settings.environment,
            playerConfiguration: playerConfig,
            context: playerStates[index].context
        )
        cell.onPlayerEvent = { [weak self, weak cell] event in
            guard
                let self,
                let cell,
                let state = self.playerStateAt(index)
            else { return }
            
            self.handleInteractiveEvent(event: event)
            
            let isCellVisible = !(self.visibleCellIndex != nil && index != self.visibleCellIndex)
            state.handle(event: event, isCellVisible: isCellVisible, cell: cell)
        }
        cell.configure(viewModel: viewModel)
        return cell
    }
}

// MARK: Interactive Events

private extension PlayerListViewController {
    
    func handleInteractiveEvent(event: BambuserPlayerEvent) {
        switch event {
        case .playerFailed(let error): handlePlayerError(error)
        case .openTosOrPpUrl(let url): openExternalUrl(url)
        case .openUrlFromChat(let url): openExternalUrl(url)
        case .openProduct(let product): openProductDetails(product)
        case .openShareShowSheet(let url): shareUrl(url: url)
        case .openCalendar(let info): saveCalendarEvent(in: info)
        default: break
        }
    }
        
    func handlePlayerError(_ error: BambuserPlayerSDKError) {
        UIAlertController.show(
            title: "Error",
            message: error.localizedDescription,
            from: self
        )
    }
        
    func openExternalUrl(_ url: URL?) {
        guard let url = url else { return }
        UIApplication.shared.open(url)
    }

    func openProductDetails(_ product: BambuserPlayerEvent.Product) {
        guard let url = product.publicUrl else {
            return
        }
        let webController = CustomWebViewController(url: url, isBeingPopped: {})
        if let navigationController {
            navigationController.pushViewController(webController, animated: true)
        } else {
            present(webController, animated: true)
        }
    }
        
    func saveCalendarEvent(in event: CalendarEvent) {
        event.saveToCalendar { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure: UIAlertController.show(
                title: "Error",
                message: "Failed to save calendar event.",
                from: self)
            case .success: UIAlertController.show(
                title: "Success",
                message: "Event was added to calendar at \(event.startDate).",
                from: self)
            }
        }
    }

    func shareUrl(url: URL) {
        print("Show share sheet for url: \(url)")
        LiveShoppingShareHelper.share(url: url, on: self)
    }
}

extension PlayerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {

        let midPoint = CGPoint(x: tableView.bounds.midX, y: tableView.bounds.midY)
        guard
            let indexPath = tableView.indexPathForRow(at: midPoint),
            let cell = tableView.cellForRow(at: indexPath)
        else { return }
        
        onScrolledTo(indexPath: indexPath)

        let maxOffset = tableView.contentSize.height - tableView.bounds.height
        if targetContentOffset.pointee.y <= 0 || targetContentOffset.pointee.y >= maxOffset {
            return
        }
        let heightDiff = tableView.bounds.height - cell.bounds.height
        let offset = CGPoint(x: 0, y: cell.frame.minY - (heightDiff * 0.5))

        targetContentOffset.pointee = offset
        
        onScrolledTo(indexPath: indexPath)
    }
    
    private func onScrolledTo(indexPath: IndexPath) {
        visibleCellIndex = indexPath.row
        for (index, state) in playerStates.enumerated() {
            if index == visibleCellIndex {
                state.resume()
            } else {
                state.pause()
            }
        }
    }
}

// MARK: - Keyboard handling

extension PlayerListViewController {
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard !keyboardShown else { return }
        keyboardShown = true
        let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardHeight = keyboardSize?.height ?? 0
        let safeAreaBottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y -= keyboardHeight - safeAreaBottom
        }
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        keyboardShown = false
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
}

extension PlayerListViewController {
    
    final class PlayerState {
        
        var context = BambuserPlayerContext()
        
        var playWhenVisible = true
        var playWhenForeground = true
        var resumeCounter = 0
        
        let showId: String
        
        init(showId: String) {
            self.showId = showId
        }
        
        func pause() {
            context.sendEvent(.pause)
        }
        
        func resume() {
            guard playWhenVisible else {
                return
            }
            context.sendEvent(.resume)
        }
        
        func handle(
            event: BambuserPlayerEvent,
            isCellVisible: Bool,
            cell: PlayerListCell
        ) {
            switch event {
            case .resumed:
                resumeCounter += 1

                let pauseIfVisible = !playWhenVisible && (resumeCounter <= 1 || cell.recentlyReused)
                if !isCellVisible || pauseIfVisible {
                    pause()
                }
                if isCellVisible {
                    playWhenVisible = true
                }
                cell.recentlyReused = false
            case .paused:
                if isCellVisible && resumeCounter > 0 {
                    playWhenVisible = false
                }
            default:
                break
            }
        }
    }
}
