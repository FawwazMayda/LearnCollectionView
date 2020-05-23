/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.


import UIKit

final class TutorialDetailViewController: UIViewController {
  
  private let tutorial: Tutorial
  static let identifier = "TutorialDetailViewController"
    var dataSource : UICollectionViewDiffableDataSource<Section,Video>!
  @IBOutlet weak var tutorialCoverImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var publishDateLabel: UILabel!
  @IBOutlet weak var queueButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    init?(coder : NSCoder, tutorial: Tutorial) {
        self.tutorial = tutorial
        super.init(coder: coder)
    }
  
  lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  private func setupView() {
    self.title = tutorial.title
    tutorialCoverImageView.image = tutorial.image
    tutorialCoverImageView.backgroundColor = tutorial.imageBackgroundColor
    titleLabel.text = tutorial.title
    publishDateLabel.text = tutorial.formattedDate(using: dateFormatter)
    
    let buttonTitle = tutorial.isQueued ? "Remove from queue" : "Add to queue"
    queueButton.setTitle(buttonTitle, for: .normal)
    collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
    collectionView.collectionViewLayout = configureLayout()
    configureData()
    configureSnapshot()
  }
  
  @IBAction func toggleQueued() {
    self.tutorial.isQueued.toggle()
    UIView.performWithoutAnimation {
      if tutorial.isQueued {
        queueButton.setTitle("Remove from queue", for: .normal)
      } else {
        queueButton.setTitle("Add to queue", for: .normal)
      }
      
      self.queueButton.layoutIfNeeded()
    }
  }
}

extension TutorialDetailViewController {
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
              
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .absolute(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
          }
          
          let configuration = UICollectionViewCompositionalLayoutConfiguration()
                  
          return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: configuration)
        }
    
    func configureData() {
           dataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, video) -> UICollectionViewCell? in
               guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseIdentifier, for: indexPath) as? ContentCell else { fatalError("Cell error")}
               cell.textLabel.text = video.title
               return cell
           })
           
           dataSource.supplementaryViewProvider = {(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
               guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: indexPath) as? TitleSupplementaryView else { fatalError("No title View") }
               cell.textLabel.text = self.tutorial.content[indexPath.section].title
               return cell
               
           }
       }
       
       func configureSnapshot() {
           var initialSnapshot = NSDiffableDataSourceSnapshot<Section,Video>()
           tutorial.content.forEach { (section) in
               initialSnapshot.appendSections([section])
               initialSnapshot.appendItems(section.videos)
           }
           dataSource.apply(initialSnapshot)
       }
    }
   

