/// Core Widgets Library
///
/// Exports all reusable UI components following Flutter conventions
///
/// Usage:
/// ```dart
/// import 'package:ledgerly_v3/core/widgets/widgets.dart';
///
/// // Access any widget
/// LedgerlyButton(label: 'Continue')
/// LedgerlyTextField(labelText: 'Email')
/// OtpInputField(first: true, last: false)
/// ```
library;

// Buttons
export 'buttons/buttons.dart';

// Input Fields
export 'inputs/inputs.dart';

// Cards
export 'cards/cards.dart';

// Legacy empty state and alert (not reorganized yet)
export 'ledgerly_empty_state.dart';
export 'margin_risk_alert.dart';
