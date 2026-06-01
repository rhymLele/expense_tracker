/// LearnSpace spacing + radius + icon tokens.
/// Spacing base = 4px. Radii match tokens.css.
class AppSizes {
  // ─── Spacing (4 px base) ────────────────────────────────────────────────────
  static const double space1  = 2.0;
  static const double space2  = 4.0;
  static const double space3  = 6.0;
  static const double space4  = 8.0;
  static const double space5  = 10.0;
  static const double space6  = 12.0;
  static const double space7  = 16.0;
  static const double space8  = 20.0;
  static const double space9  = 24.0;
  static const double space10 = 28.0;
  static const double space11 = 32.0;
  static const double space12 = 40.0;
  static const double space13 = 48.0;
  static const double space14 = 64.0;

  // ─── Semantic aliases ───────────────────────────────────────────────────────
  static const double xs  = space2;   // 4
  static const double sm  = space4;   // 8
  static const double md  = space6;   // 12
  static const double lg  = space7;   // 16
  static const double xl  = space8;   // 20
  static const double xxl = space9;   // 24
  static const double xxxl = space11; // 32

  // padding aliases (used widely in existing code)
  static const double paddingXs  = xs;
  static const double paddingSm  = sm;
  static const double paddingMd  = md;
  static const double paddingLg  = lg;
  static const double paddingXl  = xl;
  static const double paddingXxl = xxl;

  // ─── Radius ────────────────────────────────────────────────────────────────
  static const double radiusXs   = 4.0;   // xs
  static const double radiusSm   = 6.0;   // sm
  static const double radiusMd   = 8.0;   // md
  static const double radiusLg   = 12.0;  // lg — buttons
  static const double radiusXl   = 16.0;  // xl — cards / modals
  static const double radius2xl  = 24.0;  // 2xl
  static const double radiusFull = 999.0; // pill

  // ─── Icons ─────────────────────────────────────────────────────────────────
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;

  // ─── Component sizes ────────────────────────────────────────────────────────
  static const double avatarSm  = 32.0;
  static const double avatarMd  = 44.0;
  static const double avatarLg  = 56.0;
  static const double avatarXl  = 84.0;

  static const double iconBtnSize = 40.0;
  static const double buttonHeight = 50.0;
  static const double appBarHeight  = 56.0;
}
