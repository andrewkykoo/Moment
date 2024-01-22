//
//  AllMomentsView.swift
//  Moment
//
//  Created by Andrew Koo on 1/17/24.
//

import SwiftUI

struct AllMomentsView: View {
    @ObservedObject var viewModel: MomentsViewModel
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.moments) { moment in
                NavigationLink(destination: MomentDetailView(moment: moment)) {
                    VStack(alignment: .leading) {
                        Text(moment.content)
                            .lineLimit(1)
                        Text("\(moment.dateCreated, formatter: dateFormatter)")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        HStack {
                            Text(moment.momentType.rawValue)
                                .font(.caption)
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchMoments()
            }
            .navigationTitle("All Moments")
        }
    }
}


#Preview {
    AllMomentsView(viewModel: MomentsViewModel())
}
