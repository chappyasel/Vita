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
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d ''YY, HH:mm:ss"
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            let wordCount = entry.text.components(separatedBy: .whitespacesAndNewlines).count - 1
            LazyVGrid(columns: columns, spacing: 10) {
                EntryInfoItemView(icon: "square.and.pencil",
                                  title: "Created",
                                  metric: dateFormatter.string(from: entry.created))
                EntryInfoItemView(icon: "clock",
                                  title: "Last Edit",
                                  metric: dateFormatter.string(from: entry.lastEdit))
                EntryInfoItemView(icon: "eye",
                                  title: "Last View",
                                  metric: dateFormatter.string(from: entry.lastView))
                EntryInfoItemView(icon: "hourglass",
                                  title: "Duration",
                                  metric: "\(entry.duration) sec")
                EntryInfoItemView(icon: "text.justifyleft",
                                  title: "Word Count",
                                  metric: "\(entry.text.count) chars")
                EntryInfoItemView(icon: "character",
                                  title: "Char Count",
                                  metric: "\(wordCount) words")
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
                .foregroundColor(.init(white: 0.9))
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
                .padding(12)
        }
        .frame(height: 150, alignment: .center)
    }
}

struct EntryInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EntryInfoView(entry: Entry())
            .frame(width: 375, height: 600, alignment: .center)
            .previewLayout(PreviewLayout.sizeThatFits)
    }
}
