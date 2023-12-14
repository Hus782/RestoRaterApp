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
    
    init(scenario: ReviewViewScenario, review: Review? = nil, restaurant: Restaurant? = nil, onAddCompletion: (() -> Void)? = nil) {
        self.scenario = scenario
        _viewModel = StateObject(wrappedValue: AddEditReviewViewModel(scenario: scenario, review: review, restaurant: restaurant, onAddCompletion: onAddCompletion))
        
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Rating")) {
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
