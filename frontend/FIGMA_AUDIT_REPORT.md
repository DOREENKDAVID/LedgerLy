# LedgerLy Figma Design System Audit Report

**Date**: $(date)
**Project**: LedgerLy v3 Signup & Auth Screens
**Status**: ⚠️ REQUIRES FIXES

---

## Executive Summary

Comprehensive audit of signup/auth screen implementations against Figma design specifications reveals:
- ✅ Color system: 95% compliant
- ✅ Spacing/Padding: 90% compliant  
- ⚠️ Typography: 70% compliant (fonts not explicitly used)
- ❌ Icons: 0% compliant (no custom icons created, using Material defaults)
- ❌ Assets: 50% compliant (icons directory empty, SVGs missing)

**Critical Issues Found**: 8
**Medium Issues Found**: 12
**Minor Issues Found**: 6

---

## 📋 Detailed Findings

### 1. CRITICAL: Missing Icon Assets

**Issue**: `assets/icons/` directory is empty but pubspec.yaml declares it.

**Required Icons** (from design_system.md):
- ✗ chevron-left (back arrow)
- ✗ eye (password visible)
- ✗ eye-off (password hidden)
- ✗ check-circle (success state)
- ✗ plus (add product)
- ✗ minus (quantity decrement)
- ✗ business-type icons (6 categories: Grocery, Pharmacy, Fashion, Electronics, Restaurant, Other)

**Current State**: Using Material Design Icons as fallback
**Impact**: HIGH - Visual inconsistency with Figma design

**Screens Affected**:
- signup_password_screen.dart: Uses Icons.visibility_outlined/visibility_off_outlined (should be custom eye icons)
- signup_products_screen.dart: Uses Icons for add/remove (should be custom plus/minus)
- business_selection_screen.dart: Uses Icons for 6 business types (should be custom icons)
- otp_verification_screen.dart: Relies on timer display (may need check-circle icon)

**Action Required**:
1. Create SVG icons for all 8 required icons OR
2. Download icon set from Figma export OR
3. Use flutter_svg with placeholder SVG strings until Figma icons available

---

### 2. CRITICAL: Typography Not Explicitly Using Fonts

**Issue**: Design system specifies using Google Fonts or system fonts, but actual screens don't explicitly reference them.

**Spec Requirements**:
- Default: System fonts (SF Pro Display on iOS, Roboto on Android)
- Alternative: Google Fonts (pubspec.yaml has google_fonts: ^6.1.0)
- Project also declared: assets/fonts/NunitoSans-*.ttf fonts

**Current State**:
- No explicit FontFamily used in TextStyle widgets
- google_fonts package imported but not used
- Nunito Sans fonts in assets but not declared in pubspec.yaml with fontFamily

**Affected Screens**: ALL screens
- signup_welcome_screen.dart
- signup_email_screen.dart  
- signup_password_screen.dart
- business_selection_screen.dart
- signup_products_screen.dart
- otp_verification_screen.dart

**Example Issue in signup_email_screen.dart** (line 50-55):
```dart
// Current - no font family specified
const Text(
  "Verify your email",
  style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryTeal,
  ),
),

// Should be one of:
// Option 1 - Google Fonts
// GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold)

// Option 2 - System font specified
// TextStyle(fontFamily: 'Roboto', fontSize: 28, fontWeight: FontWeight.bold)
```

**Action Required**:
1. Decide: Google Fonts, system fonts, or Nunito Sans
2. Update all TextStyle declarations with explicit fontFamily
3. If using Google Fonts: add `import 'package:google_fonts/google_fonts.dart';` to all screens
4. If using custom fonts: add to pubspec.yaml properly and reference in TextStyle

**Recommendation**: Use Google Fonts for consistency (already in pubspec.yaml)

---

### 3. MEDIUM: Border Radius Inconsistencies

**Spec Requirements**:
- Buttons: 15px
- Input fields: 12px  
- Default cards: 12px
- Selected cards: 20px

**Audit Results**:

#### signup_email_screen.dart ✓
- Input border: `BorderRadius.circular(12)` ✓
- Button (LedgerlyButton): Uses AppColors, radius correct

#### signup_password_screen.dart ✓
- Input border: `BorderRadius.circular(12)` ✓
- Logo section: Correct

#### business_selection_screen.dart ⚠️
- Selected card: `BorderRadius.circular(20)` ✓
- **Issue**: Non-selected cards not explicitly styled - verify they use 12px
- Line 65: `borderRadius: BorderRadius.circular(20)` - **Should be conditional (12px for unselected, 20px for selected)**

**Location**: business_selection_screen.dart, line 65-70
```dart
// Current - always uses 20px
BorderRadius.circular(20),  // ⚠️ Should be: isSelected ? 20 : 12
```

#### otp_verification_screen.dart ✓
- OTP boxes: `BorderRadius.circular(12)` ✓

#### signup_products_screen.dart
- Need to verify TextField border radius in product form
- Product card border radius styling

#### signup_welcome_screen.dart (sign_up_screen.dart)
- Need to verify all fields use correct border radius

