# LedgerLy Figma Compliance Checklist - Developer Guide

This checklist helps ensure all new screens maintain Figma design specifications.

---

## 🎨 Color System Checklist

When adding new screens, use ONLY these colors from `AppColors`:

```dart
import 'package:ledgerly_v3/core/theme/app_colors.dart';

// ✅ DO THIS
Text('Hello', style: TextStyle(color: AppColors.textGrey))

// ❌ DON'T DO THIS
Text('Hello', style: TextStyle(color: Colors.grey))
```

### Required AppColors for Each Screen
- [ ] Titles: `AppColors.primaryTeal` (28px bold)
- [ ] Body text: `AppColors.textGrey` (14px regular)
- [ ] Labels: `AppColors.textGrey` (12px medium)
- [ ] Buttons: `AppColors.primaryTeal` background, white text
- [ ] Borders: `AppColors.borderGrey` (1px default, 2px focus)
- [ ] Error messages: `AppColors.errorRed`
- [ ] Success states: `AppColors.successGreen`
- [ ] Backgrounds: `AppColors.backgroundGrey` or white

---

## 🔤 Typography Checklist

### Google Fonts Usage

Every new screen MUST import and use Google Fonts:

```dart
import 'package:google_fonts/google_fonts.dart';

// ✅ DO THIS
Text('Title',
  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold)
)

// ❌ DON'T DO THIS
Text('Title',
  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)
)
```

### Typography Standards (Per Design System)
- **H1**: 32px bold, primaryTeal color
- **H2**: 28px bold, primaryTeal color (most screen titles)
- **H3**: 24px bold, textDark color
- **Body Large**: 16px regular, textGrey
- **Body Regular**: 14px regular, textGrey
- **Label**: 12px medium, textGrey
- **Button**: 16px bold, white

### Copy-Paste Template
```dart
// Screen Title
Text('Screen Title',
  style: GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryTeal,
  ),
),

// Subtitle
Text('Subtitle text here',
  style: GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.textGrey,
    height: 1.5,
  ),
),

// Label
Text('Field Label',
  style: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  ),
),
```

---

## 🎯 Layout & Spacing Checklist

### Standard Padding
```dart
// ✅ Screen horizontal padding
padding: const EdgeInsets.symmetric(horizontal: 25.0)

// ✅ Between form fields
const SizedBox(height: 20)

// ✅ Between sections
const SizedBox(height: 30)

// ✅ Top padding after appbar
const SizedBox(height: 10)
```

### Input Fields
```dart
// ✅ DO THIS
TextField(
  decoration: InputDecoration(
    labelStyle: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textGrey,
    ),
    hintStyle: GoogleFonts.inter(
      fontSize: 14,
      color: AppColors.disabledGrey,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.borderGrey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
  ),
)
```

---

## 🔘 Component Sizing Checklist

### Buttons
- [x] Height: 55px (use `LedgerlyButton` widget)
- [x] Border Radius: 15px
- [x] Use `LedgerlyButton` for consistency

### Input Fields
- [ ] Height: 56px (contentPadding achieves this)
- [ ] Border Radius: 12px
- [ ] Focus border width: 2px

### Cards
- [ ] Default border radius: 12px
- [ ] Selected/active border radius: 20px
- [ ] Padding: 16px

---

## 🎨 Icon Checklist

### Use SVG Icons from `assets/icons/`

Available icons (created 12/2024):
- `assets/icons/chevron-left.svg` - Back button
- `assets/icons/eye.svg` - Show password
- `assets/icons/eye-off.svg` - Hide password
- `assets/icons/check-circle.svg` - Success
- `assets/icons/plus.svg` - Add/increment
- `assets/icons/minus.svg` - Remove/decrement
- `assets/icons/business-grocery.svg`
- `assets/icons/business-pharmacy.svg`
- `assets/icons/business-fashion.svg`
- `assets/icons/business-electronics.svg`
- `assets/icons/business-restaurant.svg`
- `assets/icons/business-other.svg`

### Correct SVG Icon Usage
```dart
import 'package:flutter_svg/flutter_svg.dart';

// ✅ FOR COLORED ICONS
ColorFiltered(
  colorFilter: ColorFilter.mode(
    AppColors.primaryTeal,
    BlendMode.srcIn,
  ),
  child: SvgPicture.asset(
    'assets/icons/check-circle.svg',
    width: 24,
    height: 24,
  ),
)

// ❌ DON'T USE
Icon(Icons.check_circle) // Material icon
```

