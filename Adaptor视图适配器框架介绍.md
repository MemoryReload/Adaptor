# Adaptor视图适配器框架介绍

## What is Adaptor

什么是Adaptor视图适配器框架？视图适配器框架，就是将通常的代理模式设计的、以数据为驱动的视图（UITableView、UICollectionView，理论上包括，但不限于这些）使用适配器模式改写为，通过一个适配器实体类来操作其显示的框架。当我们对相应的视图启用适配器时，我们不再需要实现复杂的代理方法（代理已经在适配器类中进行了相应的代理接口适配实现），而是通过改变适配器的数据的方式，来改变视图的显示效果。

## Why Adaptor

为什么要使用适配器？如果要引入一个东西，我们首先要思考的是，why do so？ 为什么我们要使用它，它是不是让我们更加“慵懒”。如果它不能，我们应当首先考虑不要使用它。因为，如非必要，引入任何一种多余的依赖，都是对代码的投毒。作为程序员，我们应当是“慵懒”的，尽量不要编写重复的代码，保持代码最大程度的重用，尽量保持逻辑的简单与功能的单一性，如果可能的话。所以，经过这些方面的思考，以及参考Android的ListView和RecycleView的设计思想，我觉得采用适配器模式具有以下优点：

### 1.  更高的代码重用性

为什么说Adaptor具有更高的代码重用性？传统的UITableView和UICollectionView采用的代理模式，只规定了抽象的接口，具体的体现就是两套协议，一套ViewDelegate协议用来处理用户交互，以及一套dataSource协议用来为视图提供必需的显示数据驱动。这样的设计，再叠加上MVC的经典设计，一般充当delegate的都是可怜的控制器，那么，每一个包含列表视图的Controller都不得不实现一次这个接口，无一幸免（当然我们此处还没有考虑有多个表视图的情况，会更加复杂）。这从某种意义上来说，是严重违法DRY编程原则的。但是，这样的设计似乎又限制了我们不得不这样做。Adaptor尝试解决这个问题，它的思路是，用一个实体类来接管这部分代理需要提供的功能，由Adaptor来与列表交互，实现逻辑的分离，然后Controller（或者说使用列表视图的环境）通过Adaptor的接口来实现与列表的交互，从而将这部分适配列表视图代理接口的代码实现了重用。



#### 2. 更显著的代码单一性

这个问题是显而易见的，首先使用Adaptor之后，Controller与列表交互的逻辑被有效的从中分离并封装起来，一个适配器实例只为一个表视图服务。当然，对于只有一个列表视图的控制器，表现并不明显，如果一个Controller中有多个表视图，这个问题就显得尤为显著，此时，Controller的代理方法会变得相当难以阅读（如果表视图有较复杂的处理逻辑的话）。但是，如果使用Adaptor，这些代码将被有效的隔离，一个适配器实例只会处理一个列表的数据及交互。然后由Controller与多个适配器进行交互，这样，单个适配器实例的功能将会是单一的。

#### 3. 更加的简单和直观

Adaptor为了实现统一的广泛适配的接口，在通常直接使用控制器数据作为数据源的传统做法上，建立了视图模型SectionViewHolder和CellViewHolder这两个抽象。这两个类提供显示需要的一个二维数组模型，模型记录了每一个列表项（Cell）显示所必需的参数，并且作为其处理事件的中枢，但它并不会记录列表项视图（Cell）(因为列表项视图（Cell）是会回收和重用的，逻辑上也不需要这种耦合)，它只会在Adaptor发来更新消息时使用对应数据对列表项视图（Cell）进行更新，在列表（UITableView、UICollectionView）或者列表项视图（Cell）发来事件时做出相应的响应。这样一来，我们就间接的逃离了Index的地狱，我们在代理实现的方式里最常见的问题是，列表项视图发送一个事件需要处理对应的数据时，我们不得不通过列表查询该项目的索引Inex，然后再通过索引和数据源去查找到对应的数据项目进行操作。这样的代码，在一些index经过了特殊处理的列表中（比如：列表后面有个加号，列表最前端有一个装饰作用的列表项视图（Cell），空列表加占位视图等等），逻辑会变得复杂而容易出错。Adaptor的视图模型杜绝了这种情况，因此也间接的不再需要考虑Index，Adator会处理这一切，并且，相关的事件将交给对应的ViewHolder去处理，你收到的事件，永远是你需要处理的，并且你可以轻而易举的拿到你的数据。这样的设计非常简单和直观，在编写UI代码时，你只需要建立这个视图模型，就可以快速搭建界面。当调试接口时，再添加对应的真实数据与ViewHolder进行绑定，并且完成对应的视图更新方法的实现就可以了。