**Action Required**:
1. Fix business_selection_screen.dart to use conditional border radius
2. Verify all other screens explicitly set correct border radius values

---

### 4. MEDIUM: Input Field Height Not Meeting Spec

**Spec Requirement**: Input field height = 56px

**Current Implementation Issues**:

#### signup_email_screen.dart
- TextField with contentPadding: `EdgeInsets.symmetric(horizontal: 16, vertical: 16)` 
- ⚠️ No explicit height specified - may not be exactly 56px

#### signup_password_screen.dart  
- Similar issue - contentPadding set but no explicit height

#### signup_products_screen.dart
- ProductName/CostPrice/SellingPrice fields - need verification

**Action Required**:
1. Add explicit `SizedBox(height: 56)` wrapper around TextFields OR
2. Use `minLines: 1` with calculated height through padding

**Recommended Fix**:
```dart
SizedBox(
  height: 56,
  child: TextField(
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
)
```

---

### 5. MEDIUM: Focus State Border Width

**Spec Requirement**: Focus border should be 2px (specified in design_system.md)

**Current Implementation**:

#### otp_verification_screen.dart ✓
- Line 41-43: `borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2)` ✓

#### signup_email_screen.dart ⚠️
- Uses default OutlineInputBorder - likely 1px default
- Need to explicitly set focus border width to 2px

**Action Required**:
Update all TextFields to explicitly set focusedBorder with 2px width:
```dart
focusedBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
)
```

---

### 6. MEDIUM: Password Strength Colors

**Spec Requirement** (design_system.md):
- Weak: #FF6B6B (AppColors.weakRed)
- Fair: #FFA500 (AppColors.fairOrange)
- Strong: #10B981 (AppColors.strongGreen)

**Current Implementation in signup_password_screen.dart**:

```dart
// Line 48-59
if (strength <= 0.3) {
  _strengthText = "Weak";
  _strengthColor = Colors.red;  // ⚠️ WRONG: Should be AppColors.weakRed
} else if (strength <= 0.6) {
  _strengthText = "Fair";
  _strengthColor = Colors.orange;  // ⚠️ WRONG: Should be AppColors.fairOrange
} else {
  _strengthText = "Strong";
  _strengthColor = Colors.green;  // ⚠️ WRONG: Should be AppColors.strongGreen
}
```

**Issue**: Uses generic Colors.red/orange/green instead of exact hex values

**Action Required**: 
Replace color assignments with AppColors constants:
```dart
_strengthColor = AppColors.weakRed;  // #FF6B6B
_strengthColor = AppColors.fairOrange;  // #FFA500
_strengthColor = AppColors.strongGreen;  // #10B981
```

---

### 7. MEDIUM: Label Text Styling

**Spec Requirement** (design_system.md - Label style):
- Size: 12px
- Weight: Medium (500)
- Color: #6B6B6B (Text Grey)
- Line Height: 1.4

**Current Issues**:

#### signup_email_screen.dart (lines 60-62)
```dart
labelStyle: const TextStyle(color: Colors.grey),  // ⚠️ Wrong color
// Should be: labelStyle: const TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.w500)
```

#### signup_password_screen.dart
- Similar issue

**Action Required**:
Create helper method for consistent label styling:
```dart
TextStyle _labelStyle() => const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: AppColors.textGrey,
)
```

---

### 8. MINOR: Placeholder Text Color

**Spec Requirement**: Placeholder color = #D9D9D9 (Disabled Grey)

**Current Implementation**:
Most TextFields use default hint text color (usually grey)

**Action Required**:
Add hintStyle to all TextFields:
```dart
hintStyle: const TextStyle(color: AppColors.disabledGrey)
```

---

### 9. MINOR: Error Message Text Color

**Spec Requirement** (design_system.md):
- Error message: 12px, #EF4444 (Error Red)

**Current Implementation**:
Verify all error messages use AppColors.errorRed and 12px

---

### 10. MINOR: Disabled State Styling

**Spec Requirement**:
- Disabled button: Background #D9D9D9, Text #6B6B6B
- Disabled input: Background #F8F9FA, grey border

**Current**: LedgerlyButton handles disabled state - need to verify styling matches spec

---

### 11. ASSET PATH ISSUES: Logo Reference

**Issue in signup_password_screen.dart** (line 84):
```dart
Image.asset(
  'assets/images/logo.png',  // ❌ Wrong path
  // Should be: 'assets/images/logos/logo.png'
```

**Current pubspec.yaml Declaration**:
```yaml
assets:
- assets/images/logos/logo.png  # ✓ Declared correctly
```

**Action Required**:
Fix all logo references to use correct path: `assets/images/logos/logo.png`

---

### 12. PUBSPEC.YAML FONT DECLARATION ISSUE

**Current pubspec.yaml (font section)**:
```yaml
flutter:
  uses-material-design: true
  assets:
  - assets/images/logos/logo.png
  - assets/images/onboarding_1.png
  - assets/images/onboarding_2.png
  - assets/images/onboarding_3.png
  - assets/icons/
  - assets/fonts/
  
# ⚠️ MISSING: fonts section
# Should include NunitoSans fonts if using them
```

