//
//  TaskViewModel.swift
//  DuNaw
//
//  Created by Wilbert Devin Wijaya on 26/07/22.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: String = "Today"
    
    // MARK: New Task Properties
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskNote: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Low"
    @Published var showDatePicker: Bool = false
    
    // MARK: Editing Existing Task Data
    @Published var editTask: Task?
    
    // MARK: Adding Task to CoreData
    func addTask(context: NSManagedObjectContext)-> Bool {
        
        // MARK: Update Existing Data to CoreData
        var task: Task!
        if let editTask = editTask {
            task = editTask
        }else{
            task = Task(context: context)

        }
        
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.note = taskNote
        task.isCompleted = false
        
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    // MARK: Resetting Data
    func resetTaskData() {
        taskType = "Low"
        taskColor = "Yellow"
        taskTitle = ""
        taskNote = ""
        taskDeadline = Date()
    }

    // MARK: If Edit Task is Available Then Setting Existing Data
    func setupTask() {
        if let editTask = editTask {
            taskType = editTask.type ?? "Low"
            taskColor = editTask.color ?? "Yellow"
            taskTitle = editTask.title ?? ""
            taskNote = editTask.note ?? ""
            taskDeadline = editTask.deadline ?? Date()
        }
    }
}


