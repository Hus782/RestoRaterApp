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
        _viewModel = StateObject(wrappedValue: AddEditReviewViewModel(scenario: scenario, dataManager: CoreDataManager<Review>(), review: review, restaurant: restaurant, onAddCompletion: onAddCompletion))
        
    }
    
    var body: some View {
            NavigationStack {
                Form {
                    Section(header: Text(Lingo.addEditReviewRating)) {
                        RatingPickerView(rating: $viewModel.rating)
                            .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text(Lingo.addEditReviewComment)) {
                        TextEditor(text: $viewModel.comment)
                            .font(.body)
                            .frame(minHeight: 100)
                    }
                    
                    Section(header: Text(Lingo.addEditReviewDateOfVisit)) {
                        DatePicker(Lingo.addEditReviewDateOfVisit, selection: $viewModel.visitDate, displayedComponents: .date)
                    }
                    
                    Section {
                        LoadingButton(isLoading: $viewModel.isLoading, title: Lingo.addEditReviewSubmitButton) {
                            await handleSave()
                        }
                    }
                }
                .navigationBarTitle(scenario == .add ? Lingo.addEditReviewNavigationTitleAdd : Lingo.addEditReviewNavigationTitleEdit, displayMode: .inline)
            }
        }
    
    private func handleSave() async {
        viewModel.isLoading = true
        switch scenario {
        case .add:
            await viewModel.addReview()
        case .edit:
            await viewModel.editReview()
        }
        viewModel.isLoading = false
        presentationMode.wrappedValue.dismiss() // Dismiss the modal view after saving
    }
}
