// SPDX-License-Identifier: MIT
// Copyright © 2018 WireGuard LLC. All Rights Reserved.

import Cocoa

class NoTunnelsDetailViewController: NSViewController {

    let tunnelsManager: TunnelsManager

    let importButton: NSButton = {
        let button = NSButton()
        button.title = tr("macButtonImportTunnels")
        button.setButtonType(.momentaryPushIn)
        button.bezelStyle = .rounded
        return button
    }()

    init(tunnelsManager: TunnelsManager) {
        self.tunnelsManager = tunnelsManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = NSView()

        importButton.target = self
        importButton.action = #selector(importTunnelClicked)

        view.addSubview(importButton)
        importButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            importButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            importButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.view = view
    }

    @objc func importTunnelClicked() {
        guard let window = view.window else { return }
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = ["conf", "zip"]
        openPanel.beginSheetModal(for: window) { [weak tunnelsManager] response in
            guard let tunnelsManager = tunnelsManager else { return }
            guard response == .OK else { return }
            guard let url = openPanel.url else { return }
            TunnelImporter.importFromFile(url: url, into: tunnelsManager, sourceVC: nil, errorPresenterType: ErrorPresenter.self)
        }
    }
}
