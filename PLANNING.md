# trAInor - Personal Training App Planning

## Project Overview
**trAInor** is a free, mobile-first web application focused on calisthenics and bodyweight exercises. It serves as a free alternative to paid apps like BetterMe, providing users with customizable workout programs based on natural exercises.

## Core Vision
- **Mission**: Democratize access to quality fitness training through bodyweight exercises
- **Target Audience**: Fitness enthusiasts of all levels seeking calisthenics training
- **Value Proposition**: Free, customizable, offline-capable training with AI-enhanced exercise demonstrations

## Technical Architecture

### Platform Strategy
- **Primary**: Progressive Web App (PWA) optimized for mobile devices
- **Technology Stack**: 
  - Frontend: SvelteKit + TypeScript + Vite + PWA Plugin
  - UI Framework: TailwindCSS for rapid styling
  - State Management: Svelte stores + LocalForage for offline persistence
  - Backend: Supabase (Postgres + Auth + Real-time + Storage)
  - Animations: Lottie files for AI-generated exercise demonstrations
  - Offline: Vite PWA Plugin + LocalForage for comprehensive offline support

### Architecture Decision Rationale

#### Frontend Framework: SvelteKit
- **Bundle Size**: Svelte compiles to minimal JavaScript, crucial for mobile performance
- **Performance**: No virtual DOM overhead, faster runtime performance
- **Developer Experience**: Excellent TypeScript support and modern development features
- **PWA Support**: Excellent integration with Vite PWA plugin

#### Backend: Supabase
- **Rapid Development**: Built-in authentication, real-time subscriptions, and REST/GraphQL APIs
- **Offline-First**: Excellent client libraries with built-in caching and sync
- **Scalability**: Enterprise-grade PostgreSQL with row-level security
- **Cost**: Generous free tier, predictable pricing for scaling

#### Offline Strategy: LocalForage + Event Sourcing
- **Multi-Driver Support**: Automatic fallback from IndexedDB → WebSQL → localStorage
- **Event Sourcing**: Track user actions as events for robust sync resolution
- **Conflict Resolution**: Last-write-wins with user preference for conflicts

### Key Features

#### 1. User Management
- User account creation and authentication via Supabase Auth
- Social login support (Google, GitHub, etc.)
- Secure session management with JWT tokens
- Cloud-based data synchronization with offline-first architecture

#### 2. Workout Programs
- **Pre-designed Programs**: Curated workout routines based on freely available training instructions
- **Customization Engine**: Users can modify existing programs to suit their needs
- **Progressive Difficulty**: Beginner, intermediate, and advanced levels
- **Exercise Library**: Comprehensive database of bodyweight exercises with metadata
- **Smart Recommendations**: AI-powered exercise suggestions based on user preferences

#### 3. Exercise Demonstrations
- **Lottie Animations**: Lightweight, scalable AI-generated exercise demonstrations
- **Progressive Loading**: Critical animations cached offline, optional ones loaded on-demand
- **Visual Learning**: Clear, step-by-step movement illustrations
- **Accessibility**: Text descriptions and voice guidance for inclusive experience

#### 4. Offline Functionality
- Complete offline operation once initial content is downloaded
- LocalForage-based storage with automatic driver selection
- Background sync with conflict resolution
- Progressive enhancement for online features

#### 5. Multi-Level Programming
- **Adaptive Difficulty**: Programs that scale with user progress
- **Exercise Variations**: Multiple difficulty levels for each exercise type
- **Progression Tracking**: Monitor advancement through exercise variations
- **Personalization**: Tailored recommendations based on current fitness level

#### 6. Performance Optimization
- **Bundle Splitting**: Code splitting for optimal loading performance
- **Image Optimization**: WebP images with fallbacks for broader compatibility
- **Caching Strategy**: Aggressive caching for exercise content and user data
- **Service Worker**: Advanced caching and background sync capabilities

## Content Strategy

### Exercise Database
- Source: Freely available training instructions from reputable fitness resources
- Categories: Push exercises, pull exercises, core, legs, full-body
- Exercise Variations: Multiple difficulty levels for each exercise type
- Proper Attribution: Credit sources appropriately while ensuring legal compliance

### Program Design
- **Structured Routines**: Daily, weekly, and monthly program layouts
- **Goal-Oriented**: Programs targeting specific fitness objectives
- **Time-Flexible**: Routines ranging from 15 minutes to full hour sessions
- **Equipment-Free**: 100% bodyweight, no external equipment required

## Technical Considerations

### Development Toolchain
- **Build Tool**: Vite for fast development and optimized production builds
- **TypeScript**: Full type safety across the application
- **Testing**: Vitest for unit testing, Playwright for E2E testing
- **Code Quality**: ESLint + Prettier for consistent code standards
- **Git Hooks**: Husky for pre-commit quality checks

### Data Architecture
- **Database Schema**: PostgreSQL with Supabase's built-in auth and RLS
- **Real-time Updates**: Supabase real-time for live data synchronization
- **Event Sourcing**: Track user actions as events for robust offline sync
- **Caching Strategy**: Multi-layer caching (browser cache, service worker, LocalForage)

### Security
- **Authentication**: Supabase Auth with JWT tokens and refresh tokens
- **Row-Level Security**: PostgreSQL RLS for data access control
- **Data Validation**: Zod schemas for runtime type validation
- **Content Security**: CSP headers and secure communication protocols

### Performance
- **Bundle Size**: Target < 100KB initial bundle for fast loading
- **Animation Performance**: GPU-accelerated Lottie animations
- **Lazy Loading**: Route-based code splitting and component lazy loading
- **Offline Performance**: IndexedDB for large datasets, localStorage for settings

### User Experience
- **Progressive Enhancement**: Core functionality works without JavaScript
- **Responsive Design**: Mobile-first design with desktop enhancements
- **Accessibility**: WCAG 2.1 AA compliance with screen reader support
- **Loading States**: Skeleton screens and progressive loading indicators

### Scalability
- **Horizontal Scaling**: Supabase handles database scaling automatically
- **CDN Strategy**: Static assets served via global CDN
- **Edge Functions**: Supabase Edge Functions for server-side logic
- **Monitoring**: Built-in analytics and performance monitoring

## Development Phases

### Phase 1: Core Foundation
- Basic user authentication
- Exercise database setup
- Simple workout program structure
- Basic AI animation framework

### Phase 2: Enhanced Functionality
- Program customization features
- Offline synchronization
- Progressive difficulty system
- Improved AI animations

### Phase 3: Polish & Optimization
- Performance optimization
- Advanced customization options
- Enhanced user interface
- Comprehensive testing

## Success Metrics
- User engagement and retention
- Workout completion rates
- User satisfaction with exercise demonstrations
- Offline functionality adoption
- Community feedback and feature requests

## Legal & Ethical Considerations
- Proper attribution of sourced exercise instructions
- User data privacy and security
- Accessibility compliance
- Content accuracy and safety guidelines

## Future Expansion Opportunities
- Native mobile app versions
- Community features (future consideration)
- Advanced progress tracking (future consideration)
- Premium content options (not planned for initial release)
