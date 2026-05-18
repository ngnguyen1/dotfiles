import Foundation

private let reloadScript = NSHomeDirectory() + "/.config/theme-reload/reload.sh"
private var lastFire = Date.distantPast
private var retained: [NSObjectProtocol] = []

private func runReload() {
  let now = Date()
  guard now.timeIntervalSince(lastFire) > 0.25 else { return }
  lastFire = now
  let task = Process()
  task.executableURL = URL(fileURLWithPath: "/bin/bash")
  task.arguments = [reloadScript]
  task.standardOutput = FileHandle.nullDevice
  task.standardError = FileHandle.nullDevice
  do {
    try task.run()
    task.waitUntilExit()
  } catch { /* ignore */ }
}

private func startListener() {
  let center = DistributedNotificationCenter.default()
  let names = [
    "AppleInterfaceThemeChangedNotification",
    "AppleColorPreferencesChangedNotification",
  ]
  for name in names {
    let token = center.addObserver(forName: Notification.Name(name), object: nil, queue: .main) { _ in
      runReload()
    }
    retained.append(token)
  }
  RunLoop.main.run()
}

startListener()