#### 4. 更少的代码

更少的代码，因为代码得到了重用，最直接的效果就是更少的代码。这是使用Adaptor最简单而有力的理由。

## 框架结构

框架由大量的协议和少数的几个实体类，以及一些辅助实现功能的类扩展构成。

### 协议（Protocols）

##### 1.  适配器接口协议

- AdaptingProtocol   

  规定了视图适配器需要的基础属性。

  ```swift
  public protocol AdaptingProtocol {
      associatedtype V
      associatedtype D
      associatedtype C
      
      /// The view  which adaptor is working for.
      var view: V? { get }
      /// The extra context that adaptor needed to work properly with controllers and so on.
      var context: C { get set }
      /// The display view model that adaptor needed to work with view.
      var dataSource:[D] { get set }
  }
  ```

- TableAdaptingProtocol    

  继承于AdaptingProtocol，并且继承UITableViewDataSource、UITableViewDelegate，用于定义专门服务于TableView的Adaptor的接口。

- CollectionAdaptingProtocol    

  继承于AdaptingProtocol，并且继承UICollectionViewDataSource、UICollectionViewDelegate，用于定义专门服务于UICollectionView的Adaptor的接口。

##### 2.  视图注入接口协议

* AdaptorProtocol   

  用来向表视图注入适配器，并且建立表视图与适配器之间的关联。

  ```swift
  /// The protocol used to inject adaptor to the specified view
  public protocol AdaptorProtocol: AnyObject {
      associatedtype T
      /// The adaptor for the specified view to work with
      var adaptor: T? { get }
      
      /// Connet the adaptor with the specified view
      /// - Parameter adaptor: the adaptor to use
      func useAdaptor(_ adaptor: T?)
  }
  ```

##### 3.  SectionViewHolder相关的协议

* SectionViewHolderBaseProtocol 

  定义了表视图中分区相关的基本属性。

  ```swift
  public protocol SectionViewHolderBaseProtocol {
      associatedtype CellHolderClass
      associatedtype SectionViewClass
      
      
      /// The section header data
      var headerData: Any? { get set }
      
      /// The section header view class
      var headerViewClass: SectionViewClass.Type? { get set }
      
      
      /// The section footer data
      var footerData: Any? { get set }
      
      /// The section footer view class
      var footerViewClass: SectionViewClass.Type? { get set }
      
      /// The cell holders contained in this section
      var cellHolders: [CellHolderClass] { get set }
      
      /// If true, cells in this section will not be displayed. Default is false
      var collapsed: Bool { get set }
      
      /// The displayed cells counts. If not collapsed, should be equal to cellHolders.count. If not, return 0.
      var cellCounts: Int { get }
  }
  ```

