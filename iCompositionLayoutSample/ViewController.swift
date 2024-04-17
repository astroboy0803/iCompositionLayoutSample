/// <#Brief Description#> 
///
/// Created by TWINB00776283 on 2024/4/16.
/// Copyright © 2024 Cathay United Bank. All rights reserved.

import UIKit

class ViewController: UIViewController {
    
    private let collectionView: UICollectionView
    
    private let dataSource: UICollectionViewDiffableDataSource<Section, Item>
    
    private var items: [Item]

    init() {
        items = Item.allCases
        self.collectionView = .init(frame: .zero, collectionViewLayout: Self.layout())
        self.dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath)
            if let colorCell = cell as? ColorCell {
                colorCell.setup(color: item.color)
            }
            return cell
        }
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemYellow
        collectionView.backgroundColor = .white
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        snapshot()
    }
    
    private func snapshot(animating: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.only])
        snapshot.appendItems(items, toSection: .only)
        dataSource.apply(snapshot, animatingDifferences: animating)
    }
}

extension ViewController {
    static func layout() -> UICollectionViewCompositionalLayout {
        // 每個 group 最終呈現的數量是依據 size 來決定
        // 只要 size 還放得下就會一直放
        // 反之, size 放不下就會往下一個 group 前進, 無論是否滿足設定的 items 數量, ex: 將 item2 的 height 改為 1/2
        
        // width = 0.5 * 2(group's width)
        // height = 1 * 1.35(group's width)
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        
        // width = 1 * 1(subgroup's width)
        // height = 1/3 * 1.35(subgroup's height)
        let item2 = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/5)))
        
        // width = 0.5 * 2(group's width)
        // height = 1 * 1.35(group's width)
        let subGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)), subitems: .init(repeating: item2, count: 3))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(2), heightDimension: .fractionalHeight(1.35)), subitems: [item, subGroup])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return UICollectionViewCompositionalLayout(section: section)
    }
}

enum Section {
    case only
}

enum Item: CaseIterable {
    case red
    case orange
    case green
    case blue
    case yellow
    case gray
    case pink
    case purple
    
    var color: UIColor {
        switch self {
        case .red:
            .systemRed
        case .orange:
            .systemOrange
        case .green:
            .systemGreen
        case .blue:
            .systemBlue
        case .yellow:
            .systemYellow
        case .gray:
            .systemGray
        case .pink:
            .systemPink
        case .purple:
            .systemPurple
        }
    }
}

class ColorCell: UICollectionViewCell {
    
    private let colorView: UIView
    
    override init(frame: CGRect) {
        colorView = .init()
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(color: UIColor) {
        colorView.backgroundColor = color
    }
}

extension UICollectionReusableView {
    public static var identifier: String {
        .init(describing: Self.self)
    }
}
