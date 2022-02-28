# testmo_coderpush

A new Flutter project.

Run app: `flutter run` by default.

## Architecture
```
|---------------  Layers  --------------|  
| Presentations | Business Logic | Data |  
|:-------------------------------------:|  
  
|--------------------------  Actual  ---------------------------|  
| Presentations  |      Business Logic    |         Data        |  
|:-------------------------------------------------------------:|  
| View <--> Bloc <--> Interactor <--> Repository <--> Remote/Local |  
|:-------------------------------------------------------------:|  
|:----  Extension Entity   ----|----    Basic Entity   --------:|  
|:-------------------------------------------------------------:|  
```

### Bloc
- It's the main stateful layer that keep all app's state and data.
- Data must keep in State class, not in bloc itself
- Bloc can handle all UI's business, such as proceed an user's action, control loading flow, change theme or update new language,
  ... All UIs that need update by state, it's responsible of Bloc
- Bloc is managed through by EventBus, control constructor and dispose, communicate between blocs by add event or listen state changes,
  and even for broadcast on global channel but doesn't need apply for that project.
- The naming convention to define Event and State class can reference bloc documents website
- State class must be extended by Equatable, but Event class.
- BaseBloc is advanced class of Bloc to handle some generic business such as show/hide app loading (locked loading), handle callApi with common error handling.
- Bloc key is required for all blocs, use constants to define key.
- Bloc can reference to multiple services to handle business, but less is better.

### Interactor
- It's the main layer to handle all data business
- It's a stateless layer, so it will be constructed on demand
- A interactor may contain many usecases that belong to a same module or epic
- A interactor can communicate with other services
- All interactors must be defined with an interface (abstract class), bloc communicate with interactor through by the interface

### Repository
- The main data source of app that is used by interactor layer
- It's a stateless layer, so it will be constructed on demand
- It contains a little bit business rules to branch data source that should be used, from remote or local datasource
- It also handle the caching logic rules, from memory or local storage
- All repositories must be defined with an interface (abstract class), interactor communicate with repository through by the interface

### Datasource (Remote/Local)
- It's data source layer, remote datasource means data is from Restful/GraphQL API and local datasource means data is from local storage
- Base remote datasource is advanced class to handle all generic calling API, retry when access token is expired
  and need to refresh, also for general API error handling, or etc...
- All Remote & Local must be defined with an interface (abstract class), repository communicate with datasource through by the interface

### Model
- It covers all entities in app
- Have 2 kind of models, basic entity and extension entity.
- Basic entity is belong to repository, it defines all entity's properties and support basic parsing with json
- Extension entity is belong to UI layer, it defines all utility methods of an entity
- All entity must extended by Equatable that useful in smart comparison

## Dependencies Injection
- There are 3 kinds of class to support construct instance for DI, EventBus, Provider and Repository
- EventBus is a singleton class that not only work as a bloc manager but also support to provider bloc instance.
  All constructor of bloc should be a static function inside Bloc class for easy to maintain.
- Provider is a singleton class that provide the instance of interactor.
- Repository is a singleton class that provide the instance of repository, remote/local datasource