* SectionViewHolderEventProtocol

  定义了SectionViewHolder的事件处理接口

  ```swift
  public protocol SectionViewHolderEventProtocol {
      associatedtype SectionViewClass
      associatedtype ContainerClass
      
      /// Called when the specified header view needs to be updated with view holder's headerData
      /// - Parameters:
      ///   - container: The container of the specified header view  (UITableView, UICollection, ect)
      ///   - header: The specified header view
      ///   - section: The index path of specified header view
      func didUpdateWith(container: ContainerClass, header:SectionViewClass, forSection section: Int )
      
      /// Called when the specified header view will be displayed on the container
      /// - Parameters:
      ///   - container: The container of the specified header view (UITableView, UICollection, ect)
      ///   - header: The specified header view
      ///   - section: The index of specified header view
      func willDisplayWith(container: ContainerClass, header:SectionViewClass, forSection section: Int )
      
      /// Called when the specified header view ends displaying on the container
      /// - Parameters:
      ///   - container: The container of the specified header view (UITableView, UICollection, ect)
      ///   - header: The specified header view
      ///   - section: The index of specified header view
      func didEndDisplayWith(container: ContainerClass, header:SectionViewClass, forSection section: Int )
      
      
      /// Called when the specified footer view needs to be updated with view holder's footerData
      /// - Parameters:
      ///   - container: The container of the specified footer view (UITableView, UICollection, ect)
      ///   - footer: The specified footer view
      ///   - section: The index of specified footer view
      func didUpdateWith(container: ContainerClass, footer:SectionViewClass, forSection section: Int)
      
      /// Called when the specified footer view will be displayed on the container
      /// - Parameters:
      ///   - container: The container of the specified footer view (UITableView, UICollection, ect)
      ///   - footer: The specified footer view
      ///   - section: The index of specified footer view
      func willDisplayWith(container: ContainerClass, footer:SectionViewClass, forSection section: Int )
      
      /// Called when the specified footer view ends displaying on the container
      /// - Parameters:
      ///   - container: The container of the specified footer view (UITableView, UICollection, ect)
      ///   - footer: The specified footer view
      ///   - section: The index of specified footer view
      func didEndDisplayWith(container: ContainerClass, footer:SectionViewClass, forSection section: Int )
      
      /// Called when the specified header view emit event
      /// - Parameters:
      ///   - name: The name of the event
      ///   - container: The container of the specified header view  (UITableView, UICollection, ect)
      ///   - cell: The specified header view
      ///   - index: The index path of specified header view
      /// - Note: The event will be handled by adaptor at first. If container handle such event, this
      /// method will not be called. Or, this method should do further processing.
      func handleEvent(withName name: ViewCustomEventName, container: ContainerClass, header:SectionViewClass, forSection section: Int)
      
      /// Called when the specified footer view emit event
      /// - Parameters:
      ///   - name: The name of the event
      ///   - container: The container of the specified footer view  (UITableView, UICollection, ect)
      ///   - cell: The specified footer view
      ///   - index: The index path of specified footer view
      /// - Note: The event will be handled by adaptor at first. If container handle such event, this
      /// method will not be called. Or, this method should do further processing.
      func handleEvent(withName name: ViewCustomEventName, container: ContainerClass, footer:SectionViewClass, forSection section: Int)
  }
  ```

* TableSectionViewHolderEventProtocol

  继承于SectionViewHolderEventProtocol，用于支持针对于UITableView的事件处理接口，暂时没有新增方法，留给以后可能的接口扩展。

* CollectionSectionViewHolderEventProtocol

  继承于SectionViewHolderEventProtocol，用于支持针对于UICollectionView的事件处理接口，暂时没有新增方法，留给以后可能的接口扩展。

##### 4.  CellViewHolder相关的协议

* CellViewHolderBaseProtocol

  定义了表示图中列表项相关的基本属性。

  ```swift
  /// The base protocol for cell view holder
  public protocol CellViewHolderBaseProtocol {
      associatedtype CellClass
      
      /// User data for the specified cell
      var cellData: Any? { get set }
      
      /// Cell class used for displaying the sepcified cell
      var cellClass: CellClass.Type? { get set }
  }
  ```

* CellViewHolderEventProtocol

  定义了CellViewHolder处理事件的接口

  ```swift
  /// The event handling protocol for cell view holder
  public protocol CellViewHolderEventProtocol {
      associatedtype CellClass
      associatedtype ContainerClass
      
      /// Called when the specified cell needs to be updated with view holder's cellData
      /// - Parameters:
      ///   - container: The container of cell (UITableView, UICollection, ect)
      ///   - cell: The specified cell view
      ///   - index: The index path of specified cell view
      func didUpdateWith(container: ContainerClass, cell: CellClass, index:IndexPath)
      
      
      /// Called when the specified cell will be displayed on the container
      /// - Parameters:
      ///   - container: The container of cell (UITableView, UICollection, ect)
      ///   - cell: The specified cell view
      ///   - index: The index path of specified cell view
      func willDisplayWith(container: ContainerClass, cell: CellClass, index:IndexPath)
      
      /// Called when the specified cell ends displaying on the container
      /// - Parameters:
      ///   - container: The container of cell (UITableView, UICollection, ect)
      ///   - cell: The specified cell view
      ///   - index: The index path of specified cell view
      func didEndDisplayWith(container: ContainerClass, cell: CellClass, index:IndexPath)
      
      /// Called when the specified cell will be selected
      /// - Parameters:
      ///   - container:  The container of cell (UITableView, UICollection, ect)
      ///   - cell: The specified cell view
      ///   - index: The index path of specified cell view
      func shouldSelectWith(container: ContainerClass, cell: CellClass, index:IndexPath) -> Bool
      
      /// Called when the specified cell will be deselected
      /// - Parameters:
      ///   - container: The container of cell (UITableView, UICollection, ect)
      ///   - cell: The specified cell view
      ///   - index: The index path of specified cell view
      func shouldDeselectWith(container: ContainerClass, cell: CellClass, index:IndexPath) -> Bool
      
      /// Called when the specified cell emit event
      /// - Parameters:
      ///   - name: The name of the event
      ///   - container: The container of cell (UITableView, UICollection, ect)
      ///   - cell: The specified cell view
      ///   - index: The index path of specified cell view
      /// - Note: The event will be handled by adaptor at first. If container handle such event, this
      /// method will not be called. Or, this method should do further processing.
      func handleEvent(withName name: ViewCustomEventName, container: ContainerClass, cell: CellClass, index:IndexPath)
  }
  ```

