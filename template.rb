# frozen_string_literal: true

# =============================================================================
# Rails 8 + Inertia + React + TypeScript + Tailwind v4 + shadcn Application Template
# =============================================================================
#
# Usage:
#   rails new myapp -m /path/to/template.rb --skip-jbuilder --skip-test
#
# Or via the wrapper script:
#   ./bin/railsgen myapp
#
# =============================================================================

require "fileutils"
require "json"

TEMPLATE_ROOT = File.expand_path(File.dirname(__FILE__))

def source_paths
  [File.join(TEMPLATE_ROOT, "templates"), TEMPLATE_ROOT]
end

# =============================================================================
# Helper Methods
# =============================================================================

def add_gem(name, *args)
  gem name, *args unless gem_exists?(name)
end

def gem_exists?(name)
  File.read("Gemfile").include?(name)
end

def run_bundle
  run "bundle install"
end

def copy_template(source, destination = source)
  template_path = File.join(TEMPLATE_ROOT, "templates", source)
  if File.exist?(template_path)
    copy_file template_path, destination
  else
    say "Template not found: #{template_path}", :red
  end
end

def template_content(source)
  template_path = File.join(TEMPLATE_ROOT, "templates", source)
  File.read(template_path)
end

# =============================================================================
# Remove default test directory (we use RSpec)
# =============================================================================

say "🧹 Removing default test directory...", :yellow
run "rm -rf test"

# =============================================================================
# Add Gems
# =============================================================================

say "💎 Adding gems...", :yellow

# Core gems
gem_group :development, :test do
  add_gem "rspec-rails", "~> 7.0"
  add_gem "factory_bot_rails", "~> 6.4"
  add_gem "faker", "~> 3.4"
  add_gem "dotenv-rails", "~> 3.1"
end

gem_group :development do
  add_gem "annotate", "~> 3.2"
  add_gem "rubocop-rails", "~> 2.25", require: false
  add_gem "rubocop-rspec", "~> 3.0", require: false
end

gem_group :test do
  add_gem "capybara", "~> 3.40"
  add_gem "selenium-webdriver", "~> 4.23"
  add_gem "shoulda-matchers", "~> 6.2"
  add_gem "simplecov", "~> 0.22", require: false
end

# Inertia, Authentication & Authorization
add_gem "inertia_rails", "~> 3.4"
add_gem "vite_rails", "~> 3.0"
add_gem "devise", "~> 4.9"
add_gem "pundit", "~> 2.3"

run_bundle

# =============================================================================
# Install & Configure Vite
# =============================================================================

say "⚡ Installing Vite...", :yellow
run "bundle exec vite install"

# =============================================================================
# Setup Node.js / TypeScript / React
# =============================================================================

say "📦 Setting up Node.js dependencies...", :yellow

# Create package.json if it doesn't exist with proper structure
unless File.exist?("package.json")
  create_file "package.json", <<~JSON
    {
      "name": "#{app_name}",
      "private": true,
      "type": "module",
      "scripts": {
        "dev": "vite",
        "build": "tsc && vite build",
        "preview": "vite preview",
        "test": "jest",
        "test:watch": "jest --watch",
        "lint": "eslint . --ext ts,tsx",
        "typecheck": "tsc --noEmit"
      }
    }
  JSON
end

# Core dependencies
run "npm install react react-dom @inertiajs/react"
run "npm install -D typescript @types/react @types/react-dom @types/node"
run "npm install -D vite @vitejs/plugin-react"

# Tailwind CSS v4
run "npm install -D tailwindcss @tailwindcss/vite"

# shadcn/ui dependencies
run "npm install class-variance-authority clsx tailwind-merge lucide-react"
run "npm install @radix-ui/react-slot @radix-ui/react-dialog @radix-ui/react-dropdown-menu"
run "npm install @radix-ui/react-label @radix-ui/react-select @radix-ui/react-tabs"
run "npm install @radix-ui/react-toast @radix-ui/react-tooltip @radix-ui/react-avatar"
run "npm install @radix-ui/react-checkbox @radix-ui/react-radio-group @radix-ui/react-switch"
run "npm install @radix-ui/react-accordion @radix-ui/react-alert-dialog @radix-ui/react-aspect-ratio"
run "npm install @radix-ui/react-collapsible @radix-ui/react-context-menu @radix-ui/react-hover-card"
run "npm install @radix-ui/react-menubar @radix-ui/react-navigation-menu @radix-ui/react-popover"
run "npm install @radix-ui/react-progress @radix-ui/react-scroll-area @radix-ui/react-separator"
run "npm install @radix-ui/react-slider @radix-ui/react-toggle @radix-ui/react-toggle-group"
run "npm install cmdk date-fns react-day-picker recharts @tanstack/react-table"
run "npm install vaul sonner react-resizable-panels embla-carousel-react input-otp"

# Jest for testing
run "npm install -D jest @types/jest ts-jest jest-environment-jsdom"
run "npm install -D @testing-library/react @testing-library/jest-dom @testing-library/user-event"

# ESLint
run "npm install -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin"
run "npm install -D eslint-plugin-react eslint-plugin-react-hooks"

# =============================================================================
# Create TypeScript Configuration
# =============================================================================

say "⚙️ Creating TypeScript configuration...", :yellow

create_file "tsconfig.json", <<~JSON
  {
    "compilerOptions": {
      "target": "ES2022",
      "useDefineForClassFields": true,
      "lib": ["ES2022", "DOM", "DOM.Iterable"],
      "module": "ESNext",
      "skipLibCheck": true,
      "moduleResolution": "bundler",
      "allowImportingTsExtensions": true,
      "resolveJsonModule": true,
      "isolatedModules": true,
      "noEmit": true,
      "jsx": "react-jsx",
      "strict": true,
      "noUnusedLocals": true,
      "noUnusedParameters": true,
      "noFallthroughCasesInSwitch": true,
      "baseUrl": ".",
      "paths": {
        "@/*": ["./app/frontend/*"],
        "@/components/*": ["./app/frontend/components/*"],
        "@/lib/*": ["./app/frontend/lib/*"],
        "@/pages/*": ["./app/frontend/pages/*"],
        "@/hooks/*": ["./app/frontend/hooks/*"],
        "@/types/*": ["./app/frontend/types/*"]
      }
    },
    "include": ["app/frontend/**/*", "app/frontend/**/*.tsx", "app/frontend/**/*.ts"],
    "references": [{ "path": "./tsconfig.node.json" }]
  }
JSON

create_file "tsconfig.node.json", <<~JSON
  {
    "compilerOptions": {
      "composite": true,
      "skipLibCheck": true,
      "module": "ESNext",
      "moduleResolution": "bundler",
      "allowSyntheticDefaultImports": true,
      "strict": true
    },
    "include": ["vite.config.ts"]
  }
JSON

# =============================================================================
# Create Vite Configuration
# =============================================================================

say "⚙️ Creating Vite configuration...", :yellow

create_file "vite.config.ts", <<~TYPESCRIPT
  import { defineConfig } from "vite";
  import react from "@vitejs/plugin-react";
  import tailwindcss from "@tailwindcss/vite";
  import ViteRails from "vite-plugin-rails";
  import { resolve } from "path";

  export default defineConfig({
    plugins: [
      react(),
      tailwindcss(),
      ViteRails({
        fullReload: {
          additionalPaths: ["config/routes.rb", "app/views/**/*"],
        },
      }),
    ],
    resolve: {
      alias: {
        "@": resolve(__dirname, "app/frontend"),
      },
    },
    build: {
      sourcemap: true,
      rollupOptions: {
        output: {
          manualChunks: {
            vendor: ["react", "react-dom", "@inertiajs/react"],
            ui: ["@radix-ui/react-dialog", "@radix-ui/react-dropdown-menu"],
          },
        },
      },
    },
  });