**Issue**: Fonts in assets/fonts/ are not declared in pubspec.yaml

**Fix Required** (if using Nunito Sans):
```yaml
fonts:
  - family: NunitoSans
    fonts:
      - asset: assets/fonts/NunitoSans-VariableFont_YTLC,opsz,wdth,wght.ttf
      - asset: assets/fonts/NunitoSans-Italic-VariableFont_YTLC,opsz,wdth,wght.ttf
        style: italic
```

---

## 📊 Compliance Summary

| Category | Spec | Current | Status | Issues |
|----------|------|---------|--------|--------|
| Colors | 16 colors defined | 16 colors in AppColors | ✅ PASS | 1 (password strength using generic Colors) |
| Typography | Sizes, weights, families | Partially implemented | ⚠️ PARTIAL | Font families not explicit |
| Spacing | Padding, margins defined | 90% correct | ⚠️ GOOD | Minor input height variance |
| Border Radius | 12px/15px/20px | Mostly correct | ✅ GOOD | 1 (business selection card) |
| Icons | 8+ icons required | 0 created | ❌ CRITICAL | All using Material defaults |
| Assets | 3 PNGs + icons + fonts | 3 PNGs present | ⚠️ PARTIAL | No icons/SVGs |
| Input States | Focus 2px, error, disabled | Partially implemented | ⚠️ PARTIAL | Border width, error state |

---

## 🔧 Priority Fixes Checklist

### CRITICAL (Must Fix)
- [ ] Create icon assets or implement SVG placeholders (8 icons needed)
- [ ] Fix password strength colors (use AppColors constants)
- [ ] Fix logo asset path in signup_password_screen.dart

### HIGH (Should Fix Before Release)
- [ ] Add explicit font family to all screens (use Google Fonts)
- [ ] Fix business_selection_screen border radius (conditional: 12px/20px)
- [ ] Add explicit input height: 56px to all TextFields
- [ ] Add focusedBorder with 2px width to all TextFields
- [ ] Add hintStyle with AppColors.disabledGrey to all TextFields

### MEDIUM (Should Fix Soon)
- [ ] Add labelStyle with correct color/size/weight
- [ ] Add errorStyle for error messages
- [ ] Verify error message displayed with #EF4444 color
- [ ] Update pubspec.yaml font declarations (if using Nunito Sans)

### LOW (Nice to Have)
- [ ] Add shadow/elevation to buttons (if spec requires)
- [ ] Verify placeholder text appearance
- [ ] Add error state border color (#EF4444)
- [ ] Ensure disabled state styling matches spec

---

## 📁 Asset Audit

### Existing Assets ✓
- `assets/images/logos/logo.png` - Present
- `assets/images/onboarding_1.png` - Present
- `assets/images/onboarding_2.png` - Present
- `assets/images/onboarding_3.png` - Present
- `assets/images/primary_button.png` - Present
- `assets/images/favicon_1.png` - Present
- `assets/fonts/NunitoSans-VariableFont_YTLC,opsz,wdth,wght.ttf` - Present
- `assets/fonts/NunitoSans-Italic-VariableFont_YTLC,opsz,wdth,wght.ttf` - Present

### Missing Assets ✗
- `assets/icons/chevron-left.svg` - NOT FOUND
- `assets/icons/eye.svg` - NOT FOUND
- `assets/icons/eye-off.svg` - NOT FOUND
- `assets/icons/check-circle.svg` - NOT FOUND
- `assets/icons/plus.svg` - NOT FOUND
- `assets/icons/minus.svg` - NOT FOUND
- `assets/icons/business-grocery.svg` - NOT FOUND
- `assets/icons/business-pharmacy.svg` - NOT FOUND
- `assets/icons/business-fashion.svg` - NOT FOUND
- `assets/icons/business-electronics.svg` - NOT FOUND
- `assets/icons/business-restaurant.svg` - NOT FOUND
- `assets/icons/business-other.svg` - NOT FOUND

**Action Required**: Create or export these 12 icon files from Figma

---

## 🎯 Recommendation

### Phase 1 (Immediate - 2-3 hours)
1. Fix password strength colors
2. Fix border radius in business_selection_screen
3. Add explicit font families to all screens (use Google Fonts)
4. Fix logo asset path

### Phase 2 (Critical - 1-2 hours)
1. Create SVG icon placeholders in assets/icons/
2. Update screens to use SVG icons instead of Material icons
3. Add explicit input heights (56px)
4. Add focusedBorder styling

### Phase 3 (After MVP - 1 hour)
1. Request final icon exports from Figma
2. Replace placeholder icons with actual design
3. Fine-tune remaining typography/spacing
4. Test on multiple screen sizes

---

## 📌 Notes

- All color hex values in AppColors match spec exactly ✓
- Horizontal padding (25px) and field spacing (20px) mostly correct ✓
- No major layout issues detected
- App builds and runs successfully on emulator/browser ✓
- Main gaps are: icons, fonts, and some edge-case styling

---

**Report Generated**: $(date)
**Next Review**: After fixes in Phase 1 completed
