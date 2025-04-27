# RandomUser App

This iOS application displays a list of random users fetched from [randomuser.me](https://randomuser.me) API.  
It implements key features such as infinite scrolling, user deletion, search functionality, user persistence across sessions, and a detailed user information screen.

---

## Features

- ✅ Fetch a list of random users from API  
- ✅ Remove duplicated users based on UUID  
- ✅ Display user:  
  - Name and Surname  
  - Email  
  - Phone number  
  - Profile picture  
- ✅ Infinite scroll to load more users  
- ✅ Delete a user (permanently removes even after new API fetch)  
- ✅ Search users by name, surname, or email  
- ✅ Detailed user screen including:  
  - Gender  
  - Full Name  
  - Location (Street, City, State)  
  - Registered Date  
  - Email  
  - Profile Picture  
- ✅ Persistence of user list across application launches  
- ✅ Programmatic UI (no Storyboards, no XIBs)  
- ✅ Modular architecture (VIPER)  
- ✅ Smooth animations using Diffable Data Source  
- ✅ Modern list layouts using Compositional Layout  
- ✅ Show alert to user on network/server errors
- ✅ Unit tests for critical parts (Network, List, Search, Delete, Persistence)

---

## Architecture and Design Patterns

The project is built with a modular and scalable architecture inspired by the **VIPER** (View, Interactor, Presenter, Entity, Router) design.

In addition, the UI layer heavily relies on **Diffable Data Source** and **Compositional Layout**.  
- **Diffable Data Source** ensures efficient and smooth updates to lists, preventing duplicated entries and allowing easier snapshot management.  
- **Compositional Layout** offers a flexible, declarative way to design complex collection view layouts that can easily scale as the project grows.

> These modern techniques complement VIPER by keeping the UI layer highly decoupled, performant, and adaptable.

---

## Design Patterns and Techniques Used

| Pattern/Technique               | Usage                                                                 |
|:---------------------------------|:---------------------------------------------------------------------|
| **Builder Pattern**             | `UserListBuilder` and `UserDetailBuilder` create and configure modules. |
| **Delegate Pattern**            | `UserListCellProtocols`, `UserCollectionViewCellDelegate` for cell actions back to presenter. |
| **Diffable Data Source**        | Smooth animated updates, efficient list mutations, and duplicate handling via snapshots. |
| **Compositional Layout**        | Declarative and flexible layout creation for complex lists and detail views. |
| **Dependency Injection**        | `NetworkService` and `UserPersistenceManager` are injected into Interactors. |
| **Swift Collections - OrderedSet** | Used via Swift Package Manager for efficient duplicate removal while preserving order. |
| **SPM Integration**             | [Swift Collections](https://github.com/apple/swift-collections) added for `OrderedSet` usage. |

> ⚡ *Note:* Actor model and factory pattern were evaluated during development but not used in the final version of the project.

---

## How to Run

1. **Clone the repository**  
   ```bash
   git clone https://github.com/emircanuzel/RandomUser.git
   ```
2. **Open in Xcode**  
   ```bash
   open RandomUser/RandomUser.xcodeproj
   ```
3. **Run** (`Cmd + R`)

- **Minimum Deployment Target:** iOS 15.0  
- **Xcode Version:** 15.0+

---

## Testing

- Unit tests are written using **XCTest**.  
- Tested modules:  
  - `NetworkService`  
  - `UserListPresenter`  
  - `UserListCollectionViewManager`  
  - `UserPersistenceManager`
- **Run tests:**  
  - Select **RandomUserTests** scheme.  
  - Press `Cmd + U`.

---

## Libraries and Frameworks

- **UIKit** (Programmatic UI) 
- **XCTest** (for testing)  
- **[Swift Collections](https://github.com/apple/swift-collections)** (OrderedSet)

---

## Project Structure

```
RandomUser/
├── Core/
│   ├── Network/
│   └── UserPersistence/
├── Modules/
│   ├── UserList/
│   └── UserDetail/
├── Resources/
├── RandomUserTests/
```

---

## Notes

- Duplicate users are prevented by checking the unique `uuid` field from the API (`login.uuid`).  
- The list management is powered by **Diffable Data Source**, enabling smooth animations, atomic snapshot updates, and avoiding duplicates naturally.  
- **Compositional Layout** is used for modern, highly customizable and flexible list layouts across both UserList and UserDetail screens.  
- Data persistence across application launches is handled using **UserDefaults** through a custom **UserPersistenceManager**.  
- In case of network or server errors, the app gracefully shows an alert to the user to inform them about the issue.
- No Storyboards were used: the entire UI is built programmatically using **UIKit**.
- Infinite scrolling and loading indicators are designed to provide a seamless and reactive user experience.
- Great attention has been paid to code modularization, clarity, and extendability to real-world scaling.

