//
//  DynamicFilteredView.swift
//  DuNaw
//
//  Created by Wilbert Devin Wijaya on 27/07/22.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject{
    // MARK: CoreData Request
    @FetchRequest var request: FetchedResults<T>
    let content: (T)-> Content
    
    // MARK: Building Custom ForEach Which Will Give CoreData Object To Build View
    init(currentTab: String, @ViewBuilder content: @escaping (T)->Content) {
        
        // MARK: Predicate To Filter Current Date Tasks
        let calendar = Calendar.current
        var predicate: NSPredicate!
        
        if currentTab == "Today" {
            let today = calendar.startOfDay(for: Date())
            let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!
            
            // Filter Key
            let filterKey = "deadline"
            
            // This Will Fetch Task Between Today and Tommorow Which is 24HRS
            // 0-False, 1-True
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow, 0])
            
        }else if currentTab == "Upcoming" {
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tommorow = Date.distantFuture
            
            // Filter Key
            let filterKey = "deadline"
            
            // This Will Fetch Task Between Today and Tommorow Which is 24HRS
            // 0-False, 1-True
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow, 0])
        }else if currentTab == "Failed" {
            let today = calendar.startOfDay(for: Date())
            let past  = Date.distantPast
            
            // Filter Key
            let filterKey = "deadline"
            
            // This Will Fetch Task Between Today and Tommorow Which is 24HRS
            // 0-False, 1-True
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past, today , 0])
        }
        else {
            
        }
        
        // Initializing Request With NSPredicate
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        
        Group {
            if request.isEmpty {
                Text("No Task Found!!!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            }
            else {
                
                ForEach(request, id: \.objectID){ object in
                    self.content(object)
                }
            }
        }
    }
}


