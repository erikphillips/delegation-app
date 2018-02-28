let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .actionSheet)

let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
    Logger.log("Cancel button pressed.")
}

let destroyAction = UIAlertAction(title: "Red Button", style: .destructive) { action in
    Logger.log("Red button pressed.")
}

let defaultAction = UIAlertAction(title: "Default Button", style: .default) { action in
    Logger.log("Default button pressed.")
}

alertController.addAction(cancelAction)
alertController.addAction(destroyAction)

self.present(alertController, animated: true)