TYPESCRIPT

# =============================================================================
# Create Jest Configuration
# =============================================================================

say "🧪 Creating Jest configuration...", :yellow

create_file "jest.config.js", <<~JAVASCRIPT
  /** @type {import('ts-jest').JestConfigWithTsJest} */
  export default {
    preset: "ts-jest",
    testEnvironment: "jsdom",
    roots: ["<rootDir>/app/frontend"],
    modulePaths: ["<rootDir>"],
    moduleNameMapper: {
      "^@/(.*)$": "<rootDir>/app/frontend/$1",
    },
    setupFilesAfterEnv: ["<rootDir>/app/frontend/test/setupTests.ts"],
    testMatch: [
      "**/__tests__/**/*.+(ts|tsx|js)",
      "**/?(*.)+(spec|test).+(ts|tsx|js)",
    ],
    transform: {
      "^.+\\.(ts|tsx)$": ["ts-jest", { useESM: true }],
    },
    moduleFileExtensions: ["ts", "tsx", "js", "jsx", "json", "node"],
    collectCoverageFrom: [
      "app/frontend/**/*.{ts,tsx}",
      "!app/frontend/**/*.d.ts",
      "!app/frontend/test/**/*",
    ],
  };
JAVASCRIPT

# =============================================================================
# Create ESLint Configuration
# =============================================================================

say "📝 Creating ESLint configuration...", :yellow

create_file ".eslintrc.cjs", <<~JAVASCRIPT
  module.exports = {
    root: true,
    env: { browser: true, es2022: true, node: true },
    extends: [
      "eslint:recommended",
      "plugin:@typescript-eslint/recommended",
      "plugin:react/recommended",
      "plugin:react-hooks/recommended",
    ],
    ignorePatterns: ["dist", ".eslintrc.cjs", "node_modules"],
    parser: "@typescript-eslint/parser",
    parserOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      ecmaFeatures: { jsx: true },
    },
    plugins: ["react", "@typescript-eslint", "react-hooks"],
    settings: {
      react: { version: "detect" },
    },
    rules: {
      "react/react-in-jsx-scope": "off",
      "react/prop-types": "off",
      "@typescript-eslint/no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
    },
  };
JAVASCRIPT

# =============================================================================
# Create Frontend Directory Structure
# =============================================================================

say "📁 Creating frontend directory structure...", :yellow

# Main directories
run "mkdir -p app/frontend/{components,pages,lib,hooks,types,test,layouts}"
run "mkdir -p app/frontend/components/ui"

# =============================================================================
# Create Tailwind CSS v4 Configuration
# =============================================================================

say "🎨 Creating Tailwind CSS v4 configuration...", :yellow

create_file "app/frontend/styles/application.css", <<~CSS
  @import "tailwindcss";
  
  @theme {
    /* Colors - Modern shadcn-inspired palette */
    --color-background: oklch(100% 0 0);
    --color-foreground: oklch(14.08% 0.004 285.82);
    
    --color-card: oklch(100% 0 0);
    --color-card-foreground: oklch(14.08% 0.004 285.82);
    
    --color-popover: oklch(100% 0 0);
    --color-popover-foreground: oklch(14.08% 0.004 285.82);
    
    --color-primary: oklch(20.47% 0.006 285.88);
    --color-primary-foreground: oklch(98.51% 0.001 106.42);
    
    --color-secondary: oklch(96.76% 0.001 286.38);
    --color-secondary-foreground: oklch(20.92% 0.006 285.89);
    
    --color-muted: oklch(96.76% 0.001 286.38);
    --color-muted-foreground: oklch(55.19% 0.014 285.94);
    
    --color-accent: oklch(96.76% 0.001 286.38);
    --color-accent-foreground: oklch(20.92% 0.006 285.89);
    
    --color-destructive: oklch(57.71% 0.215 27.32);
    --color-destructive-foreground: oklch(98.51% 0.001 106.42);
    
    --color-border: oklch(91.97% 0.004 286.32);
    --color-input: oklch(91.97% 0.004 286.32);
    --color-ring: oklch(70.62% 0.02 285.98);
    
    /* Radius */
    --radius-sm: 0.25rem;
    --radius-md: 0.375rem;
    --radius-lg: 0.5rem;
    --radius-xl: 0.75rem;
    --radius-2xl: 1rem;
    
    /* Fonts */
    --font-sans: ui-sans-serif, system-ui, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
    --font-mono: ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas, "Liberation Mono", monospace;
  }
  
  /* Dark mode theme */
  @media (prefers-color-scheme: dark) {
    @theme {
      --color-background: oklch(14.08% 0.004 285.82);
      --color-foreground: oklch(98.51% 0.001 106.42);
      
      --color-card: oklch(14.08% 0.004 285.82);
      --color-card-foreground: oklch(98.51% 0.001 106.42);
      
      --color-popover: oklch(14.08% 0.004 285.82);
      --color-popover-foreground: oklch(98.51% 0.001 106.42);
      
      --color-primary: oklch(98.51% 0.001 106.42);
      --color-primary-foreground: oklch(20.47% 0.006 285.88);
      
      --color-secondary: oklch(26.96% 0.005 285.98);
      --color-secondary-foreground: oklch(98.51% 0.001 106.42);
      
      --color-muted: oklch(26.96% 0.005 285.98);
      --color-muted-foreground: oklch(70.62% 0.02 285.98);
      
      --color-accent: oklch(26.96% 0.005 285.98);
      --color-accent-foreground: oklch(98.51% 0.001 106.42);
      
      --color-destructive: oklch(57.71% 0.215 27.32);
      --color-destructive-foreground: oklch(98.51% 0.001 106.42);
      
      --color-border: oklch(26.96% 0.005 285.98);
      --color-input: oklch(26.96% 0.005 285.98);
      --color-ring: oklch(83.91% 0.016 286.38);
    }
  }
  
  /* Base styles */
  @layer base {
    * {
      @apply border-border;
    }
    
    body {
      @apply bg-background text-foreground;
      font-feature-settings: "rlig" 1, "calt" 1;
    }
  }
CSS

# =============================================================================
# Create Utility Functions (shadcn cn helper)
# =============================================================================

say "🛠️ Creating utility functions...", :yellow

create_file "app/frontend/lib/utils.ts", <<~TYPESCRIPT
  import { type ClassValue, clsx } from "clsx";
  import { twMerge } from "tailwind-merge";

  export function cn(...inputs: ClassValue[]) {
    return twMerge(clsx(inputs));
  }

  export function formatDate(date: Date | string): string {
    return new Intl.DateTimeFormat("en-US", {
      month: "long",
      day: "numeric",
      year: "numeric",
    }).format(new Date(date));
  }

  export function absoluteUrl(path: string): string {
    return `${window.location.origin}${path}`;
  }
TYPESCRIPT

# =============================================================================
# Create shadcn/ui Components
# =============================================================================

say "🧩 Creating shadcn/ui components...", :yellow

