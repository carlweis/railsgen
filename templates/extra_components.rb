# This file contains additional shadcn/ui components that can be added to the template
# These are stored as a reference and can be injected into the main template.rb

SHADCN_COMPONENTS = {
  "dialog" => <<~TYPESCRIPT,
    import * as React from "react";
    import * as DialogPrimitive from "@radix-ui/react-dialog";
    import { X } from "lucide-react";
    import { cn } from "@/lib/utils";

    const Dialog = DialogPrimitive.Root;
    const DialogTrigger = DialogPrimitive.Trigger;
    const DialogPortal = DialogPrimitive.Portal;
    const DialogClose = DialogPrimitive.Close;

    const DialogOverlay = React.forwardRef<
      React.ElementRef<typeof DialogPrimitive.Overlay>,
      React.ComponentPropsWithoutRef<typeof DialogPrimitive.Overlay>
    >(({ className, ...props }, ref) => (
      <DialogPrimitive.Overlay
        ref={ref}
        className={cn(
          "fixed inset-0 z-50 bg-black/80 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
          className
        )}
        {...props}
      />
    ));
    DialogOverlay.displayName = DialogPrimitive.Overlay.displayName;

    const DialogContent = React.forwardRef<
      React.ElementRef<typeof DialogPrimitive.Content>,
      React.ComponentPropsWithoutRef<typeof DialogPrimitive.Content>
    >(({ className, children, ...props }, ref) => (
      <DialogPortal>
        <DialogOverlay />
        <DialogPrimitive.Content
          ref={ref}
          className={cn(
            "fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg duration-200 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%] data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%] sm:rounded-lg",
            className
          )}
          {...props}
        >
          {children}
          <DialogPrimitive.Close className="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground">
            <X className="h-4 w-4" />
            <span className="sr-only">Close</span>
          </DialogPrimitive.Close>
        </DialogPrimitive.Content>
      </DialogPortal>
    ));
    DialogContent.displayName = DialogPrimitive.Content.displayName;

    const DialogHeader = ({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) => (
      <div className={cn("flex flex-col space-y-1.5 text-center sm:text-left", className)} {...props} />
    );
    DialogHeader.displayName = "DialogHeader";

    const DialogFooter = ({ className, ...props }: React.HTMLAttributes<HTMLDivElement>) => (
      <div className={cn("flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2", className)} {...props} />
    );
    DialogFooter.displayName = "DialogFooter";

    const DialogTitle = React.forwardRef<
      React.ElementRef<typeof DialogPrimitive.Title>,
      React.ComponentPropsWithoutRef<typeof DialogPrimitive.Title>
    >(({ className, ...props }, ref) => (
      <DialogPrimitive.Title
        ref={ref}
        className={cn("text-lg font-semibold leading-none tracking-tight", className)}
        {...props}
      />
    ));
    DialogTitle.displayName = DialogPrimitive.Title.displayName;

    const DialogDescription = React.forwardRef<
      React.ElementRef<typeof DialogPrimitive.Description>,
      React.ComponentPropsWithoutRef<typeof DialogPrimitive.Description>
    >(({ className, ...props }, ref) => (
      <DialogPrimitive.Description
        ref={ref}
        className={cn("text-sm text-muted-foreground", className)}
        {...props}
      />
    ));
    DialogDescription.displayName = DialogPrimitive.Description.displayName;

    export {
      Dialog,
      DialogPortal,
      DialogOverlay,
      DialogClose,
      DialogTrigger,
      DialogContent,
      DialogHeader,
      DialogFooter,
      DialogTitle,
      DialogDescription,
    };
  TYPESCRIPT

  "dropdown-menu" => <<~TYPESCRIPT,
    import * as React from "react";
    import * as DropdownMenuPrimitive from "@radix-ui/react-dropdown-menu";
    import { Check, ChevronRight, Circle } from "lucide-react";
    import { cn } from "@/lib/utils";

    const DropdownMenu = DropdownMenuPrimitive.Root;
    const DropdownMenuTrigger = DropdownMenuPrimitive.Trigger;
    const DropdownMenuGroup = DropdownMenuPrimitive.Group;
    const DropdownMenuPortal = DropdownMenuPrimitive.Portal;
    const DropdownMenuSub = DropdownMenuPrimitive.Sub;
    const DropdownMenuRadioGroup = DropdownMenuPrimitive.RadioGroup;

    const DropdownMenuSubTrigger = React.forwardRef<
      React.ElementRef<typeof DropdownMenuPrimitive.SubTrigger>,
      React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.SubTrigger> & { inset?: boolean }
    >(({ className, inset, children, ...props }, ref) => (
      <DropdownMenuPrimitive.SubTrigger
        ref={ref}
        className={cn(
          "flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent data-[state=open]:bg-accent",
          inset && "pl-8",
          className
        )}
        {...props}
      >
        {children}
        <ChevronRight className="ml-auto h-4 w-4" />
      </DropdownMenuPrimitive.SubTrigger>
    ));
    DropdownMenuSubTrigger.displayName = DropdownMenuPrimitive.SubTrigger.displayName;

    const DropdownMenuSubContent = React.forwardRef<
      React.ElementRef<typeof DropdownMenuPrimitive.SubContent>,
      React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.SubContent>
    >(({ className, ...props }, ref) => (
      <DropdownMenuPrimitive.SubContent
        ref={ref}
        className={cn(
          "z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
          className
        )}
        {...props}
      />
    ));
    DropdownMenuSubContent.displayName = DropdownMenuPrimitive.SubContent.displayName;

    const DropdownMenuContent = React.forwardRef<
      React.ElementRef<typeof DropdownMenuPrimitive.Content>,
      React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.Content>
    >(({ className, sideOffset = 4, ...props }, ref) => (
      <DropdownMenuPrimitive.Portal>
        <DropdownMenuPrimitive.Content
          ref={ref}
          sideOffset={sideOffset}
          className={cn(
            "z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
            className
          )}
          {...props}
        />
      </DropdownMenuPrimitive.Portal>
    ));
    DropdownMenuContent.displayName = DropdownMenuPrimitive.Content.displayName;

    const DropdownMenuItem = React.forwardRef<
      React.ElementRef<typeof DropdownMenuPrimitive.Item>,
      React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.Item> & { inset?: boolean }
    >(({ className, inset, ...props }, ref) => (
      <DropdownMenuPrimitive.Item
        ref={ref}
        className={cn(
          "relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
          inset && "pl-8",
          className
        )}
        {...props}
      />
    ));
    DropdownMenuItem.displayName = DropdownMenuPrimitive.Item.displayName;

    const DropdownMenuCheckboxItem = React.forwardRef<
      React.ElementRef<typeof DropdownMenuPrimitive.CheckboxItem>,
      React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.CheckboxItem>
    >(({ className, children, checked, ...props }, ref) => (
      <DropdownMenuPrimitive.CheckboxItem
        ref={ref}
        className={cn(
          "relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
          className
        )}
        checked={checked}
        {...props}
      >
        <span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
          <DropdownMenuPrimitive.ItemIndicator>
            <Check className="h-4 w-4" />
          </DropdownMenuPrimitive.ItemIndicator>
        </span>
        {children}
      </DropdownMenuPrimitive.CheckboxItem>
    ));
    DropdownMenuCheckboxItem.displayName = DropdownMenuPrimitive.CheckboxItem.displayName;

    const DropdownMenuRadioItem = React.forwardRef<
      React.ElementRef<typeof DropdownMenuPrimitive.RadioItem>,
      React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.RadioItem>
    >(({ className, children, ...props }, ref) => (
      <DropdownMenuPrimitive.RadioItem
        ref={ref}
        className={cn(
          "relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
          className
        )}
        {...props}
      >
        <span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
          <DropdownMenuPrimitive.ItemIndicator>
            <Circle className="h-2 w-2 fill-current" />
          </DropdownMenuPrimitive.ItemIndicator>
        </span>
        {children}
      </DropdownMenuPrimitive.RadioItem>
    ));
    DropdownMenuRadioItem.displayName = DropdownMenuPrimitive.RadioItem.displayName;

    const DropdownMenuLabel = React.forwardRef<
      React.ElementRef<typeof DropdownMenuPrimitive.Label>,
      React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.Label> & { inset?: boolean }
    >(({ className, inset, ...props }, ref) => (
      <DropdownMenuPrimitive.Label
        ref={ref}
        className={cn("px-2 py-1.5 text-sm font-semibold", inset && "pl-8", className)}
        {...props}
      />
    ));
    DropdownMenuLabel.displayName = DropdownMenuPrimitive.Label.displayName;

    const DropdownMenuSeparator = React.forwardRef<
      React.ElementRef<typeof DropdownMenuPrimitive.Separator>,
      React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.Separator>
    >(({ className, ...props }, ref) => (
      <DropdownMenuPrimitive.Separator
        ref={ref}
        className={cn("-mx-1 my-1 h-px bg-muted", className)}
        {...props}
      />
    ));
    DropdownMenuSeparator.displayName = DropdownMenuPrimitive.Separator.displayName;

    const DropdownMenuShortcut = ({ className, ...props }: React.HTMLAttributes<HTMLSpanElement>) => {
      return <span className={cn("ml-auto text-xs tracking-widest opacity-60", className)} {...props} />;
    };
    DropdownMenuShortcut.displayName = "DropdownMenuShortcut";

    export {
      DropdownMenu,
      DropdownMenuTrigger,
      DropdownMenuContent,
      DropdownMenuItem,
      DropdownMenuCheckboxItem,
      DropdownMenuRadioItem,
      DropdownMenuLabel,
      DropdownMenuSeparator,
      DropdownMenuShortcut,
      DropdownMenuGroup,
      DropdownMenuPortal,
      DropdownMenuSub,
      DropdownMenuSubContent,
      DropdownMenuSubTrigger,
      DropdownMenuRadioGroup,
    };
  TYPESCRIPT

  "select" => <<~TYPESCRIPT,
    import * as React from "react";
    import * as SelectPrimitive from "@radix-ui/react-select";
    import { Check, ChevronDown, ChevronUp } from "lucide-react";
    import { cn } from "@/lib/utils";

    const Select = SelectPrimitive.Root;
    const SelectGroup = SelectPrimitive.Group;
    const SelectValue = SelectPrimitive.Value;

    const SelectTrigger = React.forwardRef<
      React.ElementRef<typeof SelectPrimitive.Trigger>,
      React.ComponentPropsWithoutRef<typeof SelectPrimitive.Trigger>
    >(({ className, children, ...props }, ref) => (
      <SelectPrimitive.Trigger
        ref={ref}
        className={cn(
          "flex h-10 w-full items-center justify-between rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 [&>span]:line-clamp-1",
          className
        )}
        {...props}
      >
        {children}
        <SelectPrimitive.Icon asChild>
          <ChevronDown className="h-4 w-4 opacity-50" />
        </SelectPrimitive.Icon>
      </SelectPrimitive.Trigger>
    ));
    SelectTrigger.displayName = SelectPrimitive.Trigger.displayName;

    const SelectScrollUpButton = React.forwardRef<
      React.ElementRef<typeof SelectPrimitive.ScrollUpButton>,
      React.ComponentPropsWithoutRef<typeof SelectPrimitive.ScrollUpButton>
    >(({ className, ...props }, ref) => (
      <SelectPrimitive.ScrollUpButton
        ref={ref}
        className={cn("flex cursor-default items-center justify-center py-1", className)}
        {...props}
      >
        <ChevronUp className="h-4 w-4" />
      </SelectPrimitive.ScrollUpButton>
    ));
    SelectScrollUpButton.displayName = SelectPrimitive.ScrollUpButton.displayName;

    const SelectScrollDownButton = React.forwardRef<
      React.ElementRef<typeof SelectPrimitive.ScrollDownButton>,
      React.ComponentPropsWithoutRef<typeof SelectPrimitive.ScrollDownButton>
    >(({ className, ...props }, ref) => (
      <SelectPrimitive.ScrollDownButton
        ref={ref}
        className={cn("flex cursor-default items-center justify-center py-1", className)}
        {...props}
      >
        <ChevronDown className="h-4 w-4" />
      </SelectPrimitive.ScrollDownButton>
    ));
    SelectScrollDownButton.displayName = SelectPrimitive.ScrollDownButton.displayName;

    const SelectContent = React.forwardRef<
      React.ElementRef<typeof SelectPrimitive.Content>,
      React.ComponentPropsWithoutRef<typeof SelectPrimitive.Content>
    >(({ className, children, position = "popper", ...props }, ref) => (
      <SelectPrimitive.Portal>
        <SelectPrimitive.Content
          ref={ref}
          className={cn(
            "relative z-50 max-h-96 min-w-[8rem] overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
            position === "popper" &&
              "data-[side=bottom]:translate-y-1 data-[side=left]:-translate-x-1 data-[side=right]:translate-x-1 data-[side=top]:-translate-y-1",
            className
          )}
          position={position}
          {...props}
        >
          <SelectScrollUpButton />
          <SelectPrimitive.Viewport
            className={cn(
              "p-1",
              position === "popper" &&
                "h-[var(--radix-select-trigger-height)] w-full min-w-[var(--radix-select-trigger-width)]"
            )}
          >
            {children}
          </SelectPrimitive.Viewport>
          <SelectScrollDownButton />
        </SelectPrimitive.Content>
      </SelectPrimitive.Portal>
    ));
    SelectContent.displayName = SelectPrimitive.Content.displayName;

    const SelectLabel = React.forwardRef<
      React.ElementRef<typeof SelectPrimitive.Label>,
      React.ComponentPropsWithoutRef<typeof SelectPrimitive.Label>
    >(({ className, ...props }, ref) => (
      <SelectPrimitive.Label
        ref={ref}
        className={cn("py-1.5 pl-8 pr-2 text-sm font-semibold", className)}
        {...props}
      />
    ));
    SelectLabel.displayName = SelectPrimitive.Label.displayName;

    const SelectItem = React.forwardRef<
      React.ElementRef<typeof SelectPrimitive.Item>,
      React.ComponentPropsWithoutRef<typeof SelectPrimitive.Item>
    >(({ className, children, ...props }, ref) => (
      <SelectPrimitive.Item
        ref={ref}
        className={cn(
          "relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
          className
        )}
        {...props}
      >
        <span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
          <SelectPrimitive.ItemIndicator>
            <Check className="h-4 w-4" />
          </SelectPrimitive.ItemIndicator>
        </span>
        <SelectPrimitive.ItemText>{children}</SelectPrimitive.ItemText>
      </SelectPrimitive.Item>
    ));
    SelectItem.displayName = SelectPrimitive.Item.displayName;

    const SelectSeparator = React.forwardRef<
      React.ElementRef<typeof SelectPrimitive.Separator>,
      React.ComponentPropsWithoutRef<typeof SelectPrimitive.Separator>
    >(({ className, ...props }, ref) => (
      <SelectPrimitive.Separator
        ref={ref}
        className={cn("-mx-1 my-1 h-px bg-muted", className)}
        {...props}
      />
    ));
    SelectSeparator.displayName = SelectPrimitive.Separator.displayName;

    export {
      Select,
      SelectGroup,
      SelectValue,
      SelectTrigger,
      SelectContent,
      SelectLabel,
      SelectItem,
      SelectSeparator,
      SelectScrollUpButton,
      SelectScrollDownButton,
    };
  TYPESCRIPT

  "tabs" => <<~TYPESCRIPT,
    import * as React from "react";
    import * as TabsPrimitive from "@radix-ui/react-tabs";
    import { cn } from "@/lib/utils";

    const Tabs = TabsPrimitive.Root;

    const TabsList = React.forwardRef<
      React.ElementRef<typeof TabsPrimitive.List>,
      React.ComponentPropsWithoutRef<typeof TabsPrimitive.List>
    >(({ className, ...props }, ref) => (
      <TabsPrimitive.List
        ref={ref}
        className={cn(
          "inline-flex h-10 items-center justify-center rounded-md bg-muted p-1 text-muted-foreground",
          className
        )}
        {...props}
      />
    ));
    TabsList.displayName = TabsPrimitive.List.displayName;

    const TabsTrigger = React.forwardRef<
      React.ElementRef<typeof TabsPrimitive.Trigger>,
      React.ComponentPropsWithoutRef<typeof TabsPrimitive.Trigger>
    >(({ className, ...props }, ref) => (
      <TabsPrimitive.Trigger
        ref={ref}
        className={cn(
          "inline-flex items-center justify-center whitespace-nowrap rounded-sm px-3 py-1.5 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow-sm",
          className
        )}
        {...props}
      />
    ));
    TabsTrigger.displayName = TabsPrimitive.Trigger.displayName;

    const TabsContent = React.forwardRef<
      React.ElementRef<typeof TabsPrimitive.Content>,
      React.ComponentPropsWithoutRef<typeof TabsPrimitive.Content>
    >(({ className, ...props }, ref) => (
      <TabsPrimitive.Content
        ref={ref}
        className={cn(
          "mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
          className
        )}
        {...props}
      />
    ));
    TabsContent.displayName = TabsPrimitive.Content.displayName;

    export { Tabs, TabsList, TabsTrigger, TabsContent };
  TYPESCRIPT

  "toast" => <<~TYPESCRIPT,
    import * as React from "react";
    import { cva, type VariantProps } from "class-variance-authority";
    import { X } from "lucide-react";
    import { cn } from "@/lib/utils";

    const toastVariants = cva(
      "group pointer-events-auto relative flex w-full items-center justify-between space-x-4 overflow-hidden rounded-md border p-6 pr-8 shadow-lg transition-all data-[swipe=cancel]:translate-x-0 data-[swipe=end]:translate-x-[var(--radix-toast-swipe-end-x)] data-[swipe=move]:translate-x-[var(--radix-toast-swipe-move-x)] data-[swipe=move]:transition-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[swipe=end]:animate-out data-[state=closed]:fade-out-80 data-[state=closed]:slide-out-to-right-full data-[state=open]:slide-in-from-top-full data-[state=open]:sm:slide-in-from-bottom-full",
      {
        variants: {
          variant: {
            default: "border bg-background text-foreground",
            destructive:
              "destructive group border-destructive bg-destructive text-destructive-foreground",
          },
        },
        defaultVariants: {
          variant: "default",
        },
      }
    );

    interface ToastProps extends React.HTMLAttributes<HTMLDivElement>, VariantProps<typeof toastVariants> {
      onClose?: () => void;
    }

    const Toast = React.forwardRef<HTMLDivElement, ToastProps>(
      ({ className, variant, onClose, children, ...props }, ref) => {
        return (
          <div
            ref={ref}
            className={cn(toastVariants({ variant }), className)}
            {...props}
          >
            {children}
            {onClose && (
              <button
                onClick={onClose}
                className="absolute right-2 top-2 rounded-md p-1 text-foreground/50 opacity-0 transition-opacity hover:text-foreground focus:opacity-100 focus:outline-none focus:ring-2 group-hover:opacity-100"
              >
                <X className="h-4 w-4" />
              </button>
            )}
          </div>
        );
      }
    );
    Toast.displayName = "Toast";

    const ToastTitle = React.forwardRef<HTMLParagraphElement, React.HTMLAttributes<HTMLHeadingElement>>(
      ({ className, ...props }, ref) => (
        <h5 ref={ref} className={cn("text-sm font-semibold", className)} {...props} />
      )
    );
    ToastTitle.displayName = "ToastTitle";

    const ToastDescription = React.forwardRef<HTMLParagraphElement, React.HTMLAttributes<HTMLParagraphElement>>(
      ({ className, ...props }, ref) => (
        <div ref={ref} className={cn("text-sm opacity-90", className)} {...props} />
      )
    );
    ToastDescription.displayName = "ToastDescription";

    export { Toast, ToastTitle, ToastDescription, toastVariants };
  TYPESCRIPT

  "textarea" => <<~TYPESCRIPT,
    import * as React from "react";
    import { cn } from "@/lib/utils";

    export interface TextareaProps extends React.TextareaHTMLAttributes<HTMLTextAreaElement> {}

    const Textarea = React.forwardRef<HTMLTextAreaElement, TextareaProps>(
      ({ className, ...props }, ref) => {
        return (
          <textarea
            className={cn(
              "flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
              className
            )}
            ref={ref}
            {...props}
          />
        );
      }
    );
    Textarea.displayName = "Textarea";

    export { Textarea };
  TYPESCRIPT

  "checkbox" => <<~TYPESCRIPT,
    import * as React from "react";
    import * as CheckboxPrimitive from "@radix-ui/react-checkbox";
    import { Check } from "lucide-react";
    import { cn } from "@/lib/utils";

    const Checkbox = React.forwardRef<
      React.ElementRef<typeof CheckboxPrimitive.Root>,
      React.ComponentPropsWithoutRef<typeof CheckboxPrimitive.Root>
    >(({ className, ...props }, ref) => (
      <CheckboxPrimitive.Root
        ref={ref}
        className={cn(
          "peer h-4 w-4 shrink-0 rounded-sm border border-primary ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground",
          className
        )}
        {...props}
      >
        <CheckboxPrimitive.Indicator className={cn("flex items-center justify-center text-current")}>
          <Check className="h-4 w-4" />
        </CheckboxPrimitive.Indicator>
      </CheckboxPrimitive.Root>
    ));
    Checkbox.displayName = CheckboxPrimitive.Root.displayName;

    export { Checkbox };
  TYPESCRIPT

  "switch" => <<~TYPESCRIPT,
    import * as React from "react";
    import * as SwitchPrimitives from "@radix-ui/react-switch";
    import { cn } from "@/lib/utils";

    const Switch = React.forwardRef<
      React.ElementRef<typeof SwitchPrimitives.Root>,
      React.ComponentPropsWithoutRef<typeof SwitchPrimitives.Root>
    >(({ className, ...props }, ref) => (
      <SwitchPrimitives.Root
        className={cn(
          "peer inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=unchecked]:bg-input",
          className
        )}
        {...props}
        ref={ref}
      >
        <SwitchPrimitives.Thumb
          className={cn(
            "pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform data-[state=checked]:translate-x-5 data-[state=unchecked]:translate-x-0"
          )}
        />
      </SwitchPrimitives.Root>
    ));
    Switch.displayName = SwitchPrimitives.Root.displayName;

    export { Switch };
  TYPESCRIPT

  "progress" => <<~TYPESCRIPT,
    import * as React from "react";
    import * as ProgressPrimitive from "@radix-ui/react-progress";
    import { cn } from "@/lib/utils";

    const Progress = React.forwardRef<
      React.ElementRef<typeof ProgressPrimitive.Root>,
      React.ComponentPropsWithoutRef<typeof ProgressPrimitive.Root>
    >(({ className, value, ...props }, ref) => (
      <ProgressPrimitive.Root
        ref={ref}
        className={cn("relative h-4 w-full overflow-hidden rounded-full bg-secondary", className)}
        {...props}
      >
        <ProgressPrimitive.Indicator
          className="h-full w-full flex-1 bg-primary transition-all"
          style={{ transform: \`translateX(-\${100 - (value || 0)}%)\` }}
        />
      </ProgressPrimitive.Root>
    ));
    Progress.displayName = ProgressPrimitive.Root.displayName;

    export { Progress };
  TYPESCRIPT

  "tooltip" => <<~TYPESCRIPT,
    import * as React from "react";
    import * as TooltipPrimitive from "@radix-ui/react-tooltip";
    import { cn } from "@/lib/utils";

    const TooltipProvider = TooltipPrimitive.Provider;
    const Tooltip = TooltipPrimitive.Root;
    const TooltipTrigger = TooltipPrimitive.Trigger;

    const TooltipContent = React.forwardRef<
      React.ElementRef<typeof TooltipPrimitive.Content>,
      React.ComponentPropsWithoutRef<typeof TooltipPrimitive.Content>
    >(({ className, sideOffset = 4, ...props }, ref) => (
      <TooltipPrimitive.Content
        ref={ref}
        sideOffset={sideOffset}
        className={cn(
          "z-50 overflow-hidden rounded-md border bg-popover px-3 py-1.5 text-sm text-popover-foreground shadow-md animate-in fade-in-0 zoom-in-95 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
          className
        )}
        {...props}
      />
    ));
    TooltipContent.displayName = TooltipPrimitive.Content.displayName;

    export { Tooltip, TooltipTrigger, TooltipContent, TooltipProvider };
  TYPESCRIPT
}
