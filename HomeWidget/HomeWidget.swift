//
//  HomeWidget.swift
//  HomeWidget
//
//  Created by Jon Mårtensson on 2021-03-25.
//  Copyright © 2021 LoopKit Authors. All rights reserved.
//

import WidgetKit
import SwiftUI


import CoreData
import HealthKit
import LoopKit
import LoopKitUI
import LoopCore
import LoopUI
//import NotificationCenter
//import SwiftCharts

import Foundation
import os.log



struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for minuteOffset in 0 ..< 2 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

func testSampleQuery() {
        var sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)

    let bloodGlucoseType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose) ?? <#default value#>
    
    let mmol = HKUnit(from: "mmol/l")
    
    let query1 = HKDiscreteQuantitySample.init(type: bloodGlucoseType, quantity: <#T##HKQuantity#>, start: <#T##Date#>, end: <#T##Date#>)

    guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose) else {
        fatalError("*** Unable to create a blood glucose quantity type ***")
    }
     
    
    let query = HKSampleQuery.init(sampleType: sampleType!,
                                           predicate: nil,
                                           limit: 1,
                                           sortDescriptors: nil) { (query, results, error) in
            print(results ?? 100)
        }

        let healthStore = HKHealthStore()
        
        healthStore.execute(query)
    
}

struct HomeWidgetEntryView : View {
    var entry: Provider.Entry
    
   
//    var query: HKQuery =

    
    
    
    
//  var latestGlucose = healthStore.executeQuery(query)
    var body: some View {
       
        VStack {
            Text(entry.date, style: .time)
            Text("BS: ")
            Text("Batterinivå: 88 %")
        }
    }
}

@main
struct HomeWidget: Widget {
    
    let kind: String = "HomeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HomeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct HomeWidget_Previews: PreviewProvider {
    static var previews: some View {
        HomeWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


