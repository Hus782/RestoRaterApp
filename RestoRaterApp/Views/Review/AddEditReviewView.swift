//
//  AddEditReviewView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/11/23.
//

import SwiftUI

enum ReviewViewScenario {
    case add
    case edit
}

struct AddEditReviewView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel: AddEditReviewViewModel
    private let scenario: ReviewViewScenario
    var onAddCompletion: (() -> Void)?
    
    init(scenario: ReviewViewScenario, review: Review? = nil, restaurant: Restaurant? = nil) {
        self.scenario = scenario
        _viewModel = StateObject(wrappedValue: AddEditReviewViewModel(scenario: scenario, review: review, restaurant: restaurant))
        
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Rating")) {
//                    Picker("Rating", selection: $viewModel.rating) {
//                        ForEach(0..<6) { number in
//                            Text("\(number)")
//                        }
//                    }
                    RatingPickerView(rating: $viewModel.rating)
                    
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Comment")) {
                    TextField("Comment", text: $viewModel.comment)
                }
                
                Section(header: Text("Date of Visit")) {
                    DatePicker("Visit Date", selection: $viewModel.visitDate, displayedComponents: .date)
                }
                
                Section {
                    Button("Submit Review") {
                        handleSave()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Add Review", displayMode: .inline)
        }
    }
    
    private func handleSave() {
        switch scenario {
        case .add:
            viewModel.addReview(context: viewContext)
        case .edit:
            viewModel.editReview(context: viewContext)
        }
    }
}
