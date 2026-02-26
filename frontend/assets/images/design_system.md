# LedgerLy Design System

## Colors

### Primary Colors
- **Primary Teal**: #1A9B7F - Main brand color for buttons, headers, focus states
- **Accent Orange**: #FF7054 - Used for highlights, emphasis text, important information

### Neutral Colors
- **Text Dark**: #1F1F1F - Primary text color
- **Text Grey**: #6B6B6B - Secondary text, descriptions, placeholders
- **Background Grey**: #F8F9FA - Light background surfaces
- **Border Grey**: #E8E8E8 - Input field borders, dividers
- **Disabled Grey**: #D9D9D9 - Disabled states

### Status/Semantic Colors
- **Success Green**: #10B981 - Positive states, approved actions
- **Error Red**: #EF4444 - Error states, destructive actions  
- **Weak Red**: #FF6B6B - Password strength weak
- **Fair Orange**: #FFA500 - Password strength fair
- **Strong Green**: #10B981 - Password strength strong

## Typography

### Font Family
- **Default**: System fonts (SF Pro Display on iOS, Roboto on Android)
- **Weights**: Regular (400), Medium (500), Bold (700)

### Text Styles

#### Heading Large (H1)
- Size: 32px
- Weight: Bold (700)
- Line Height: 1.2
- Color: #1A9B7F (Primary Teal)
- Used for: Welcome screen titles, main page headers

#### Heading Medium (H2)
- Size: 28px
- Weight: Bold (700)
- Line Height: 1.2
- Color: #1A9B7F (Primary Teal)
- Used for: Screen titles

#### Heading Small (H3)
- Size: 24px
- Weight: Bold (700)
- Line Height: 1.3
- Color: #1F1F1F (Text Dark)
- Used for: Card titles, subheadings

#### Body Large
- Size: 16px
- Weight: Regular (400)
- Line Height: 1.5
- Color: #6B6B6B (Text Grey)
- Used for: Form field labels, body text

#### Body Regular
- Size: 14px
- Weight: Regular (400)
- Line Height: 1.5
- Color: #6B6B6B (Text Grey)
- Used for: Descriptions, helper text

#### Label
- Size: 12px
- Weight: Medium (500)
- Line Height: 1.4
- Color: #6B6B6B (Text Grey)
- Used for: Input labels, captions

#### Button Text
- Size: 16px
- Weight: Bold (700)
- Color: #FFFFFF (White)
- Used for: All button labels

## Components

### Buttons

#### Primary Button
- Background: #1A9B7F (Primary Teal)
- Text Color: #FFFFFF (White)
- Height: 55px
- Border Radius: 15px
- Padding: 16px
- Disabled State: Background #D9D9D9, Text #6B6B6B
- Shadow: None (elevation: 0)

#### Button States
- **Default**: Teal background, white text
- **Hover/Pressed**: Darker teal (#158974)
- **Disabled**: Grey background (#D9D9D9), grey text

### Input Fields

#### Text Input
- Background: #FFFFFF (White)
- Border: 1px solid #E8E8E8 (Border Grey)
- Border Radius: 12px
- Padding: 16px horizontal, 16px vertical
- Label Color: #6B6B6B (Text Grey)
- Placeholder Color: #D9D9D9 (Disabled Grey)
- Focus Border: #1A9B7F (Primary Teal)
- Height: 56px

#### Input Field States
- **Default**: White background, grey border
- **Focus**: White background, teal border (2px)
- **Error**: White background, red border (#EF4444)
- **Disabled**: #F8F9FA background, grey border

### Progress Indicators

#### Password Strength Meter
- Height: 6px
- Border Radius: 10px
- Background: #F8F9FA (Background Grey)
- Fill Colors:
  - Weak: #FF6B6B (Weak Red)
  - Fair: #FFA500 (Fair Orange)
  - Strong: #10B981 (Strong Green)

#### Dots Indicator
- Size: 8px (active), 8px (inactive)
- Active Width: 24px
- Border Radius: 4px
- Active Color: #1A9B7F (Primary Teal)
- Inactive Color: #E8E8E8 (Border Grey)
- Margin: 8px between dots

### Cards

#### Default Card
- Background: #FFFFFF (White)
- Border: 1px solid #E8E8E8 (Border Grey)
- Border Radius: 12px
- Padding: 16px
- Shadow: None

#### Selected Card
- Background: #1A9B7F (Primary Teal)
- Border: 2px solid #1A9B7F (Primary Teal)
- Border Radius: 20px
- Text Color: #FFFFFF (White)

### Spacing

#### Scale
- xs: 4px
- sm: 8px
- md: 12px
- lg: 16px
- xl: 20px
- 2xl: 24px
- 3xl: 32px
- 4xl: 40px
- 5xl: 48px

#### Margin/Padding Standards
- Top/Bottom spacing between elements: 20-30px
- Left/Right padding on screens: 25px
- Input field spacing: 20px

### Border Radius

- Small components (buttons, inputs): 12px
- Larger components (cards): 15-20px
- Product cards: 12px

## Screens

### Signup Flow

#### Welcome Screen
- Logo size: 80x80px
- Logo background: Teal with 20px border radius
- Title: H1 (32px, bold, teal)
- Subtitle: Body Regular (14px, grey)
- Benefits list spacing: 25px between items
- Button: Full width, Primary style

#### Email Screen
- Title: H2 (28px, bold, teal)
- Subtitle: Body Regular (14px, grey)
- Input fields: Full width, 56px height
- Field spacing: 20px between fields
- Button: Full width

#### Password Screen
- Title: H2 (28px, bold, teal)
- Strength meter: 6px height, 10px radius
- Show/hide icon: 24px size
- Password visibility toggle: Suffix icon
- Confirm password field: Full width
- Error message: 12px, red color

#### Business Type Screen
- Title: H2 (28px, bold, teal)
- Grid: 2 columns
- Card spacing: 15px
- Card aspect ratio: 1.1
- Icon size: 35px

#### Products Screen
- Title: H2 (28px, bold, teal)
- Product list spacing: 15px between cards
- Add button: Dashed border, teal text
- Edit product form: 16px padding
- Remove button: Small X icon, red

#### OTP Screen
- Title: H2 (28px, bold, teal)
- OTP boxes: 60x60px each
- OTP spacing: Full width distribution
- Resend timer: 14px, grey text
- Input style: Centered text, numeric keyboard

## Interactions

### Animations
- Button press: 100ms
- Form validation: Real-time with visual feedback
- Screen transitions: 300ms fade/slide
- Password strength update: Instant
- Card selection: 200ms animated container

### Feedback
- Password strength: Updates as user types
- Form validation: Real-time error display
- Error messages: Red text below input
- Success states: Green checkmark, positive feedback

## Implementation Notes

1. All buttons use `border-radius: 15px`
2. All input fields use `border-radius: 12px`
3. Status bar height: 74px (iPhone)
4. Safe area padding: 24-25px horizontal
5. Screen background: White (#FFFFFF)
6. Focus states: 2px border in primary teal
