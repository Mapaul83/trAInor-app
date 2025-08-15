# trAInor - Personal Training App

## Vision Statement
trAInor is a free, offline-first Progressive Web Application (PWA) designed to democratize fitness training through bodyweight exercises and calisthenics. We aim to provide a comprehensive, accessible alternative to paid fitness apps while maintaining the highest standards of user experience and functionality.

## Technical Architecture

### Frontend Stack
- **Framework**: SvelteKit with TypeScript
  - Chosen for minimal bundle size (smallest among React/Vue/Svelte)
  - Excellent developer experience with built-in TypeScript support
  - Server-side rendering capabilities for better SEO
  - File-based routing system

- **Progressive Web App**: Vite PWA Plugin with Workbox
  - Offline-first architecture
  - Service worker for background sync and caching
  - App shell pattern for instant loading
  - Web app manifest for native-like experience

- **Styling**: TailwindCSS
  - Utility-first CSS framework
  - Custom design system with trAInor color palette
  - Responsive design out of the box
  - Component-based custom classes

### Backend & Data Layer
- **Backend-as-a-Service**: Supabase
  - PostgreSQL database with real-time subscriptions
  - Built-in authentication with multiple providers
  - Row Level Security (RLS) for data protection
  - Edge Functions for serverless logic
  - File storage for exercise media

- **Offline Storage**: LocalForage
  - Automatic driver selection (IndexedDB → WebSQL → localStorage)
  - Promise-based API for async operations
  - Seamless online/offline data synchronization
  - Local caching of user data and exercise content

### Media & Animations
- **Exercise Demonstrations**: Lottie Web
  - Vector-based animations for small file sizes
  - AI-generated exercise demonstrations
  - Smooth, responsive animations
  - Cross-platform compatibility

### Development Tools
- **Testing**: Vitest + Playwright
  - Unit testing with Vitest (Vite-native)
  - End-to-end testing with Playwright
  - Component testing capabilities

- **Code Quality**: ESLint + Prettier + Husky
  - Consistent code formatting
  - Pre-commit hooks for quality assurance
  - TypeScript-aware linting rules

## Core Features

### 1. Exercise Library
- Comprehensive database of bodyweight exercises
- Categorized by muscle groups and difficulty levels
- Animated demonstrations for proper form
- Progression tracking and variations
- Search and filter functionality

### 2. Workout Programs
- Pre-built calisthenics routines
- Customizable workout creation
- Progressive difficulty scaling
- Time-based and rep-based workouts
- Rest day and active recovery integration

### 3. Progress Tracking
- Personal records and achievements
- Body weight and measurements logging
- Photo progress documentation
- Performance analytics and insights
- Goal setting and milestone tracking

### 4. Offline-First Experience
- Full functionality without internet connection
- Background synchronization when online
- Cached exercise content and user data
- Progressive enhancement approach

### 5. Personalization
- Adaptive workout recommendations
- User preferences and settings
- Custom exercise scheduling
- Notification system for reminders

## User Experience Design

### Design Principles
1. **Simplicity**: Clean, intuitive interface
2. **Accessibility**: WCAG 2.1 AA compliance
3. **Performance**: Fast loading and smooth interactions
4. **Consistency**: Unified design language throughout
5. **Responsiveness**: Optimal experience across all devices

### Color Palette
- **Primary Blue**: #3b82f6 (Motivation and trust)
- **Secondary Green**: #10b981 (Success and progress)
- **Accent Orange**: #f59e0b (Energy and enthusiasm)
- **Neutral Grays**: #f9fafb to #111827 (Content hierarchy)

### Typography
- **Font Family**: Inter (clean, readable, web-optimized)
- **Scale**: Modular scale for consistent hierarchy
- **Weights**: 400 (regular), 500 (medium), 600 (semibold), 700 (bold)

## Data Architecture

### Database Schema (Supabase/PostgreSQL)

#### Users Table
```sql
users (
  id: uuid PRIMARY KEY,
  email: text UNIQUE,
  username: text UNIQUE,
  created_at: timestamp,
  updated_at: timestamp,
  profile: jsonb
)
```