# Button component
create_file "app/frontend/components/ui/button.tsx", <<~TYPESCRIPT
  import * as React from "react";
  import { Slot } from "@radix-ui/react-slot";
  import { cva, type VariantProps } from "class-variance-authority";
  import { cn } from "@/lib/utils";

  const buttonVariants = cva(
    "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
    {
      variants: {
        variant: {
          default: "bg-primary text-primary-foreground hover:bg-primary/90",
          destructive: "bg-destructive text-destructive-foreground hover:bg-destructive/90",
          outline: "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
          secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
          ghost: "hover:bg-accent hover:text-accent-foreground",
          link: "text-primary underline-offset-4 hover:underline",
        },
        size: {
          default: "h-10 px-4 py-2",
          sm: "h-9 rounded-md px-3",
          lg: "h-11 rounded-md px-8",
          icon: "h-10 w-10",
        },
      },
      defaultVariants: {
        variant: "default",
        size: "default",
      },
    }
  );

  export interface ButtonProps
    extends React.ButtonHTMLAttributes<HTMLButtonElement>,
      VariantProps<typeof buttonVariants> {
    asChild?: boolean;
  }

  const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
    ({ className, variant, size, asChild = false, ...props }, ref) => {
      const Comp = asChild ? Slot : "button";
      return (
        <Comp
          className={cn(buttonVariants({ variant, size, className }))}
          ref={ref}
          {...props}
        />
      );
    }
  );
  Button.displayName = "Button";

  export { Button, buttonVariants };
TYPESCRIPT

# Input component
create_file "app/frontend/components/ui/input.tsx", <<~TYPESCRIPT
  import * as React from "react";
  import { cn } from "@/lib/utils";

  export interface InputProps
    extends React.InputHTMLAttributes<HTMLInputElement> {}

  const Input = React.forwardRef<HTMLInputElement, InputProps>(
    ({ className, type, ...props }, ref) => {
      return (
        <input
          type={type}
          className={cn(
            "flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
            className
          )}
          ref={ref}
          {...props}
        />
      );
    }
  );
  Input.displayName = "Input";

  export { Input };
TYPESCRIPT

# Label component
create_file "app/frontend/components/ui/label.tsx", <<~TYPESCRIPT
  import * as React from "react";
  import * as LabelPrimitive from "@radix-ui/react-label";
  import { cva, type VariantProps } from "class-variance-authority";
  import { cn } from "@/lib/utils";

  const labelVariants = cva(
    "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
  );

  const Label = React.forwardRef<
    React.ElementRef<typeof LabelPrimitive.Root>,
    React.ComponentPropsWithoutRef<typeof LabelPrimitive.Root> &
      VariantProps<typeof labelVariants>
  >(({ className, ...props }, ref) => (
    <LabelPrimitive.Root
      ref={ref}
      className={cn(labelVariants(), className)}
      {...props}
    />
  ));
  Label.displayName = LabelPrimitive.Root.displayName;

  export { Label };
TYPESCRIPT

# Card component
create_file "app/frontend/components/ui/card.tsx", <<~TYPESCRIPT
  import * as React from "react";
  import { cn } from "@/lib/utils";

  const Card = React.forwardRef<
    HTMLDivElement,
    React.HTMLAttributes<HTMLDivElement>
  >(({ className, ...props }, ref) => (
    <div
      ref={ref}
      className={cn(
        "rounded-lg border bg-card text-card-foreground shadow-sm",
        className
      )}
      {...props}
    />
  ));
  Card.displayName = "Card";

  const CardHeader = React.forwardRef<
    HTMLDivElement,
    React.HTMLAttributes<HTMLDivElement>
  >(({ className, ...props }, ref) => (
    <div
      ref={ref}
      className={cn("flex flex-col space-y-1.5 p-6", className)}
      {...props}
    />
  ));
  CardHeader.displayName = "CardHeader";

  const CardTitle = React.forwardRef<
    HTMLParagraphElement,
    React.HTMLAttributes<HTMLHeadingElement>
  >(({ className, ...props }, ref) => (
    <h3
      ref={ref}
      className={cn(
        "text-2xl font-semibold leading-none tracking-tight",
        className
      )}
      {...props}
    />
  ));
  CardTitle.displayName = "CardTitle";

  const CardDescription = React.forwardRef<
    HTMLParagraphElement,
    React.HTMLAttributes<HTMLParagraphElement>
  >(({ className, ...props }, ref) => (
    <p
      ref={ref}
      className={cn("text-sm text-muted-foreground", className)}
      {...props}
    />
  ));
  CardDescription.displayName = "CardDescription";

  const CardContent = React.forwardRef<
    HTMLDivElement,
    React.HTMLAttributes<HTMLDivElement>
  >(({ className, ...props }, ref) => (
    <div ref={ref} className={cn("p-6 pt-0", className)} {...props} />
  ));
  CardContent.displayName = "CardContent";

  const CardFooter = React.forwardRef<
    HTMLDivElement,
    React.HTMLAttributes<HTMLDivElement>
  >(({ className, ...props }, ref) => (
    <div
      ref={ref}
      className={cn("flex items-center p-6 pt-0", className)}
      {...props}
    />
  ));
  CardFooter.displayName = "CardFooter";

  export { Card, CardHeader, CardFooter, CardTitle, CardDescription, CardContent };
TYPESCRIPT

# Alert component
create_file "app/frontend/components/ui/alert.tsx", <<~TYPESCRIPT
  import * as React from "react";
  import { cva, type VariantProps } from "class-variance-authority";
  import { cn } from "@/lib/utils";

  const alertVariants = cva(
    "relative w-full rounded-lg border p-4 [&>svg~*]:pl-7 [&>svg+div]:translate-y-[-3px] [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:text-foreground",
    {
      variants: {
        variant: {
          default: "bg-background text-foreground",
          destructive:
            "border-destructive/50 text-destructive dark:border-destructive [&>svg]:text-destructive",
        },
      },
      defaultVariants: {
        variant: "default",
      },
    }
  );

  const Alert = React.forwardRef<
    HTMLDivElement,
    React.HTMLAttributes<HTMLDivElement> & VariantProps<typeof alertVariants>
  >(({ className, variant, ...props }, ref) => (
    <div
      ref={ref}
      role="alert"
      className={cn(alertVariants({ variant }), className)}
      {...props}
    />
  ));
  Alert.displayName = "Alert";

  const AlertTitle = React.forwardRef<
    HTMLParagraphElement,
    React.HTMLAttributes<HTMLHeadingElement>
  >(({ className, ...props }, ref) => (
    <h5
      ref={ref}
      className={cn("mb-1 font-medium leading-none tracking-tight", className)}
      {...props}
    />
  ));
  AlertTitle.displayName = "AlertTitle";

  const AlertDescription = React.forwardRef<
    HTMLParagraphElement,
    React.HTMLAttributes<HTMLParagraphElement>
  >(({ className, ...props }, ref) => (
    <div
      ref={ref}
      className={cn("text-sm [&_p]:leading-relaxed", className)}
      {...props}
    />
  ));
  AlertDescription.displayName = "AlertDescription";

  export { Alert, AlertTitle, AlertDescription };
TYPESCRIPT

# Avatar component
create_file "app/frontend/components/ui/avatar.tsx", <<~TYPESCRIPT
  import * as React from "react";
  import * as AvatarPrimitive from "@radix-ui/react-avatar";
  import { cn } from "@/lib/utils";

  const Avatar = React.forwardRef<
    React.ElementRef<typeof AvatarPrimitive.Root>,
    React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Root>
  >(({ className, ...props }, ref) => (
    <AvatarPrimitive.Root
      ref={ref}
      className={cn(
        "relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full",
        className
      )}
      {...props}
    />
  ));
  Avatar.displayName = AvatarPrimitive.Root.displayName;

  const AvatarImage = React.forwardRef<
    React.ElementRef<typeof AvatarPrimitive.Image>,
    React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Image>
  >(({ className, ...props }, ref) => (
    <AvatarPrimitive.Image
      ref={ref}
      className={cn("aspect-square h-full w-full", className)}
      {...props}
    />
  ));
  AvatarImage.displayName = AvatarPrimitive.Image.displayName;

  const AvatarFallback = React.forwardRef<
    React.ElementRef<typeof AvatarPrimitive.Fallback>,
    React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Fallback>
  >(({ className, ...props }, ref) => (
    <AvatarPrimitive.Fallback
      ref={ref}
      className={cn(
        "flex h-full w-full items-center justify-center rounded-full bg-muted",
        className
      )}
      {...props}
    />
  ));
  AvatarFallback.displayName = AvatarPrimitive.Fallback.displayName;

  export { Avatar, AvatarImage, AvatarFallback };
TYPESCRIPT

# Badge component
create_file "app/frontend/components/ui/badge.tsx", <<~TYPESCRIPT
  import * as React from "react";
  import { cva, type VariantProps } from "class-variance-authority";
  import { cn } from "@/lib/utils";

  const badgeVariants = cva(
    "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
    {
      variants: {
        variant: {
          default:
            "border-transparent bg-primary text-primary-foreground hover:bg-primary/80",
          secondary:
            "border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
          destructive:
            "border-transparent bg-destructive text-destructive-foreground hover:bg-destructive/80",
          outline: "text-foreground",
        },
      },
      defaultVariants: {
        variant: "default",
      },
    }
  );

  export interface BadgeProps
    extends React.HTMLAttributes<HTMLDivElement>,
      VariantProps<typeof badgeVariants> {}

  function Badge({ className, variant, ...props }: BadgeProps) {
    return (
      <div className={cn(badgeVariants({ variant }), className)} {...props} />
    );
  }

  export { Badge, badgeVariants };
TYPESCRIPT

# Separator component
create_file "app/frontend/components/ui/separator.tsx", <<~TYPESCRIPT
  import * as React from "react";
  import * as SeparatorPrimitive from "@radix-ui/react-separator";
  import { cn } from "@/lib/utils";

  const Separator = React.forwardRef<
    React.ElementRef<typeof SeparatorPrimitive.Root>,
    React.ComponentPropsWithoutRef<typeof SeparatorPrimitive.Root>
  >(
    (
      { className, orientation = "horizontal", decorative = true, ...props },
      ref
    ) => (
      <SeparatorPrimitive.Root
        ref={ref}
        decorative={decorative}
        orientation={orientation}
        className={cn(
          "shrink-0 bg-border",
          orientation === "horizontal" ? "h-[1px] w-full" : "h-full w-[1px]",
          className
        )}
        {...props}
      />
    )
  );
  Separator.displayName = SeparatorPrimitive.Root.displayName;

  export { Separator };
TYPESCRIPT

# Skeleton component
create_file "app/frontend/components/ui/skeleton.tsx", <<~TYPESCRIPT
  import { cn } from "@/lib/utils";

  function Skeleton({
    className,
    ...props
  }: React.HTMLAttributes<HTMLDivElement>) {
    return (
      <div
        className={cn("animate-pulse rounded-md bg-muted", className)}
        {...props}
      />
    );
  }

  export { Skeleton };
TYPESCRIPT

# Create UI components index
create_file "app/frontend/components/ui/index.ts", <<~TYPESCRIPT
  export * from "./alert";
  export * from "./avatar";
  export * from "./badge";
  export * from "./button";
  export * from "./card";
  export * from "./input";
  export * from "./label";
  export * from "./separator";
  export * from "./skeleton";
TYPESCRIPT

# =============================================================================
# Create Application Entry Point
# =============================================================================

say "🚀 Creating application entry point...", :yellow

