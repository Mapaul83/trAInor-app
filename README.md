# trAInor - Personal Training App

A free, offline-first Progressive Web Application for calisthenics and bodyweight training with Supabase backend integration.

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ 
- npm or pnpm
- Supabase account (for backend features)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Mapaul83/trAInor-app.git
cd trAInor-app
```

2. Install dependencies:
```bash
npm install
```

3. Set up Supabase backend:
   - Follow the detailed guide in `SUPABASE_SETUP.md`
   - Copy `.env.local.example` to `.env.local` and add your Supabase credentials

4. Start the development server:
```bash
npm run dev
```

5. Open [http://localhost:5173](http://localhost:5173) in your browser

## 🗂️ Project Structure

```
trAInor/
├── src/
│   ├── routes/           # SvelteKit pages and layouts
│   │   ├── auth/         # Authentication pages (login, signup)
│   │   └── dashboard/    # Protected user dashboard
│   ├── lib/              # Reusable components and utilities
│   │   ├── stores/       # Svelte stores for state management
│   │   ├── supabase.ts   # Supabase client configuration
│   │   └── supabaseTypes.ts # TypeScript database definitions
│   ├── app.html          # HTML template
│   ├── app.css           # Global styles and Tailwind imports
│   └── app.d.ts          # TypeScript app definitions
├── database/             # Database schema and seed files
│   ├── schema.sql        # Complete database structure
│   └── seed.sql          # Sample exercise data
├── static/               # Static assets
├── docs/                 # Project documentation
├── PLANNING.md           # Comprehensive project planning
├── TASKS.md              # Development task breakdown
├── SUPABASE_SETUP.md     # Backend setup guide
└── package.json          # Dependencies and scripts
```

## 🛠️ Technology Stack

- **Frontend**: SvelteKit + TypeScript
- **Backend**: Supabase (PostgreSQL + Auth + Real-time)
- **Styling**: TailwindCSS
- **PWA**: Vite PWA Plugin with Workbox
- **Backend**: Supabase (PostgreSQL + Auth + Real-time)
- **Offline Storage**: LocalForage
- **Animations**: Lottie Web
- **Testing**: Vitest + Playwright
- **Deployment**: Vercel

## 📱 Features

### Core Features
- 🏋️ Comprehensive bodyweight exercise library
- 📋 Custom workout creation and execution
- 📊 Progress tracking and analytics
- 📱 Progressive Web App (installable)
- 🔄 Offline-first functionality
- 🎨 Responsive design for all devices

### Planned Features
- 👥 Social features and community
- 🤖 AI-powered workout recommendations
- 📈 Advanced analytics and insights
- ⌚ Wearable device integration

## 🚀 Development

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run test` - Run unit tests
- `npm run test:e2e` - Run end-to-end tests
- `npm run lint` - Lint code with ESLint
- `npm run format` - Format code with Prettier

### Development Workflow

1. Create a feature branch from `development`
2. Make your changes and commit with conventional commit messages
3. Run tests and ensure code quality passes
4. Create a pull request to `development`
5. After review and approval, merge to `development`

### Code Quality

This project uses:
- **ESLint** for code linting
- **Prettier** for code formatting
- **Husky** for pre-commit hooks
- **TypeScript** for type safety

## 📖 Documentation

- [Project Planning](PLANNING.md) - Comprehensive project overview and architecture
- [Development Tasks](TASKS.md) - Detailed task breakdown and roadmap
- [Supabase Setup](SUPABASE_SETUP.md) - Complete backend setup guide
- [API Documentation](docs/api.md) - API reference (coming soon)
- [Component Documentation](docs/components.md) - Component library (coming soon)

## 🔧 Configuration

### Environment Variables

Create a `.env.local` file in the root directory:

```env
# Supabase Configuration
PUBLIC_SUPABASE_URL=your_supabase_url
PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

### PWA Configuration

The PWA manifest is configured in `vite.config.ts`. Key settings:
- **App Name**: trAInor - Personal Training App
- **Theme Color**: #3b82f6 (Primary Blue)
- **Background Color**: #ffffff (White)
- **Display Mode**: standalone

## 🚀 Deployment

This project is configured for easy deployment to Vercel:

1. Connect your GitHub repository to Vercel
2. Set environment variables in Vercel dashboard
3. Deploy automatically on every push to main branch

### Environment Variables for Production

Make sure to set these in your deployment platform:
- `PUBLIC_SUPABASE_URL`
- `PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [SvelteKit](https://kit.svelte.dev/)
- Backend powered by [Supabase](https://supabase.com/)
- UI styled with [TailwindCSS](https://tailwindcss.com/)
- PWA capabilities via [Vite PWA](https://vite-pwa-org.netlify.app/)

## 📞 Support

If you have any questions or need help, please:
- Open an issue on GitHub
- Check the documentation in the `docs/` folder
- Review the setup guide in `SUPABASE_SETUP.md`

---

**trAInor** - Transform your training, one rep at a time! 💪