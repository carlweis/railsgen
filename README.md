# 🚀 railsgen

A Rails application generator inspired by [thoughtbot/suspenders](https://github.com/thoughtbot/suspenders) that creates production-ready Rails 8 applications with a modern React + TypeScript frontend stack.

## Features

Every application generated with railsgen includes:

### Backend
- **Rails 8** - Latest Rails with all modern features
- **Devise** - Full authentication with custom Inertia.js pages
- **Pundit** - Policy-based authorization
- **RSpec** - Testing framework with FactoryBot, Shoulda Matchers
- **Capybara** - Integration testing with headless Chrome

### Frontend
- **React 18+** - Modern React with hooks
- **TypeScript** - Full type safety
- **Inertia.js** - SPA-like navigation without building an API
- **Vite** - Lightning-fast build tool
- **Tailwind CSS v4** - Next-gen utility-first CSS
- **shadcn/ui** - Beautiful, accessible UI components
- **Jest** - Frontend testing with Testing Library

### Developer Experience
- **Pre-configured CLAUDE.md** - AI assistant context
- **Pre-configured .claude/plans/** - Feature planning templates
- **ESLint + RuboCop** - Code linting
- **TypeScript strict mode** - Maximum type safety

## Installation

### Option 1: Clone the Repository

```bash
git clone https://github.com/yourusername/railsgen.git
cd railsgen

# Make the script executable
chmod +x bin/railsgen

# Add to your PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:$(pwd)/bin"
```

### Option 2: Direct Download

```bash
# Download the template
curl -o ~/railsgen/template.rb https://raw.githubusercontent.com/yourusername/railsgen/main/template.rb
curl -o ~/railsgen/bin/railsgen https://raw.githubusercontent.com/yourusername/railsgen/main/bin/railsgen

chmod +x ~/railsgen/bin/railsgen
export PATH="$PATH:$HOME/railsgen/bin"
```

## Requirements

- **Ruby** 3.2+
- **Rails** 8.0+
- **Node.js** 18+
- **npm** 9+

## Usage

### Basic Usage

```bash
# Create a new application with SQLite (default)
railsgen myapp

# Create with PostgreSQL
railsgen myapp --database=postgresql

# Create with MySQL
railsgen myapp --database=mysql
```

### Available Options

| Option | Description | Default |
|--------|-------------|---------|
| `--database=DATABASE` | Database adapter (postgresql, mysql, sqlite3) | sqlite3 |
| `--skip-git` | Don't initialize a git repository | false |
| `--help, -h` | Show help message | - |
| `--version, -v` | Show version | - |

### Using the Template Directly

If you prefer to use the Rails template directly:

```bash
rails new myapp \
  --database=postgresql \
  --skip-jbuilder \
  --skip-test \
  -m /path/to/railsgen/template.rb
```

## Generated Application Structure

```
myapp/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── welcome_controller.rb
│   │   └── users/
│   │       ├── sessions_controller.rb
│   │       ├── registrations_controller.rb
│   │       └── passwords_controller.rb
│   ├── frontend/
│   │   ├── components/
│   │   │   └── ui/           # shadcn/ui components
│   │   │       ├── alert.tsx
│   │   │       ├── avatar.tsx
│   │   │       ├── badge.tsx
│   │   │       ├── button.tsx
│   │   │       ├── card.tsx
│   │   │       ├── input.tsx
│   │   │       ├── label.tsx
│   │   │       ├── separator.tsx
│   │   │       ├── skeleton.tsx
│   │   │       └── index.ts
│   │   ├── entrypoints/
│   │   │   └── application.tsx
│   │   ├── hooks/
│   │   ├── layouts/
│   │   │   └── MainLayout.tsx
│   │   ├── lib/
│   │   │   └── utils.ts
│   │   ├── pages/
│   │   │   ├── Auth/
│   │   │   │   ├── Login.tsx
│   │   │   │   ├── Register.tsx
│   │   │   │   ├── ForgotPassword.tsx
│   │   │   │   └── ResetPassword.tsx
│   │   │   └── Welcome/
│   │   │       └── Index.tsx
│   │   ├── styles/
│   │   │   └── application.css
│   │   ├── test/
│   │   │   ├── setupTests.ts
│   │   │   └── test-utils.tsx
│   │   └── types/
│   │       ├── index.ts
│   │       └── global.d.ts
│   ├── models/
│   ├── policies/
│   │   └── application_policy.rb
│   └── views/
│       └── layouts/
│           └── inertia.html.erb
├── config/
│   ├── initializers/
│   │   ├── devise.rb
│   │   └── inertia_rails.rb
│   └── routes.rb
├── spec/
│   ├── support/
│   │   ├── capybara.rb
│   │   ├── factory_bot.rb
│   │   ├── inertia.rb
│   │   └── shoulda_matchers.rb
│   └── rails_helper.rb
├── .claude/
│   └── plans/
│       ├── README.md
│       └── project-overview.md
├── CLAUDE.md
├── vite.config.ts
├── tsconfig.json
├── jest.config.js
└── package.json
```

## After Generation

### Start Development Server

```bash
cd myapp
bin/dev
```

This starts both the Rails server and Vite development server.

### Run Tests

```bash
# Ruby tests
bundle exec rspec

# JavaScript tests
npm test

# JavaScript tests in watch mode
npm run test:watch
```

### Type Checking

```bash
npm run typecheck
```

### Linting

```bash
# Ruby
bundle exec rubocop

# TypeScript/React
npm run lint
```

## Working with the Stack

### Creating a New Inertia Page

1. Create the controller:

```ruby
# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  def index
    posts = Post.all
    render inertia: "Posts/Index", props: { posts: posts }
  end
end
```

2. Create the React page:

```tsx
// app/frontend/pages/Posts/Index.tsx
import { Head } from "@inertiajs/react";
import MainLayout from "@/layouts/MainLayout";

interface Post {
  id: number;
  title: string;
}

interface Props {
  posts: Post[];
}

export default function PostsIndex({ posts }: Props) {
  return (
    <MainLayout title="Posts">
      <Head title="Posts" />
      <ul>
        {posts.map((post) => (
          <li key={post.id}>{post.title}</li>
        ))}
      </ul>
    </MainLayout>
  );
}
```

3. Add the route:

```ruby
# config/routes.rb
resources :posts, only: [:index]
```

### Using shadcn/ui Components

Components are already installed in `app/frontend/components/ui/`. Import and use them:

```tsx
import { Button } from "@/components/ui/button";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";

export default function MyPage() {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Hello World</CardTitle>
      </CardHeader>
      <CardContent>
        <Button variant="outline">Click me</Button>
      </CardContent>
    </Card>
  );
}
```

### Adding More shadcn/ui Components

The template includes core components. To add more, visit [ui.shadcn.com](https://ui.shadcn.com/docs/components) and copy the component code into `app/frontend/components/ui/`.

### Authorization with Pundit

```ruby
# app/policies/post_policy.rb
class PostPolicy < ApplicationPolicy
  def update?
    user.admin? || record.user_id == user.id
  end
end

# In controller
def update
  @post = Post.find(params[:id])
  authorize @post
  # ...
end
```

## Customization

### Changing Theme Colors

Edit `app/frontend/styles/application.css` and modify the CSS variables in the `@theme` block:

```css
@theme {
  --color-primary: oklch(55% 0.2 260);  /* Change primary color */
  --color-accent: oklch(70% 0.15 30);   /* Change accent color */
}
```

### Adding Custom Fonts

1. Add the font to your `app/views/layouts/inertia.html.erb`:

```html
<link href="https://fonts.googleapis.com/css2?family=Your+Font&display=swap" rel="stylesheet">
```

2. Update the CSS variables:

```css
@theme {
  --font-sans: "Your Font", ui-sans-serif, system-ui, sans-serif;
}
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- [thoughtbot/suspenders](https://github.com/thoughtbot/suspenders) - Original inspiration
- [Inertia.js](https://inertiajs.com/) - The modern monolith
- [shadcn/ui](https://ui.shadcn.com/) - Beautiful UI components
- [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS
