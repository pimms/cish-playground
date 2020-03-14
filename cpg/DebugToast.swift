import Foundation
import Cocoa

enum DebugToastType {
    case textView
    case debug
}

private extension DebugToastType {
    var image: NSImage? {
        return nil
    }

    var tintColor: NSColor {
        switch self {
        case .textView:
            return .systemPink
        case .debug:
            return .systemGreen
        }
    }
}

struct DebugToast {
    static var enabledTypes: [DebugToastType] = []

    private static var toastContainerViews: [DebugToastContainerView] = []

    static func setupContainerView(in view: NSView) {
    #if DEBUG || BETA
        let toastContainerView = DebugToastContainerView()
        toastContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toastContainerView)

        toastContainerViews.append(toastContainerView)

        NSLayoutConstraint.activate([
            toastContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            toastContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            toastContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor)
        ])
    #endif
    }

    /// Important messages that may be of interest for everyone should be sent through this method.
    static func display(_ message: String, type: DebugToastType) {
    #if DEBUG || BETA
        DispatchQueue.main.async {
            if enabledTypes.isEmpty || enabledTypes.contains(type) {
                toastContainerViews.forEach { $0.display(message, type: type) }
            }
        }
    #endif
    }
}

private class DebugToastContainerView: NSView {

    // MARK: - UI properties

    private lazy var stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.orientation = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fillProportionally
        stackView.spacing = 1
        return stackView
    }()

    // MARK: - Setup

    required init?(coder: NSCoder) {
        fatalError()
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Internal methods

    func display(_ message: String, type: DebugToastType) {
        let toastView = DebugToastMessageView(message: message, type: type)

        stackView.addArrangedSubview(toastView)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.stackView.removeArrangedSubview(toastView)
            toastView.removeFromSuperview()
        }
    }
}

private class DebugToastMessageView: NSView {

    // MARK: - UI properties

    private lazy var imageView: NSImageView = {
        let imageView = NSImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var label: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isSelectable = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alignment = .right
        label.font = NSFont.systemFont(ofSize: 10)
        label.textColor = .labelColor
        label.isBordered = false
        label.backgroundColor = .clear
        return label
    }()

    // MARK: - Setup

    required init?(coder: NSCoder) {
        fatalError()
    }

    init(message: String, type: DebugToastType) {
        super.init(frame: .zero)
        setup()
        configure(withMessage: message, type: type)
    }

    private func setup() {
        addSubview(label)
        addSubview(imageView)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),

            imageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 3),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -3),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            imageView.widthAnchor.constraint(equalToConstant: 8),
            imageView.heightAnchor.constraint(equalToConstant: 8)
        ])

        layer?.masksToBounds = true
        layer?.cornerRadius = 4
    }

    private func configure(withMessage message: String, type: DebugToastType) {
        label.stringValue = message
        imageView.image = type.image
        imageView.contentTintColor = type.tintColor
        wantsLayer = true
        layer?.backgroundColor = type.tintColor.withAlphaComponent(0.4).cgColor
    }
}
