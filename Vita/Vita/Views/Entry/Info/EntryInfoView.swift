//
//  EntryInfoView.swift
//  Vita
//
//  Created by Chappy Asel on 8/7/21.
//

import SwiftUI

struct EntryInfoView: View {
    var entry: Entry
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                EntryInfoItemView(icon: "square.and.pencil",
                                  title: "Created",
                                  metric: StringFormatter.string(for: entry.created,
                                                                 format: .full)
                                    .replacingOccurrences(of: ", ", with: "\n"))
                EntryInfoItemView(icon: "clock",
                                  title: "Last Edit",
                                  metric: StringFormatter.string(for: entry.lastEdit,
                                                                 format: .full)
                                    .replacingOccurrences(of: ", ", with: "\n"))
                EntryInfoItemView(icon: "eye",
                                  title: "Last View",
                                  metric: StringFormatter.string(for: entry.lastView,
                                                                 format: .full)
                                    .replacingOccurrences(of: ", ", with: "\n"))
                EntryInfoItemView(icon: "hourglass",
                                  title: "Duration",
                                  metric: StringFormatter.string(forDuration: entry.duration))
                EntryInfoItemView(icon: "text.justifyleft",
                                  title: "Word Count",
                                  metric: "\(entry.wordCount) words")
                EntryInfoItemView(icon: "character",
                                  title: "Char Count",
                                  metric: "\(entry.charCount) chars")
            }
                .padding(20)
        }
    }
}

struct EntryInfoItemView: View {
    var icon: String
    var title: String
    var metric: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(.gray)
            VStack{
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Text(title.uppercased())
                    .font(.system(size: 15, weight: .bold))
                    .padding(1)
                Text(metric)
                    .font(.system(size: 17, weight: .medium))
                    .multilineTextAlignment(.center)
            }
                .padding(10)
        }
        .frame(height: 140, alignment: .center)
    }
}

struct EntryInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EntryInfoView(entry: Entry())
            .frame(width: 375, height: 600, alignment: .center)
            .previewLayout(PreviewLayout.sizeThatFits)
            .colorScheme(.light)
        EntryInfoView(entry: Entry())
            .frame(width: 375, height: 600, alignment: .center)
            .previewLayout(PreviewLayout.sizeThatFits)
            .colorScheme(.dark)
    }
}
