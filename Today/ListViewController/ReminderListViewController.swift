//
//  ViewController.swift
//  Today
//
//  Created by Smruti Bachhav on 04/03/25.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    let completionSound = SoundPlayer()
    func playSoundForCompletedReminder(_ reminder: Reminder) {
        if reminder.isComplete {
            completionSound.playSound(named: "complete")
        }
    }
//optional dataSource property.
//    Using an optional type allows the compiler to initialize a view controller class before the data source is available.
    var dataSource: DataSource?
    //var reminders: [Reminder] = Reminder.sampleData
    //Now that your app can read from EventKit, you no longer need to supply sample data.
    var reminders: [Reminder] = []
    //default value today
    var listStyle: ReminderListStyle = .today
    //The filter(_:) method loops over a collection and returns an array containing only those elements that satisfy a condition.
    var filteredReminders: [Reminder] {
        return reminders.filter { listStyle.shouldInclude(date: $0.dueDate )} . sorted {
            $0.dueDate < $1.dueDate
        }
    }
    // initialize a UISegmentedControl with the names of the list styles, and store it as a property named listStyleSegmentedControl.
    let listStyleSegmentedControl = UISegmentedControl(items: [
        ReminderListStyle.today.name, ReminderListStyle.future.name, ReminderListStyle.all.name
    ])
    
    //add a ProgressHeaderView property named headerView.
    var headerView: ProgressHeaderView?
    var progress: CGFloat {
        //Calculate the fraction of the filteredReminders array that each reminder represents
        let chunkSize = 1.0 / CGFloat(filteredReminders.count)
        let progress = filteredReminders.reduce(0.0) {
            let chunk = $1.isComplete ? chunkSize : 0.0
            return $0 + chunk
        }
        return progress
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .todayGradientFutureBegin
        
        // Do any additional setup after loading the view.
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
            
        //initialize the data source in the next step to guarantee that the optional has a value.
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        //register the header view as a supplementary view.
        let headerRegistration = UICollectionView.SupplementaryRegistration(
            elementKind: ProgressHeaderView.elementKind, handler: supplementaryRegistrationHandler
        )
        //This closure configures and returns the supplementary header view from the diffable data source.
        dataSource?.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        //create a new UIBarButtonItem for the Add button that calls the didPressAddButton(_:) selector.
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_:)))
        addButton.accessibilityLabel = NSLocalizedString(
            "Add Reminder", comment: "Add button accessibility label")
        navigationItem.rightBarButtonItem = addButton
        //set the control’s selected segment index to listStyle.rawValue.Swift automatically assigns each case an integer value, starting at 0. selectedSegmentIndex is the index number of the selected segment.
        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        //configure the target object and action method for the segmented control.
        listStyleSegmentedControl.addTarget(
            self, action: #selector(didChangeListStyle(_:)), for: .valueChanged
        )
        navigationItem.titleView = listStyleSegmentedControl
        
        navigationItem.style = .navigator
        
//        var snapshot = Snapshot()
//        snapshot.appendSections([0])
        //array containing only title of reminders
//        var reminderTitles = [String]()
//        for reminder in Reminder.sampleData {
//            reminderTitles.append(reminder.title)
//        }
//        snapshot.appendItems(reminderTitles)
        //$0 refers to the current element in the array (a Reminder object)
        //Configure the snapshot using the reminders array. Map to the id property instead of to title to create the array of identifiers.
//        snapshot.appendItems(Reminder.sampleData.map { $0.id})
//        dataSource?.apply(snapshot)//only applies if dataSource is not nil
        
        updateSnapshot()
        
        collectionView.dataSource = dataSource
        
        prepareReminderStore()
    }
    
    //To display the background, you’ll need to refresh the background in the view life cycle.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBackground()
    }
    
    //You aren’t showing the item that the user tapped as selected, so return false. Instead, you’ll transition to the detail view for that list item.
    override func collectionView(
        _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        let id = filteredReminders[indexPath.item].id
        pushDetailViewForReminder(withId: id)
        return false
    }
    
    //The system calls this method when the collection view is about to display the supplementary view.
    override func collectionView(
        _ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath
    ){
        guard elementKind == ProgressHeaderView.elementKind,
              let progressView = view as? ProgressHeaderView
        else {
            return
        }
        //This change triggers the header view’s didSet observer.
        progressView.progress = progress
    }
    
    //function that builds the background layer. You’ll call the function later in this section.
    func refreshBackground() {
        collectionView.backgroundView = nil
        let backgroundView = UIView()
        let gradientLayer = CAGradientLayer.gradientLayer(for: listStyle, in: collectionView.frame)
        //Add the gradientLayer as a sublayer to the background view’s layer.
        backgroundView.layer.addSublayer(gradientLayer)
        collectionView.backgroundView = backgroundView
    }
    
    func pushDetailViewForReminder(withId id: Reminder.ID) {
        //Retrieve the reminder that matches the identifier from the model’s array of reminders
        let reminder = reminder(withId: id)
        //add an onChange handler to the ReminderViewController initializer.
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder  in
            //This function updates the array of reminders in the data source with the edited reminder.
            self?.updateReminder(reminder)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        //inject the reminder that you retrieved Create a new detail controller, and assign it to a constant named viewController.
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //function named showError that accepts an Error.
    func showError(_ error: Error) {
        let alertTitle = NSLocalizedString("Eroor", comment: "Error alert title")
        let alert = UIAlertController(
            title: alertTitle, message: error.localizedDescription, preferredStyle: .alert)
        let actionTitle = NSLocalizedString("Ok", comment: "Alert OK button title")
        alert.addAction(
            UIAlertAction(
                title: actionTitle, style: .default,
                handler: { [weak self] _ in
                    self?.dismiss(animated: true)
                }))
        present(alert, animated: true, completion: nil)
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        //UICollectionLayoutListConfiguration creates a section in a list layout.
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.headerMode = .supplementary
        listConfiguration.showsSeparators = false
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        listConfiguration.backgroundColor = .clear
        //Return a new compositional layout with the list configuration.
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    //swipe functionality to delete reminder Each swipe action configuration object contains a set of UIContextualAction objects that defines the actions a user can perform by left or right swiping.
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        //Retrieve the item identifier from the data source.
        guard let indexPath, let id = dataSource?.itemIdentifier(for: indexPath) else {
            return nil
        }
        //When a user swipes a row, the collection view displays a button for each action in the configuration. The label for the button is the action’s title.
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) {
            [weak self] _, _, completion in
            self?.deleteReminder(withId: id)
            self?.updateSnapshot()
            //Call the completion handler.
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    //The registration handler specifies how to configure the content and appearance of the supplementary view.
    private func supplementaryRegistrationHandler(
        progressView: ProgressHeaderView, elementKind: String, indexPath: IndexPath
    ){
        headerView = progressView
    }


}

