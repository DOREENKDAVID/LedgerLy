# Figma Implementation Guide for Signup Screens

## What You Have Now (From Figma Design File)

The Figma file at `https://www.figma.com/design/O4eH6GO0t0R9KFw3G9GlCh/LedgerLy` contains:

### Design Sections Present
1. **Log in & Forgot password** - Login flow designs
2. **Business Profile Setup** - Business type selection and name entry  
3. **Sales Logging** - Transaction and expense recording screens
4. **Home** - Dashboard and analytics screens
5. **Transaction History** - Activity feed

### What's Missing (Not in Figma but Built)
- **Sign Up Welcome Screen** - Initial onboarding intro
- **Sign Up Email Screen** - Email & name input
- **Sign Up Password Screen** - Password creation with strength meter
- **Sign Up Products Screen** - Product catalog setup

## Key Design Assets to Extract from Figma

### 1. **Colors** (Already extracted)
- Primary Teal: #1A9B7F
- Accent Orange: #FF7054
- Text Dark: #1F1F1F
- Text Grey: #6B6B6B
- All other colors in DESIGN_SYSTEM.md

### 2. **Typography Specs**
Extract from Figma's text styles:
- Font family (likely SF Pro Display or custom)
- Exact font sizes and weights for each text style
- Line heights and letter spacing
- See DESIGN_SYSTEM.md for current standards

### 3. **Component Styles to Verify**
These have been implemented based on mockups:
- [ ] Primary Button (55px height, 15px radius) - Check exact shadow/elevation
- [ ] Input Fields (56px height, 12px radius) - Verify focus state border width
- [ ] Password Strength Meter - Verify exact colors and height
- [ ] Dot Indicators - Check exact sizing and spacing
- [ ] Cards/Selection States - Verify the transition animations

### 4. **Icons to Download**
Need to export from Figma:
- Chevron-left (for back button)
- Eye icon (password visibility)
- Eye-off icon (password hidden)
- Check-circle (success states)
- Plus icon (add product)
- Minus icon (quantity decrement)
- Plus icon (quantity increment)
- Business type icons (Grocery, Pharmacy, Fashion, etc.)

### 5. **Illustrations/Images**
Export from Figma if they exist:
- Success check icon/illustration
- Business category icons
- Logo variant for welcome screen

## Outstanding Tasks for Designer/Dev

### High Priority
1. **Extract exact hex colors** from Figma to verify our implementation matches
2. **Download component shadows** - Check if buttons/inputs have elevation/shadows in Figma
3. **Verify responsive behavior** - How should components behave on different screen sizes?
4. **Extract icon library** - Get all icons needed for the signup flow
5. **Verify animation specs** - Exact timing and easing functions

### Medium Priority
1. **Compare font rendering** - Check if we're using the correct font family
2. **Spacing verification** - Audit padding/margin values against Figma
3. **Dark mode design** - Does Figma have dark mode variants? (Not needed for MVP)
4. **Accessibility specs** - Any specific contrast ratios or touch target sizes?

### Lower Priority
1. **RTL support** - Should the app support right-to-left layouts?
2. **Alternative language screens** - Wireframes for other languages?
3. **Tablet/landscape variants** - Design for larger screens?

## How to Extract from Figma (Steps for Designer)

1. Go to the Figma file
2. Right-click on the signup section you created (if exists)
3. Export each component as:
   - SVG for icons
   - PNG for illustrations (at 2x or 3x resolution)
4. Use Figma's "Inspect" panel to get exact specs:
   - Click each element > right panel shows exact measurements
   - Copy color values (HEX format)
   - Record animation timings if specified

## Figma Links for Reference

- **Main Design File**: https://www.figma.com/design/O4eH6GO0t0R9KFw3G9GlCh/LedgerLy
- **Specific Node for Signup**: node-id=96:1754 (Login & Auth section)

## How the Built Screens Match Figma

### ✅ Already Implemented Correctly
- Color scheme (Primary Teal, Accent Orange)
- Button styling and sizing
- Input field layouts
- Password strength visualization
- Form validation logic
- Business type grid layout
- Product list with margin calculations

### ⚠️ Approximate Implementations (Need Figma Verification)
- Exact font weights and sizes
- Shadow/elevation on components
- Border radius on cards
- Exact spacing values
- Icon styling
- Animation timing

### ❌ Not Yet Implemented (Future)
- Dark mode
- Tablet/landscape layouts
- Accessibility features (if any in Figma)

## Next Steps

1. ✅ Share Figma file link (DONE)
2. ⏳ Extract design components/icons from Figma
3. ⏳ Verify exact specifications match
4. ⏳ Update any styling differences
5. ⏳ Implement backend integration
6. ⏳ Test on actual devices