* TableCellViewHolderEventProtocol

  继承于CellViewHolderEventProtocol，用于支持针对于UITableView的事件处理接口，暂时没有新增方法，留给以后可能的接口扩展。

* CollectionCellViewHolderEventProtocol

  继承于CellViewHolderEventProtocol，用于支持针对于UICollectionView的事件处理接口，暂时没有新增方法，留给以后可能的接口扩展。

##### 5. 事件处理协议

* CellEventSending

  定义了列表项视图发送事件所需的基本要素（事件接收者、消息接口）

  ```swift
  /// The base cell custom event sending protocol. Any cell classes that prefer to send
  /// custom event should confrim (or maybe implement) this protocol.
  protocol CellEventSending {
      associatedtype A: ViewCustomEventhandling
      associatedtype CellClass
      
      /// The event handler which is honored to handle events emitted by custom cell views (generally speaking,
      /// this should be the adaptor).
      var  cellEventHandler: A? { get set }
      
      /// The event tiger method. A specified cell event will be sent to the handler after calling this method.
      /// - Parameters:
      ///   - name: The specified event name
      ///   - cell: The specified cell which sending the event
      func sendEvent(withName name: ViewCustomEventName, cell: CellClass)
  }
  ```

* SectionViewEventSending

  定义了列表分区视图发送事件所需的基本要素（事件接收者、消息接口）

  ```swift
  /// The base section view custom event sending protocol. Any section view classes that prefer to send
  /// custom event should confrim (or maybe implement) this protocol.
  protocol SectionViewEventSending {
      associatedtype A: ViewCustomEventhandling
      associatedtype SectionViewClass
      
      /// The event handler which is honored to handle events emitted by custom section views (generally
      /// speaking, this should be the adaptor).
      var  sectionEventHandler: A? { get set }
      
      /// The event tiger method. A specified section event will be sent to the handler after calling this
      /// method.
      /// - Parameters:
      ///   - name: The specified event name
      ///   - sectionView: The specified section view which sending the event
      func sendEvent(withName name: ViewCustomEventName, sectionView: SectionViewClass)
  }
  ```

  

* TableSectionViewEventSending

  继承于SectionViewEventSending，用于支持UITableView的分区视图发送事件所需要的一些特殊属性和功能。

  ```swift
  /// The table section view event sending protocol.
  protocol TableSectionViewEventSending: SectionViewEventSending  {
      
      /// The type of the specified section view which sends custom event.
      var type: TableSectionViewType? { get set }
      
      /// the index of the specified section view in the table
      var index: Int? { get set }
  }
  ```

* CollectionReusableViewEventSending

  继承于SectionViewEventSending，用于支持UITableView的分区视图发送事件所需要的一些特殊属性和功能。

  ```swift
  /// The reusable view of collection view event sending protocol.
  protocol CollectionReusableViewEventSending: SectionViewEventSending {
      
      /// The index path of the reusable view which sends custom event.
      var  indexPath: IndexPath? { get set }
      
      /// The supplementary view  kind of the reusable view.
      var  kind: String? { get set }
  }
  ```

