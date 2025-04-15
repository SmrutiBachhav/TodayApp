//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by Smruti Bachhav on 29/03/25.
//

import UIKit



//This extension will contain all the behaviors that let the ReminderListViewController act as a data source to the reminder list.

extension ReminderListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    //add an accessibilityValue to the button.by computing a localized string for each reminder’s completion status.
    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }
    
    //computed property named reminderStore that returns the shared reminder store.
    private var reminderStore: ReminderStore { ReminderStore.shared }
    
    func updateSnapshot(reloading idsThatChanged: [Reminder.ID] = []) {
        //Filter idsThatChanged to include only identifiers that correspond to reminders in the filteredReminders array, and assign the result to a constant named ids.
        let ids = idsThatChanged.filter{ id in filteredReminders.contains(where: { $0.id == id})}
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredReminders.map { $0.id})
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        dataSource?.apply(snapshot)//only applies if dataSource is not nil
        //update the header view’s progress.
        headerView?.progress = progress
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID){
        //Retrieve the reminder corresponding to the item.
        let reminder = reminder(withId: id)
        //defaultContentConfiguration() creates a content configuration with the predefined system style.
        var contentConfiguration = cell.defaultContentConfiguration()
        //The list displays the configuration text as the primary text of a cell.
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(
            forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        //set the cell’s accessibilityCustomActions array to an instance of the custom action.
        cell.accessibilityCustomActions = [doneButtonAccessibilityAction(for: reminder)]
        cell.accessibilityValue =
        reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
        
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)
        ]
        
        //setting different predefined background color to each cell
        var backgroundConfiguration = UIBackgroundConfiguration.listCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    //a method named reminder(withId:) that accepts a reminder identifier and returns the corresponding reminder from the reminders array.
    func reminder(withId id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(withId: id)
        return reminders[index]
    }
    
    //accepts a reminder and updates the corresponding array element with the contents of the reminder
    func updateReminder(_ reminder: Reminder) {
        do {
            try reminderStore.save(reminder)
            let index = reminders.indexOfReminder(withId: reminder.id)
            reminders[index] = reminder
        } catch TodayError.accessDenied {
        } catch {
            showError(error)
        }
    }
    
    //create a completeReminder(withId:) method that accepts a Reminder.ID.
    //You’ll use Reminder.ID to fetch a reminder from the model. method in the view controller that completes a reminder
    func completeReminder(withId id: Reminder.ID) {
        //Fetch the reminder by calling reminder(withId:)
//        let completionSound = SoundPlayer()
        var reminder = reminder(withId: id)
        reminder.isComplete.toggle()
        playSoundForCompletedReminder(reminder)
//        completionSound.playSound(named: "preview")
        updateReminder(reminder)
        updateSnapshot(reloading: [id])
//        do {
//                try reminderStore.save(reminder)
                
//            } catch {
//                print("Failed to update reminder: \(error)")
//            }

    }
    
    //create an addReminder(_:) method that appends a reminder to the reminders array.use this method to save a new reminder when the user taps the Done button.
    func addReminder(_ reminder: Reminder) {
        var reminder = reminder
        do {
            let idFromStore = try reminderStore.save(reminder)
            reminder.id = idFromStore
            reminders.append(reminder)
        } catch TodayError.accessDenied {
        } catch {
            showError(error)
        }
    }
    
    //to delete reminder swipe functionality
    func deleteReminder(withId id: Reminder.ID) {
        do {
            try reminderStore.remove(with: id)
            let index = reminders.indexOfReminder(withId: id)
            reminders.remove(at: index)
        } catch TodayError.accessDenied {
        } catch {
            showError(error)
        }
    }
    
    //function named prepareReminderStore that has an empty Task instance.
    //By creating a Task, you create a new unit of work that executes asynchronously.
    func prepareReminderStore() {
        Task {
            //awaits access to the reminder store.
            do {
                try await reminderStore.requestAccess()
                //Await the result of readAll(), and then assign its result to reminders.
                //async throwing function named readAll that returns an array of Reminder.(ReminderStore)
                reminders = try await reminderStore.readAll()
//When the system receives this change notification, it calls the corresponding action method on your view controller.
                NotificationCenter.default.addObserver(self, selector: #selector(eventStoreChanged(_:)), name: .EKEventStoreChanged, object: nil )
            } catch TodayError.accessDenied, TodayError.accessRestricted{
                //Assign sample data to the reminders array in debug mode.
#if DEBUG
                //Providing sample data allows your app to function in a demonstration mode when EventKit data is unavailable.
                reminders = Reminder.sampleData
#endif
            } catch {
                //Similar to a default case in a switch statement, this catch block catches any remaining error.
                showError(error)
            }
            updateSnapshot()
        }
    }

    
    //voiceOver
    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString(
            "Toggle completion", comment: "Reminder done button accessbility label")
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            self?.completeReminder(withId: reminder.id)
            return true
        }
        return action
    }

    func reminderStoreChanged() {
        Task {
            //Recall that the await keyword indicates that your task suspends until the asynchronous method readAll() completes.
            reminders = try await reminderStore.readAll()
            updateSnapshot()
        }
    }
    
    //Create a new function named doneButtonConfiguration that accepts a reminder and returns a CustomViewConfiguration.
    //a circle-shaped button. The button serves both as an interface and as an indicator of the complete or incomplete status for each reminder.
    private func doneButtonConfiguration(for reminder: Reminder)
    -> UICellAccessory.CustomViewConfiguration
    {
        //Use the ternary conditional operator to assign either "circle.fill" or "circle" to a constant named symbolName.
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.id = reminder.id
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(
            customView: button, placement: .leading(displayed: .always))
    }
    
}
