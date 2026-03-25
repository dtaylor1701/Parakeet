# PRODUCT.md

## Product Vision
**Parakeet** aims to be the standard lightweight framework for Swift developers to encapsulate business logic into reusable, testable, and decoupled units. By transforming "Actions" into first-class citizens, Parakeet empowers engineers to build highly maintainable applications where the "what" (business logic) is strictly separated from the "how" (execution environment and dependency management).

### Core Objectives
- **Decoupling at Scale**: Provide a robust pattern for separating business rules from UI frameworks (SwiftUI/UIKit) and architectural layers (MVVM/TCA).
- **Boilerplate Elimination**: Leverage Swift Macros to make high-quality architectural patterns feel "native" and effortless to implement.
- **Predictable Error Handling**: Centralize error management to ensure consistent user experiences and simplified debugging.
- **Testability by Default**: Force a structure where dependencies are injected via a "Context," making unit testing business logic trivial without complex mocking sub-systems.

---

## Target Audience & User Personas
Parakeet is designed for Swift developers across iOS, macOS, tvOS, watchOS, and Swift on Server.

### 1. The Architecture Enthusiast
*   **Persona**: A Senior Engineer who values Clean Architecture but is frustrated by the boilerplate required to implement it in Swift.
*   **Goal**: Find a library that enforces "Separation of Concerns" without making the codebase feel heavy or over-engineered.

### 2. The Scalable Team
*   **Persona**: A lead developer on a team of 10+ engineers working on a complex enterprise app.
*   **Goal**: Standardize how business logic is written so that any team member can understand a feature's flow by looking at its "Actions."

### 3. The Test-Driven Developer
*   **Persona**: An engineer who prioritizes 90%+ code coverage.
*   **Goal**: Quickly write unit tests for complex logic without setting up elaborate dependency injection containers.

---

## Feature Roadmap

### Short-Term (0-6 Months)
- **Macro Stability**: Finalize the `@Action` macro to support all edge cases of Swift 5.9+.
- **Enhanced Documentation**: Create a "Cookbook" of common patterns (e.g., Auth flows, Networking, Local DB transactions).
- **Sample Application**: Release a comprehensive "Real World" app (e.g., a Task Manager) demonstrating Parakeet in a SwiftUI/MVVM context.

### Medium-Term (6-12 Months)
- **SwiftUI Integration**: Add property wrappers (e.g., `@ActionRunner`) to trigger actions directly from SwiftUI views with environment-based context injection.
- **Middleware Support**: Allow developers to "hook" into the action lifecycle for logging, analytics, and performance monitoring.
- **Combine/Observation Support**: Deepen integration with Swift's `Observation` framework for reactive state updates post-action.

### Long-Term (12+ Months)
- **Visual Debugger**: A developer tool to visualize the flow of actions and their contexts in real-time during debugging.
- **Plugin System**: A marketplace/ecosystem of pre-built Actions (e.g., `ParakeetNetworkAction`, `ParakeetPersistenceAction`).
- **Swift on Server Optimization**: Specialized contexts for Vapor or Hummingbird to handle request-scoped dependencies.

---

## Feature Prioritization
We prioritize features based on the **DX (Developer Experience) / Value** ratio:
1.  **Core Protocols (`Actionable`)**: High Priority. The foundation of the library.
2.  **Swift Macros**: High Priority. This is our "unfair advantage" that reduces the friction of adopting a formal pattern.
3.  **Error Handling**: Medium Priority. Crucial for production apps but can be implemented incrementally.
4.  **Visual Tools**: Low Priority. Useful for maturity but not required for core utility.

---

## Iteration Strategy
Our development is shaped by **Empirical Dogfooding**:
- **Community Feedback**: We monitor GitHub Issues and Swift Forums to see where users struggle with the "Context" concept.
- **Experimental Macros**: We iterate on macro syntax based on what feels most "Swift-native."
- **Performance Benchmarking**: Ensuring that the macro expansion and context injection add negligible overhead to the binary size and runtime.

---

## Release Strategy & User Onboarding
### Release Strategy
- **Semantic Versioning**: Strict adherence to SemVer to ensure library stability for enterprise users.
- **Release Channels**: 
    - `main`: Stable releases.
    - `develop`: Bleeding edge features for early adopters.

### Onboarding Goals
- **The "5-Minute Win"**: A user should be able to install the SPM package and write their first `@Action` in under five minutes using the README.
- **Interactive Tutorials**: Provide a playground within the repository to let users "feel" the workflow without creating a new project.

---

## Success Metrics (KPIs)
- **Adoption Rate**: Number of active projects using the Parakeet SPM dependency.
- **Code Reduction**: Average reduction in boilerplate lines of code (LOC) when migrating from standard MVVM to Parakeet Actions.
- **Community Contributions**: Number of external PRs for new action patterns or macro improvements.
- **NPS (Developer Satisfaction)**: Qualitative feedback from the Swift community regarding ease of testing.

---

## Future Opportunities
- **Cross-Platform Parity**: Ensuring Parakeet works seamlessly in non-Apple environments (Linux/Windows) for server-side Swift.
- **AI-Assisted Action Generation**: Providing prompts/templates for LLMs to generate Parakeet Actions based on business requirements.
- **State Machine Integration**: Using Actions as the primary transition mechanism in formal State Machine architectures.