* ViewCustomEventhandling

  定义了Adaptor用于处理列表项、列表分区视图自定义事件的接口。

  ```swift
  /// The base view custom event handling protocol. Any object that prefers to handle
  /// view custom event should confirm (or maybe implement) this protocol.
  protocol ViewCustomEventhandling {
      associatedtype CellClass
      associatedtype SectionViewClass
      
      /// Called when the specified cell emits event.
      /// - Parameters:
      ///   - name: The event name
      ///   - cell: The cell which emits such event.
      func handleEvent(withName name: ViewCustomEventName, cell: CellClass)
      
      /// Called when the specified section view emit event.
      /// - Parameters:
      ///   - name: The event name
      ///   - sectionView: The section view which emits such event
      func handleEvent(withName name: ViewCustomEventName, sectionView: SectionViewClass)
  } 
  ```

##### 6. 视图更新协议

* CellUpdateProtocol

  定义了列表项更新数据的接口

  ```swift
  /// The base protocol for cell updating data.
  public protocol CellUpdateProtocol {
      
      /// Called when the cell holder set data for the specified cell view.
      /// - Parameter data: user custom data
      func update(data:Any?)
  }
  ```

* SectionViewUpdateProtocol

  定义了分区视图更新数据的接口

  ```swift
  /// The base protocol for section view updating data.
  public protocol SectionViewUpdateProtocol {
      
      /// Called when the section view holder set data for the specified section view.
      /// - Parameters:
      ///   - data: The user custom data
      ///   - collapsed: The current display status for the specified section ( whether the section is
      ///   collapsed or not now).
      ///   - count: The display count for the specified section.
      /// - Note: The count here will be the actual cell view holders count of this section, even if
      ///   the section is collapsed. You should handle collapsing all by yourself.
      func update(data:Any?, collapsed:Bool, count: Int)
  }
  ```

* TableReuseProtocol

  针对于UITableView列表项和分区视图复用的接口

  ```swift
  /// Table view cell and section reusing protocol.
  protocol TableReuseProtocol {
      associatedtype V
      
      /// Dequeue a cell or section with its identifier from its container.
      /// - Parameters:
      ///   - container: The cell or section container
      ///   - withIdentifier: The reusing identifier of the cell or section
      static func dequeue(from container:UITableView, withIdentifier: String ) -> V?
  }
  ```

* CollectionCellViewReuseProtocol

  针对于UICollectionView列表项视图复用的接口

  ```swift
  /// Collection view cell reusing protocol
  protocol CollectionCellViewReuseProtocol
  {
      /// Deaueue a collection view cell from its container
      /// - Parameters:
      ///   - container: The cell container
      ///   - withIdentifier: The reusing identifier of the cell
      ///   - indexPath: The index path of the cell
      static func dequeue(from container:UICollectionView, withIdentifier: String, indexPath: IndexPath ) -> UICollectionViewCell
  }
  ```

* CollectionReusableViewReuseProtocol

  针对于UICollectionView分区视图，以及装饰视图（SupplementView）复用的接口

  ```swift
  /// Collection view supplementary view (header, footer, etc) reusing protocol.
  protocol CollectionReusableViewReuseProtocol
  {
      /// Dequeue a supplementary view from its container
      /// - Parameters:
      ///   - container: The supplementary view container
      ///   - elementKind: The kind of the supplementary view
      ///   - identifier: The reusing identifier of the supplementary view
      ///   - indexPath: The index path of the supplementary view
      static func dequeue(from container:UICollectionView, ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView
  }
  ```

##### 7. 适配器上下文协议

* AdaptorContextProtocol

  定义了Adaptor与外部环境（例如：Controller、Layout等）的抽象交互接口

  ```swift
  /// The outside context to work with adaptor
  public protocol AdaptorContextProtocol: NSObjectProtocol {
      /// The view controller for the view which use the specified adaptor
      var containerVC: UIViewController? { get }
  }
  ```

