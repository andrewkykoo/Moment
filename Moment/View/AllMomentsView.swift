//
//  AllMomentsView.swift
//  Moment
//
//  Created by Andrew Koo on 1/17/24.
//

import SwiftUI

struct AllMomentsView: View {
    @ObservedObject var viewModel: MomentsViewModel
    
    var body: some View {
        List(viewModel.moments) { moment in
            Text(moment.content)
        }
        .onAppear {
            viewModel.fetchMoments()
        }
    }
}

#Preview {
    AllMomentsView(viewModel: MomentsViewModel())
}