create_file "app/frontend/entrypoints/application.tsx", <<~TYPESCRIPT
  import { createInertiaApp } from "@inertiajs/react";
  import { createRoot } from "react-dom/client";
  import "../styles/application.css";

  const pages = import.meta.glob("../pages/**/*.tsx", { eager: true });

  createInertiaApp({
    resolve: (name) => {
      const page = pages[\`../pages/\${name}.tsx\`];
      if (!page) {
        throw new Error(\`Page not found: \${name}\`);
      }
      return page;
    },
    setup({ el, App, props }) {
      createRoot(el).render(<App {...props} />);
    },
  });
TYPESCRIPT

# =============================================================================
# Create Types
# =============================================================================

say "📝 Creating TypeScript types...", :yellow

create_file "app/frontend/types/index.ts", <<~TYPESCRIPT
  export interface User {
    id: number;
    email: string;
    created_at: string;
    updated_at: string;
  }

  export interface PageProps {
    auth: {
      user: User | null;
    };
    flash: {
      notice?: string;
      alert?: string;
    };
  }

  export interface PaginatedResponse<T> {
    data: T[];
    meta: {
      current_page: number;
      total_pages: number;
      total_count: number;
      per_page: number;
    };
  }
TYPESCRIPT

create_file "app/frontend/types/global.d.ts", <<~TYPESCRIPT
  /// <reference types="vite/client" />

  interface ImportMetaEnv {
    readonly VITE_APP_NAME: string;
  }

  interface ImportMeta {
    readonly env: ImportMetaEnv;
  }
TYPESCRIPT

# =============================================================================
# Create Layout Component
# =============================================================================

say "📐 Creating layout component...", :yellow

create_file "app/frontend/layouts/MainLayout.tsx", <<~TYPESCRIPT
  import { PropsWithChildren } from "react";
  import { Link, usePage } from "@inertiajs/react";
  import type { PageProps } from "@/types";

  interface MainLayoutProps extends PropsWithChildren {
    title?: string;
  }

  export default function MainLayout({ children, title }: MainLayoutProps) {
    const { auth, flash } = usePage<PageProps>().props;

    return (
      <div className="min-h-screen bg-background">
        <nav className="border-b">
          <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <div className="flex h-16 items-center justify-between">
              <div className="flex items-center">
                <Link href="/" className="text-xl font-bold">
                  #{app_name.titleize}
                </Link>
              </div>
              <div className="flex items-center gap-4">
                {auth?.user ? (
                  <>
                    <span className="text-sm text-muted-foreground">
                      {auth.user.email}
                    </span>
                    <Link
                      href="/users/sign_out"
                      method="delete"
                      as="button"
                      className="text-sm text-muted-foreground hover:text-foreground"
                    >
                      Sign Out
                    </Link>
                  </>
                ) : (
                  <>
                    <Link
                      href="/users/sign_in"
                      className="text-sm text-muted-foreground hover:text-foreground"
                    >
                      Sign In
                    </Link>
                    <Link
                      href="/users/sign_up"
                      className="text-sm text-muted-foreground hover:text-foreground"
                    >
                      Sign Up
                    </Link>
                  </>
                )}
              </div>
            </div>
          </div>
        </nav>

        {(flash?.notice || flash?.alert) && (
          <div className="mx-auto max-w-7xl px-4 py-4 sm:px-6 lg:px-8">
            {flash.notice && (
              <div className="rounded-md bg-green-50 p-4 text-green-800">
                {flash.notice}
              </div>
            )}
            {flash.alert && (
              <div className="rounded-md bg-red-50 p-4 text-red-800">
                {flash.alert}
              </div>
            )}
          </div>
        )}

        <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
          {title && (
            <h1 className="mb-8 text-3xl font-bold tracking-tight">{title}</h1>
          )}
          {children}
        </main>
      </div>
    );
  }
TYPESCRIPT

# =============================================================================
# Create Welcome Page
# =============================================================================

say "🏠 Creating Welcome page...", :yellow

create_file "app/frontend/pages/Welcome/Index.tsx", <<~TYPESCRIPT
  import { Head } from "@inertiajs/react";
  import MainLayout from "@/layouts/MainLayout";
  import { Button } from "@/components/ui/button";
  import {
    Card,
    CardContent,
    CardDescription,
    CardHeader,
    CardTitle,
  } from "@/components/ui/card";

  interface Props {
    rails_version: string;
    ruby_version: string;
  }

  export default function WelcomeIndex({ rails_version, ruby_version }: Props) {
    return (
      <MainLayout>
        <Head title="Welcome" />
        
        <div className="flex flex-col items-center justify-center py-12">
          <div className="mb-8 text-center">
            <h1 className="mb-4 text-5xl font-bold tracking-tight">
              Welcome to #{app_name.titleize}
            </h1>
            <p className="text-xl text-muted-foreground">
              Rails 8 + Inertia + React + TypeScript + Tailwind CSS v4
            </p>
          </div>

          <div className="grid gap-6 md:grid-cols-3">
            <Card>
              <CardHeader>
                <CardTitle>🚀 Rails {rails_version}</CardTitle>
                <CardDescription>Ruby {ruby_version}</CardDescription>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-muted-foreground">
                  Modern Rails with all the latest features and improvements.
                </p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>⚛️ React + TypeScript</CardTitle>
                <CardDescription>Inertia.js</CardDescription>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-muted-foreground">
                  Build modern SPAs without the complexity of a separate API.
                </p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>🎨 Tailwind CSS v4</CardTitle>
                <CardDescription>shadcn/ui</CardDescription>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-muted-foreground">
                  Beautiful, accessible components built with Radix UI.
                </p>
              </CardContent>
            </Card>
          </div>

          <div className="mt-12 flex gap-4">
            <Button size="lg">Get Started</Button>
            <Button variant="outline" size="lg">
              Documentation
            </Button>
          </div>
        </div>
      </MainLayout>
    );
  }
TYPESCRIPT

# =============================================================================
# Create Test Setup
# =============================================================================

say "🧪 Creating test setup...", :yellow

create_file "app/frontend/test/setupTests.ts", <<~TYPESCRIPT
  import "@testing-library/jest-dom";
TYPESCRIPT

create_file "app/frontend/test/test-utils.tsx", <<~TYPESCRIPT
  import { ReactElement } from "react";
  import { render, RenderOptions } from "@testing-library/react";
  import userEvent from "@testing-library/user-event";

  const AllTheProviders = ({ children }: { children: React.ReactNode }) => {
    return <>{children}</>;
  };

  const customRender = (
    ui: ReactElement,
    options?: Omit<RenderOptions, "wrapper">
  ) => render(ui, { wrapper: AllTheProviders, ...options });

  export * from "@testing-library/react";
  export { customRender as render, userEvent };
TYPESCRIPT

create_file "app/frontend/components/ui/__tests__/button.test.tsx", <<~TYPESCRIPT
  import { render, screen } from "@/test/test-utils";
  import { Button } from "../button";

  describe("Button", () => {
    it("renders correctly", () => {
      render(<Button>Click me</Button>);
      expect(screen.getByRole("button", { name: /click me/i })).toBeInTheDocument();
    });

    it("applies variant classes", () => {
      render(<Button variant="destructive">Delete</Button>);
      const button = screen.getByRole("button");
      expect(button).toHaveClass("bg-destructive");
    });

    it("applies size classes", () => {
      render(<Button size="lg">Large</Button>);
      const button = screen.getByRole("button");
      expect(button).toHaveClass("h-11");
    });

    it("can be disabled", () => {
      render(<Button disabled>Disabled</Button>);
      expect(screen.getByRole("button")).toBeDisabled();
    });
  });
TYPESCRIPT

# =============================================================================
# Configure RSpec
# =============================================================================

say "🔬 Configuring RSpec...", :yellow

generate "rspec:install"

# Configure RSpec
gsub_file "spec/rails_helper.rb",
          "# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }",
          "Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }"

run "mkdir -p spec/support"

create_file "spec/support/factory_bot.rb", <<~RUBY
  RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
  end
RUBY

create_file "spec/support/shoulda_matchers.rb", <<~RUBY
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
RUBY

create_file "spec/support/capybara.rb", <<~RUBY
  require "capybara/rspec"

  Capybara.register_driver :selenium_chrome_headless do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless=new")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--window-size=1920,1080")
    
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  Capybara.javascript_driver = :selenium_chrome_headless

  RSpec.configure do |config|
    config.before(:each, type: :system) do
      driven_by :selenium_chrome_headless
    end
  end
RUBY

create_file "spec/support/inertia.rb", <<~RUBY
  RSpec.configure do |config|
    config.before(:each, type: :request) do
      # Set Inertia headers for request specs
    end
  end

  module InertiaTestHelpers
    def inertia_props
      if response.media_type == "application/json"
        JSON.parse(response.body)["props"]
      else
        # Extract props from the page div
        match = response.body.match(/data-page="([^"]+)"/)
        return {} unless match
        
        JSON.parse(CGI.unescapeHTML(match[1]))["props"]
      end
    end

    def inertia_component
      if response.media_type == "application/json"
        JSON.parse(response.body)["component"]
      else
        match = response.body.match(/data-page="([^"]+)"/)
        return nil unless match
        
        JSON.parse(CGI.unescapeHTML(match[1]))["component"]
      end
    end
  end

  RSpec.configure do |config|
    config.include InertiaTestHelpers, type: :request
  end
RUBY

# =============================================================================
# Install Devise
# =============================================================================

say "🔐 Installing Devise...", :yellow

generate "devise:install"
generate "devise User"

# Configure Devise for Inertia
gsub_file "config/initializers/devise.rb",
          "# config.navigational_formats = ['*/*', :html, :turbo_stream]",
          "config.navigational_formats = []"

# =============================================================================
# Create Devise Inertia Pages
# =============================================================================

say "🔐 Creating Devise Inertia pages...", :yellow

# Sessions (Login)
create_file "app/frontend/pages/Auth/Login.tsx", <<~TYPESCRIPT
  import { Head, useForm, Link } from "@inertiajs/react";
  import MainLayout from "@/layouts/MainLayout";
  import { Button } from "@/components/ui/button";
  import { Input } from "@/components/ui/input";
  import { Label } from "@/components/ui/label";
  import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
  } from "@/components/ui/card";

  export default function Login() {
    const { data, setData, post, processing, errors } = useForm({
      email: "",
      password: "",
      remember: false,
    });

    const handleSubmit = (e: React.FormEvent) => {
      e.preventDefault();
      post("/users/sign_in");
    };

    return (
      <MainLayout>
        <Head title="Sign In" />
        
        <div className="flex min-h-[60vh] items-center justify-center">
          <Card className="w-full max-w-md">
            <CardHeader>
              <CardTitle>Sign In</CardTitle>
              <CardDescription>
                Enter your credentials to access your account
              </CardDescription>
            </CardHeader>
            <form onSubmit={handleSubmit}>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="email">Email</Label>
                  <Input
                    id="email"
                    type="email"
                    value={data.email}
                    onChange={(e) => setData("email", e.target.value)}
                    placeholder="you@example.com"
                    autoComplete="email"
                    required
                  />
                  {errors.email && (
                    <p className="text-sm text-destructive">{errors.email}</p>
                  )}
                </div>
                
                <div className="space-y-2">
                  <Label htmlFor="password">Password</Label>
                  <Input
                    id="password"
                    type="password"
                    value={data.password}
                    onChange={(e) => setData("password", e.target.value)}
                    autoComplete="current-password"
                    required
                  />
                  {errors.password && (
                    <p className="text-sm text-destructive">{errors.password}</p>
                  )}
                </div>

                <div className="flex items-center space-x-2">
                  <input
                    type="checkbox"
                    id="remember"
                    checked={data.remember}
                    onChange={(e) => setData("remember", e.target.checked)}
                    className="rounded border-input"
                  />
                  <Label htmlFor="remember" className="text-sm font-normal">
                    Remember me
                  </Label>
                </div>
              </CardContent>
              
              <CardFooter className="flex flex-col gap-4">
                <Button type="submit" className="w-full" disabled={processing}>
                  {processing ? "Signing in..." : "Sign In"}
                </Button>
                <div className="flex justify-between text-sm">
                  <Link
                    href="/users/sign_up"
                    className="text-muted-foreground hover:text-foreground"
                  >
                    Create account
                  </Link>
                  <Link
                    href="/users/password/new"
                    className="text-muted-foreground hover:text-foreground"
                  >
                    Forgot password?
                  </Link>
                </div>
              </CardFooter>
            </form>
          </Card>
        </div>
      </MainLayout>
    );
  }
TYPESCRIPT

# Registration (Sign Up)
create_file "app/frontend/pages/Auth/Register.tsx", <<~TYPESCRIPT
  import { Head, useForm, Link } from "@inertiajs/react";
  import MainLayout from "@/layouts/MainLayout";
  import { Button } from "@/components/ui/button";
  import { Input } from "@/components/ui/input";
  import { Label } from "@/components/ui/label";
  import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
  } from "@/components/ui/card";

  export default function Register() {
    const { data, setData, post, processing, errors } = useForm({
      email: "",
      password: "",
      password_confirmation: "",
    });

    const handleSubmit = (e: React.FormEvent) => {
      e.preventDefault();
      post("/users");
    };

    return (
      <MainLayout>
        <Head title="Sign Up" />
        
        <div className="flex min-h-[60vh] items-center justify-center">
          <Card className="w-full max-w-md">
            <CardHeader>
              <CardTitle>Create Account</CardTitle>
              <CardDescription>
                Enter your details to create a new account
              </CardDescription>
            </CardHeader>
            <form onSubmit={handleSubmit}>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="email">Email</Label>
                  <Input
                    id="email"
                    type="email"
                    value={data.email}
                    onChange={(e) => setData("email", e.target.value)}
                    placeholder="you@example.com"
                    autoComplete="email"
                    required
                  />
                  {errors.email && (
                    <p className="text-sm text-destructive">{errors.email}</p>
                  )}
                </div>
                
                <div className="space-y-2">
                  <Label htmlFor="password">Password</Label>
                  <Input
                    id="password"
                    type="password"
                    value={data.password}
                    onChange={(e) => setData("password", e.target.value)}
                    autoComplete="new-password"
                    required
                  />
                  {errors.password && (
                    <p className="text-sm text-destructive">{errors.password}</p>
                  )}
                </div>

                <div className="space-y-2">
                  <Label htmlFor="password_confirmation">Confirm Password</Label>
                  <Input
                    id="password_confirmation"
                    type="password"
                    value={data.password_confirmation}
                    onChange={(e) => setData("password_confirmation", e.target.value)}
                    autoComplete="new-password"
                    required
                  />
                  {errors.password_confirmation && (
                    <p className="text-sm text-destructive">
                      {errors.password_confirmation}
                    </p>
                  )}
                </div>
              </CardContent>
              
              <CardFooter className="flex flex-col gap-4">
                <Button type="submit" className="w-full" disabled={processing}>
                  {processing ? "Creating account..." : "Create Account"}
                </Button>
                <p className="text-center text-sm text-muted-foreground">
                  Already have an account?{" "}
                  <Link
                    href="/users/sign_in"
                    className="text-foreground hover:underline"
                  >
                    Sign in
                  </Link>
                </p>
              </CardFooter>
            </form>
          </Card>
        </div>
      </MainLayout>
    );
  }
TYPESCRIPT

# Password Reset Request
create_file "app/frontend/pages/Auth/ForgotPassword.tsx", <<~TYPESCRIPT
  import { Head, useForm, Link } from "@inertiajs/react";
  import MainLayout from "@/layouts/MainLayout";
  import { Button } from "@/components/ui/button";
  import { Input } from "@/components/ui/input";
  import { Label } from "@/components/ui/label";
  import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
  } from "@/components/ui/card";

  export default function ForgotPassword() {
    const { data, setData, post, processing, errors } = useForm({
      email: "",
    });

    const handleSubmit = (e: React.FormEvent) => {
      e.preventDefault();
      post("/users/password");
    };

    return (
      <MainLayout>
        <Head title="Forgot Password" />
        
        <div className="flex min-h-[60vh] items-center justify-center">
          <Card className="w-full max-w-md">
            <CardHeader>
              <CardTitle>Reset Password</CardTitle>
              <CardDescription>
                Enter your email and we'll send you a reset link
              </CardDescription>
            </CardHeader>
            <form onSubmit={handleSubmit}>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="email">Email</Label>
                  <Input
                    id="email"
                    type="email"
                    value={data.email}
                    onChange={(e) => setData("email", e.target.value)}
                    placeholder="you@example.com"
                    autoComplete="email"
                    required
                  />
                  {errors.email && (
                    <p className="text-sm text-destructive">{errors.email}</p>
                  )}
                </div>
              </CardContent>
              
              <CardFooter className="flex flex-col gap-4">
                <Button type="submit" className="w-full" disabled={processing}>
                  {processing ? "Sending..." : "Send Reset Link"}
                </Button>
                <Link
                  href="/users/sign_in"
                  className="text-center text-sm text-muted-foreground hover:text-foreground"
                >
                  Back to sign in
                </Link>
              </CardFooter>
            </form>
          </Card>
        </div>
      </MainLayout>
    );
  }
TYPESCRIPT

# Password Reset Form
create_file "app/frontend/pages/Auth/ResetPassword.tsx", <<~TYPESCRIPT
  import { Head, useForm } from "@inertiajs/react";
  import MainLayout from "@/layouts/MainLayout";
  import { Button } from "@/components/ui/button";
  import { Input } from "@/components/ui/input";
  import { Label } from "@/components/ui/label";
  import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
  } from "@/components/ui/card";

  interface Props {
    reset_password_token: string;
  }

  export default function ResetPassword({ reset_password_token }: Props) {
    const { data, setData, put, processing, errors } = useForm({
      reset_password_token,
      password: "",
      password_confirmation: "",
    });

    const handleSubmit = (e: React.FormEvent) => {
      e.preventDefault();
      put("/users/password");
    };

    return (
      <MainLayout>
        <Head title="Reset Password" />
        
        <div className="flex min-h-[60vh] items-center justify-center">
          <Card className="w-full max-w-md">
            <CardHeader>
              <CardTitle>Set New Password</CardTitle>
              <CardDescription>
                Enter your new password below
              </CardDescription>
            </CardHeader>
            <form onSubmit={handleSubmit}>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="password">New Password</Label>
                  <Input
                    id="password"
                    type="password"
                    value={data.password}
                    onChange={(e) => setData("password", e.target.value)}
                    autoComplete="new-password"
                    required
                  />
                  {errors.password && (
                    <p className="text-sm text-destructive">{errors.password}</p>
                  )}
                </div>

                <div className="space-y-2">
                  <Label htmlFor="password_confirmation">Confirm Password</Label>
                  <Input
                    id="password_confirmation"
                    type="password"
                    value={data.password_confirmation}
                    onChange={(e) => setData("password_confirmation", e.target.value)}
                    autoComplete="new-password"
                    required
                  />
                  {errors.password_confirmation && (
                    <p className="text-sm text-destructive">
                      {errors.password_confirmation}
                    </p>
                  )}
                </div>
              </CardContent>
              
              <CardFooter>
                <Button type="submit" className="w-full" disabled={processing}>
                  {processing ? "Updating..." : "Update Password"}
                </Button>
              </CardFooter>
            </form>
          </Card>
        </div>
      </MainLayout>
    );
  }
TYPESCRIPT

# =============================================================================
# Create Custom Devise Controllers for Inertia
# =============================================================================

say "🔐 Creating Devise Inertia controllers...", :yellow

run "mkdir -p app/controllers/users"

create_file "app/controllers/users/sessions_controller.rb", <<~RUBY
  # frozen_string_literal: true

  class Users::SessionsController < Devise::SessionsController
    def new
      render inertia: "Auth/Login"
    end

    def create
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      
      respond_to do |format|
        format.html { redirect_to after_sign_in_path_for(resource) }
        format.json { render json: { redirect_to: after_sign_in_path_for(resource) } }
      end
    end

    def destroy
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      
      respond_to do |format|
        format.html { redirect_to after_sign_out_path_for(resource_name) }
        format.json { render json: { redirect_to: after_sign_out_path_for(resource_name) } }
      end
    end

    protected

    def auth_options
      { scope: resource_name, recall: "\#{controller_path}#new" }
    end
  end
RUBY

create_file "app/controllers/users/registrations_controller.rb", <<~RUBY
  # frozen_string_literal: true

  class Users::RegistrationsController < Devise::RegistrationsController
    def new
      render inertia: "Auth/Register"
    end

    def create
      build_resource(sign_up_params)

      resource.save
      
      if resource.persisted?
        sign_up(resource_name, resource)
        redirect_to after_sign_up_path_for(resource)
      else
        clean_up_passwords resource
        set_minimum_password_length
        redirect_to new_user_registration_path, inertia: { errors: resource.errors.to_hash }
      end
    end
  end
RUBY

create_file "app/controllers/users/passwords_controller.rb", <<~RUBY
  # frozen_string_literal: true

  class Users::PasswordsController < Devise::PasswordsController
    def new
      render inertia: "Auth/ForgotPassword"
    end

    def edit
      render inertia: "Auth/ResetPassword", props: {
        reset_password_token: params[:reset_password_token]
      }
    end

    def create
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      
      if successfully_sent?(resource)
        redirect_to new_user_session_path, notice: "Password reset instructions sent"
      else
        redirect_to new_user_password_path, inertia: { errors: resource.errors.to_hash }
      end
    end

    def update
      self.resource = resource_class.reset_password_by_token(resource_params)
      
      if resource.errors.empty?
        sign_in(resource_name, resource)
        redirect_to root_path, notice: "Password updated successfully"
      else
        redirect_to edit_user_password_path(reset_password_token: params[:user][:reset_password_token]),
                    inertia: { errors: resource.errors.to_hash }
      end
    end
  end
RUBY

# =============================================================================
# Install Pundit
# =============================================================================

say "🛡️ Installing Pundit...", :yellow

generate "pundit:install"

# Add Pundit to ApplicationController
inject_into_class "app/controllers/application_controller.rb", "ApplicationController", <<~RUBY
    include Pundit::Authorization
    
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_back(fallback_location: root_path)
    end
RUBY

# =============================================================================
# Create Welcome Controller
# =============================================================================

say "🏠 Creating Welcome controller...", :yellow

create_file "app/controllers/welcome_controller.rb", <<~RUBY
  # frozen_string_literal: true

  class WelcomeController < ApplicationController
    def index
      render inertia: "Welcome/Index", props: {
        rails_version: Rails.version,
        ruby_version: RUBY_VERSION
      }
    end
  end
RUBY

# =============================================================================
# Configure Inertia
# =============================================================================

say "⚙️ Configuring Inertia...", :yellow

create_file "config/initializers/inertia_rails.rb", <<~RUBY
  # frozen_string_literal: true

  InertiaRails.configure do |config|
    config.version = ViteRuby.digest
    
    # Share data with all Inertia responses
    config.shared_data = lambda do |controller|
      {
        auth: {
          user: controller.current_user&.as_json(only: [:id, :email, :created_at])
        },
        flash: {
          notice: controller.flash[:notice],
          alert: controller.flash[:alert]
        }
      }
    end
  end
RUBY

# =============================================================================
# Create Application Layout
# =============================================================================

say "📄 Creating application layout...", :yellow

gsub_file "app/views/layouts/application.html.erb",
          /<%= stylesheet_link_tag.*%>/,
          '<%= vite_stylesheet_tag "application.css" %>'

gsub_file "app/views/layouts/application.html.erb",
          /<%= javascript_importmap_tags %>/,
          '<%= vite_typescript_tag "application.tsx" %>'

gsub_file "app/views/layouts/application.html.erb",
          /<%= yield %>/,
          '<%= yield %>'

# Create inertia layout
create_file "app/views/layouts/inertia.html.erb", <<~ERB
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <%= csrf_meta_tags %>
      <%= csp_meta_tag %>
      
      <%= vite_client_tag %>
      <%= vite_stylesheet_tag "styles/application.css", data: { "turbo-track": "reload" } %>
      <%= vite_typescript_tag "entrypoints/application.tsx" %>
      
      <% if content_for?(:head) %>
        <%= yield :head %>
      <% end %>
    </head>
    <body>
      <%= yield %>
    </body>
  </html>
ERB

# Configure ApplicationController to use inertia layout
inject_into_class "app/controllers/application_controller.rb", "ApplicationController", <<~RUBY
    layout "inertia"
RUBY

# =============================================================================
# Configure Routes
# =============================================================================

say "🛣️ Configuring routes...", :yellow

gsub_file "config/routes.rb", /Rails.application.routes.draw do.*end/m, <<~RUBY
  Rails.application.routes.draw do
    devise_for :users, controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords"
    }

    root "welcome#index"

    # Health check
    get "up" => "rails/health#show", as: :rails_health_check

    # PWA routes
    get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
    get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  end
RUBY

# =============================================================================
# Create .claude Directory
# =============================================================================

say "🤖 Creating .claude directory...", :yellow

run "mkdir -p .claude/plans"

create_file ".claude/plans/README.md", <<~MARKDOWN
  # Claude Plans

  This directory contains planning documents for Claude to understand project architecture
  and development patterns.

  ## Directory Structure

  - `features/` - Feature planning documents
  - `architecture/` - System architecture documentation
  - `migrations/` - Database migration plans
MARKDOWN

create_file ".claude/plans/project-overview.md", <<~MARKDOWN
  # Project Overview: #{app_name.titleize}

  ## Tech Stack

  ### Backend
  - **Framework**: Rails 8
  - **Database**: SQLite (development) / PostgreSQL (production)
  - **Authentication**: Devise
  - **Authorization**: Pundit
  - **API Style**: Inertia.js (server-side routing)

  ### Frontend
  - **Framework**: React 18+
  - **Language**: TypeScript
  - **Build Tool**: Vite
  - **Styling**: Tailwind CSS v4
  - **UI Components**: shadcn/ui (Radix UI primitives)
  - **State Management**: React hooks + Inertia.js

  ### Testing
  - **Ruby Tests**: RSpec, FactoryBot, Capybara, Shoulda Matchers
  - **JavaScript Tests**: Jest, Testing Library

  ## Directory Structure

  ```
  app/
  ├── controllers/           # Rails controllers
  ├── models/               # ActiveRecord models
  ├── policies/             # Pundit authorization policies
  ├── views/
  │   └── layouts/          # Application layouts
  └── frontend/
      ├── components/       # React components
      │   └── ui/          # shadcn/ui components
      ├── entrypoints/     # Vite entry points
      ├── hooks/           # Custom React hooks
      ├── layouts/         # Page layouts
      ├── lib/             # Utility functions
      ├── pages/           # Inertia page components
      ├── styles/          # CSS files
      ├── test/            # Frontend tests
      └── types/           # TypeScript type definitions
  ```

  ## Key Patterns

  ### Inertia.js Pages
  - Pages are React components in `app/frontend/pages/`
  - Rendered via `render inertia: "PageName"` in controllers
  - Props passed from controller available as component props

  ### Authentication Flow
  - Devise handles user model and session management
  - Custom controllers render Inertia pages
  - Current user available via shared data in all pages

  ### Authorization
  - Pundit policies in `app/policies/`
  - Include `Pundit::Authorization` in controllers
  - Use `authorize @resource` before actions

  ### Component Architecture
  - Base UI components from shadcn/ui in `components/ui/`
  - Compose into feature components
  - Use `cn()` utility for class merging
MARKDOWN

# =============================================================================
# Create CLAUDE.md
# =============================================================================

say "📝 Creating CLAUDE.md...", :yellow

create_file "CLAUDE.md", <<~MARKDOWN
  # #{app_name.titleize}

  ## Project Overview

  A modern Rails 8 application with React frontend using Inertia.js for seamless
  SPA-like navigation without building a separate API.

  ## Quick Reference

  ### Commands

  ```bash
  # Development
  bin/dev                    # Start Rails + Vite dev servers
  rails s                    # Start Rails server only
  npm run dev                # Start Vite dev server only

  # Testing
  bundle exec rspec          # Run Ruby tests
  npm test                   # Run JavaScript tests
  npm run test:watch         # Run JS tests in watch mode

  # Code Quality
  bundle exec rubocop        # Ruby linting
  npm run lint               # TypeScript/React linting
  npm run typecheck          # TypeScript type checking

  # Database
  rails db:migrate           # Run migrations
  rails db:seed              # Seed database
  rails db:reset             # Drop, create, migrate, seed
  ```

  ### File Locations

  | What | Where |
  |------|-------|
  | React pages | `app/frontend/pages/` |
  | UI components | `app/frontend/components/ui/` |
  | Layouts | `app/frontend/layouts/` |
  | Rails controllers | `app/controllers/` |
  | Pundit policies | `app/policies/` |
  | RSpec tests | `spec/` |
  | Jest tests | `app/frontend/**/__tests__/` |

  ### Creating New Features

  1. **New Inertia Page**
     ```bash
     # Create controller
     rails g controller Features index show

     # Create React page
     # app/frontend/pages/Features/Index.tsx
     ```

  2. **New Model with Policy**
     ```bash
     rails g model Feature name:string
     rails g pundit:policy Feature
     ```

  3. **New UI Component**
     - Add to `app/frontend/components/ui/`
     - Export from `app/frontend/components/ui/index.ts`

  ### Environment Variables

  ```bash
  # .env.development
  DATABASE_URL=              # Database connection (optional for SQLite)
  RAILS_ENV=development
  ```

  ### Authentication

  - Uses Devise with custom Inertia controllers
  - Current user available as `auth.user` in page props
  - Protect routes with `before_action :authenticate_user!`

  ### Authorization

  - Uses Pundit for policy-based authorization
  - Policies in `app/policies/`
  - Use `authorize @resource` in controllers

  ## Architecture Decisions

  1. **Inertia.js over traditional API**: Eliminates need for separate frontend
     routing and API serialization layer.

  2. **Tailwind CSS v4**: Uses the new CSS-based configuration for better
     performance and simpler setup.

  3. **shadcn/ui**: Not a component library but a collection of reusable
     components you own and customize.

  4. **TypeScript**: Full type safety across the frontend codebase.
MARKDOWN

# =============================================================================
# Create bin/dev
# =============================================================================

say "🔧 Creating bin/dev...", :yellow

create_file "Procfile.dev", <<~PROCFILE
  web: bin/rails server -p 3000
  vite: bin/vite dev
PROCFILE

create_file "bin/dev", <<~BASH
  #!/usr/bin/env bash

  if ! gem list foreman -i --silent; then
    echo "Installing foreman..."
    gem install foreman
  fi

  exec foreman start -f Procfile.dev "$@"
BASH

run "chmod +x bin/dev"

# =============================================================================
# Create .env files
# =============================================================================

say "📝 Creating environment files...", :yellow

create_file ".env.development", <<~ENV
  # Development environment variables
  RAILS_ENV=development
ENV

create_file ".env.test", <<~ENV
  # Test environment variables
  RAILS_ENV=test
ENV

create_file ".env.example", <<~ENV
  # Copy this file to .env.development and .env.test
  RAILS_ENV=development
ENV

# Update .gitignore
append_file ".gitignore", <<~GITIGNORE

  # Environment files
  .env
  .env.development
  .env.test
  .env.production

  # Node modules
  node_modules/

  # Vite
  public/vite/
  public/vite-dev/
  public/vite-test/

  # Coverage
  coverage/

  # Claude
  .claude/scratchpad.md
GITIGNORE

# =============================================================================
# Final Setup
# =============================================================================

say "🏁 Running final setup...", :yellow

# Run migrations
rails_command "db:migrate"

# Generate annotate config
run "bundle exec rails g annotate:install" rescue nil

# =============================================================================
# Done!
# =============================================================================

say ""
say "=" * 70, :green
say "🎉 Your Rails application is ready!", :green
say "=" * 70, :green
say ""
say "Next steps:", :yellow
say ""
say "  cd #{app_name}"
say "  bin/dev"
say ""
say "Your app will be running at http://localhost:3000", :cyan
say ""
say "Features included:", :yellow
say "  ✅ Rails 8"
say "  ✅ Tailwind CSS v4"
say "  ✅ Inertia.js + Vite + TypeScript + React"
say "  ✅ shadcn/ui components"
say "  ✅ Jest for frontend testing"
say "  ✅ RSpec + Capybara + FactoryBot for Rails testing"
say "  ✅ Welcome page with Inertia"
say "  ✅ Devise authentication with Inertia pages"
say "  ✅ Pundit authorization"
say "  ✅ .claude/plans directory"
say "  ✅ CLAUDE.md"
say ""