* AdaptorContextReusableProtocol

  定义了与Layout交互，提供装饰视图（SupplementaryView）的抽象接口。

  注意：这里用户可以选择继承重写CollectionAdaptor的方式来提供装饰视图。此处的接口是对组合模式实现的一种尝试，请使用者衡量实现的复杂度，决定采用哪种方式来实现。

  ```swift
  /// The outside context to work with customized reusable supplement view of collection view
  public protocol AdaptorContextReusableProtocol: AdaptorContextProtocol {
      
      /// Return the specified kind of customized supplement view for the adaptor
      /// - Parameters:
      ///   - collectionView: Collection view to cooperate with the adaptor
      ///   - kind: The kind of customized supplement view
      ///   - indexPath: The index path of customized supplement view
      func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
      
      
      /// Called when the specified kind of customized supplement view will be displayed by the collection view
      /// - Parameters:
      ///   - collectionView: Collection view to cooperate with the adaptor
      ///   - view: The specified kind of customized supplement view
      ///   - elementKind: The kind of customized supplement view
      ///   - indexPath: The index path of customized supplement view
      func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath)
      
      
      /// Called when the specified kind of customized supplement view ends displaying on the collection view
      /// - Parameters:
      ///   - collectionView: Collection view to cooperate with the adaptor
      ///   - view: The specified kind of customized supplement view
      ///   - elementKind: The kind of customized supplement view
      ///   - indexPath: The index path of customized supplement view
      func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath)
      
      
      /// Called when the specified kind of customized supplement view emit event
      /// - Parameters:
      ///   - name: The event name
      ///   - collectionView: Collection view to cooperate with the adaptor
      ///   - kind: The kind of customized supplement view
      ///   - indexPath: The index path of customized supplement view
      func collectionViewHandleEvent(withName name: ViewCustomEventName, _ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath)
  }
  ```

### 实体类（Classes）

##### 1. 适配器（Adaptor）

核心类，处理表视图的几乎所有逻辑，提供数据源及事件处理。

* TableAdaptor

  实现TableAdaptingProtocol的协议接口，与UITableView协作。代码量过大不再列出，请参阅源代码。

* CollectionAdaptor

  实现CollectionAdaptingProtocol的协议接口，与UICollectionView协作。代码量过大不再列出，请参阅源代码。

  注意：CollectionAdaptor只接管数据和事件逻辑，布局及显示尺寸的提供，仍然由系统框架的Layout抽象层来控制。

##### 2. 一维显示数据模型——列表项（CellHolder）

* TableCellViewHolder

  实现CellViewHolderBaseProtocol与TableCellViewHolderEventProtocol协议，与TableAdaptor协作，提供列表项视图所需的数据和更新操作，处理列表项相关的事件。代码量过大不再列出，请参阅源代码。

* CollectionCellViewHolder

  实现CellViewHolderBaseProtocol与CollectionCellViewHolderEventProtocol协议，与CollectionAdaptor协作，提供列表项视图所需的数据和更新操作，处理列表项相关的事件。代码量过大不再列出，请参阅源代码。

##### 3. 二维显示数据模型——分区（Section Holder）

* TableSectionViewHolder

  实现SectionViewHolderBaseProtocol与TableSectionViewHolderEventProtocol协议，与TableAdaptor协作，提供分区视图所需的数据和更新操作，处理分区相关的事件。代码量过大不再列出，请参阅源代码。

* CollectionSectionViewHolder

  实现SectionViewHolderBaseProtocol与CollectionSectionViewHolderEventProtocol协议,与CollectionAdaptor协作，提供分区视图所需的数据和更新操作，处理分区视图相关的事件。代码量过大不再列出，请参阅源代码。

### 类图（Class Diagram）

##### 1. 数据源

![数据源](https://i.loli.net/2021/08/23/jCysBYgqRKFJmEU.png)

##### 2. 事件分发

![事件分发](https://i.loli.net/2021/08/23/kS8cDjfRFPM2yEI.png)

##### 3. 事件处理

![事件处理](https://i.loli.net/2021/08/23/LmAnX9hJtSZqgpN.png)

## 思考与拓展

1. 是否需要封装数据的操作到Adaptor，不再将dataSource属性及table的reload刷新操作暴露给外界? 这样做的话Adaptor的封装性会更好，但Adaptor的接口会变得相对复杂，需要大量的操作分区和分区数据的方法。并且，如果封装table刷新的逻辑，在一些场景下可能操作不够灵活，比如动画等。
2. 因为创建了显示模型，从而避免index的使用。但是，同时出现的问题是：通过cell到用户数据，用户数据到cell的查找对应关系变得复杂，考虑是否由Adaptor封装这些查找映射逻辑，弊端是会使Adaptor的接口变得复杂。
