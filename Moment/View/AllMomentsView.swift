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
        List(viewModel.moments) { moment in
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
            .onTapGesture {
                // navigate to SingleMomentView
            }
        }
        .onAppear {
            viewModel.fetchMoments()
        }
    }
}

#Preview {
    AllMomentsView(viewModel: MomentsViewModel())
}