---

## 🎬 Animation Checklist

### Standard Animations (Per Design System)
- Button press: 100ms
- Form validation: Real-time
- Screen transitions: 300ms fade/slide
- Card selection: 200ms
- Password strength: Instant

```dart
// ✅ Animated container
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  decoration: BoxDecoration(
    color: isSelected ? AppColors.primaryTeal : Colors.white,
    borderRadius: BorderRadius.circular(isSelected ? 20 : 12),
  ),
  child: // ...
)
```

---

## 📱 Screen Template

Use this template for new screens:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/ledgerly_button.dart';

class MyNewScreen extends StatefulWidget {
  const MyNewScreen({super.key});

  @override
  State<MyNewScreen> createState() => _MyNewScreenState();
}

class _MyNewScreenState extends State<MyNewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // SCREEN TITLE (H2: 28px bold teal)
              Text(
                "Screen Title",
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(height: 10),
              // SUBTITLE (Body: 14px regular grey)
              Text(
                "Subtitle explaining what to do",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              
              // FORM FIELDS HERE
              
              const SizedBox(height: 30),
              // PRIMARY ACTION BUTTON
              LedgerlyButton(
                label: "Continue",
                onPressed: () { /* TODO */ },
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## ✅ Pre-Commit Checklist

Before committing any new screen:

### Colors
- [ ] Using ONLY `AppColors.*` constants (no `Colors.xxx`)
- [ ] Verified all colors against `assets/images/design_system.md`
- [ ] Title is `AppColors.primaryTeal` (28px)
- [ ] Body text is `AppColors.textGrey` (14px)
- [ ] Inputs use `AppColors.borderGrey` (default) and `AppColors.primaryTeal` (focus)

### Typography
- [ ] All TextStyle use `GoogleFonts.inter()`
- [ ] No `const TextStyle` without Google Fonts
- [ ] Font sizes match specification (28/24/16/14/12px)
- [ ] Font weights correct (700/600/500/400)

### Spacing
- [ ] Screen padding: 25px horizontal
- [ ] Between fields: 20px vertical
- [ ] Between sections: 30px vertical
- [ ] Top padding: 10px after appbar

### Sizing
- [ ] Buttons: 55px height via `LedgerlyButton`
- [ ] Button radius: 15px via `LedgerlyButton`
- [ ] Input fields: 56px height achieved via contentPadding
- [ ] Input radius: 12px
- [ ] Focus border: 2px width

### Icons
- [ ] Using SVG icons from `assets/icons/` (not Material icons)
- [ ] SVG icons wrapped in `ColorFiltered` if color needs to change
- [ ] Icon sizes: 24px for standard, 35px for cards

### Widgets
- [ ] Using `LedgerlyButton` for all primary buttons
- [ ] All inputs have proper labelStyle, hintStyle, focusedBorder
- [ ] No hardcoded colors in widget tree

### Build
- [ ] `flutter analyze` returns no errors
- [ ] `flutter analyze` returns no warnings
- [ ] Imports organized (flutter → packages → local)

---

## 🐛 Common Mistakes to Avoid

### ❌ DON'T
```dart
// Using generic colors
Text('Hello', style: TextStyle(color: Colors.blue))

// Missing Google Fonts
Text('Title', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))

// Using Material icons
Icon(Icons.add)

// Inconsistent padding
Padding(padding: EdgeInsets.all(16))

// Missing border in focus state
border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
```

### ✅ DO
```dart
// Using AppColors
Text('Hello', style: TextStyle(color: AppColors.primaryTeal))

// Using Google Fonts
Text('Title', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold))

// Using SVG icons
SvgPicture.asset('assets/icons/plus.svg')

// Consistent padding
Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0))

// Proper focus border
focusedBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
)
```

---

## 📚 Reference Files

- **Design System Colors**: `assets/images/design_system.md`
- **Implementation Specs**: `assets/images/figma_implementation.md`
- **Audit Checklist**: `assets/images/figma_checklist.md`
- **Color Constants**: `lib/core/theme/app_colors.dart`
- **Button Widget**: `lib/core/widgets/ledgerly_button.dart`
- **SVG Icons**: `assets/icons/` (12 icons available)

---

## 🎯 Questions? 

Refer to existing screens for implementation examples:
- **Sign up flow**: `lib/features/auth/screens/signup_*.dart`
- **Business selection**: `lib/features/auth/screens/business_selection_screen.dart`
- **OTP entry**: `lib/features/auth/screens/otp_verification_screen.dart`