#### Exercises Table
```sql
exercises (
  id: uuid PRIMARY KEY,
  name: text NOT NULL,
  category: text NOT NULL,
  difficulty: integer,
  muscle_groups: text[],
  equipment: text[],
  instructions: text,
  animation_url: text,
  created_at: timestamp
)
```

#### Workouts Table
```sql
workouts (
  id: uuid PRIMARY KEY,
  user_id: uuid REFERENCES users(id),
  name: text NOT NULL,
  exercises: jsonb,
  duration: interval,
  difficulty: integer,
  created_at: timestamp
)
```

#### Progress Table
```sql
progress (
  id: uuid PRIMARY KEY,
  user_id: uuid REFERENCES users(id),
  exercise_id: uuid REFERENCES exercises(id),
  reps: integer,
  sets: integer,
  duration: interval,
  weight: numeric,
  recorded_at: timestamp
)
```

### Data Synchronization Strategy

1. **Offline-First Approach**
   - All user data stored locally using LocalForage
   - Background sync when connection available
   - Conflict resolution with last-write-wins strategy

2. **Caching Strategy**
   - Exercise content cached indefinitely (rarely changes)
   - User data cached with TTL and version checking
   - Progressive loading of exercise animations

3. **Real-time Updates**
   - Supabase real-time subscriptions for live data
   - WebSocket connections for instant synchronization
   - Optimistic UI updates for better UX

## Security & Privacy

### Authentication
- Email/password authentication via Supabase Auth
- OAuth integration (Google, Apple, GitHub)
- JWT-based session management
- Secure password reset flow

### Data Protection
- Row Level Security (RLS) policies
- Encrypted data transmission (HTTPS/WSS)
- Local data encryption for sensitive information
- GDPR compliance for EU users

### Privacy Considerations
- Minimal data collection principle
- User consent for analytics
- Data export functionality
- Account deletion with complete data removal

## Performance Strategy

### Bundle Optimization
- Code splitting by routes and features
- Tree shaking for unused code elimination
- Dynamic imports for lazy loading
- Asset optimization (images, animations)

### Caching Strategy
- Service worker for app shell caching
- CDN for static assets
- Browser caching with appropriate headers
- LocalStorage for user preferences

### Loading Performance
- Critical CSS inlining
- Font optimization and preloading
- Image lazy loading and optimization
- Progressive enhancement approach

## Development Workflow

### Version Control
- Git-based workflow with feature branches
- Main branch for production releases
- Development branch for integration
- Pull request reviews required

### CI/CD Pipeline
- Automated testing on pull requests
- Deployment to staging environment
- Production deployment with approval
- Rollback capabilities

### Code Standards
- TypeScript for type safety
- ESLint configuration for code quality
- Prettier for consistent formatting
- Husky pre-commit hooks

## Accessibility Standards

### WCAG 2.1 AA Compliance
- Semantic HTML structure
- Proper ARIA labels and roles
- Keyboard navigation support
- Color contrast ratios
- Screen reader compatibility

### Inclusive Design
- Multiple input methods support
- Customizable text sizes
- High contrast mode
- Reduced motion preferences
- Multi-language support preparation

## Deployment Strategy

### Development Environment
- Local development with Vite dev server
- Hot module replacement for fast iteration
- Mock data for offline development
- Environment variable configuration

### Staging Environment
- Vercel preview deployments
- Supabase staging database
- End-to-end testing suite
- Performance monitoring

### Production Environment
- Vercel production deployment
- Supabase production database
- CDN for global content delivery
- Error tracking and monitoring

## Future Enhancements

### Phase 2 Features
- Social features and community
- Advanced analytics and insights
- AI-powered workout recommendations
- Wearable device integration

### Phase 3 Features
- Nutrition tracking integration
- Personal trainer connection platform
- Advanced progress visualization
- Mobile app development

## Success Metrics

### User Engagement
- Daily/Monthly Active Users (DAU/MAU)
- Session duration and frequency
- Feature adoption rates
- User retention over time

### Technical Performance
- Core Web Vitals scores
- App loading times
- Offline functionality usage
- Error rates and uptime

### Business Goals
- User acquisition cost
- Organic growth rate
- User satisfaction scores
- Community engagement levels

This comprehensive planning document serves as the foundation for the trAInor project, ensuring all team members understand the vision, technical decisions, and implementation strategy.