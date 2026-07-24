import 'package:flutter/material.dart';

/// A highly reusable Text widget that standardizes typography across the app.
class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;

  // Default constructor
  const AppText(
      this.text, {
        super.key,
        this.style,
        this.color,
        this.fontSize,
        this.fontWeight,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.letterSpacing,
      });

  // Splash Screen aur bade Titles ke liye
  const AppText.heading1(
      this.text, {
        super.key,
        this.color,
        this.textAlign,
        this.maxLines = 1,
        this.overflow = TextOverflow.ellipsis,
        this.letterSpacing,
      })  : style = null,
        fontSize = 32.0,
        fontWeight = FontWeight.bold;

  // Appbar aur normal Headings ke liye
  const AppText.heading(
      this.text, {
        super.key,
        this.color,
        this.textAlign,
        this.maxLines = 1,
        this.overflow = TextOverflow.ellipsis,
        this.letterSpacing,
      })  : style = null,
        fontSize = 24.0,
        fontWeight = FontWeight.bold;

  // Section Titles (e.g., "Recently Played") ke liye
  const AppText.subtitle(
      this.text, {
        super.key,
        this.color,
        this.textAlign,
        this.maxLines = 1,
        this.overflow = TextOverflow.ellipsis,
        this.letterSpacing,
      })  : style = null,
        fontSize = 18.0,
        fontWeight = FontWeight.w600;

  // Added for error_widget.dart compatibility
  const AppText.titleMedium(
      this.text, {
        super.key,
        this.color,
        this.textAlign,
        this.maxLines = 1,
        this.overflow = TextOverflow.ellipsis,
        this.letterSpacing,
      })  : style = null,
        fontSize = 16.0,
        fontWeight = FontWeight.w600;

  // Splash Screen subtitles aur thode bade text ke liye
  const AppText.bodyLarge(
      this.text, {
        super.key,
        this.color,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.letterSpacing,
      })  : style = null,
        fontSize = 16.0,
        fontWeight = FontWeight.w500;

  // Added for error_widget.dart compatibility
  const AppText.bodyMedium(
      this.text, {
        super.key,
        this.color,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.letterSpacing,
      })  : style = null,
        fontSize = 14.0,
        fontWeight = FontWeight.w400;

  // Normal body text aur list items ke liye
  const AppText.body(
      this.text, {
        super.key,
        this.color,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.letterSpacing,
      })  : style = null,
        fontSize = 14.0,
        fontWeight = FontWeight.w500;

  // Small details (duration, artist name) ke liye
  const AppText.caption(
      this.text, {
        super.key,
        this.color,
        this.textAlign,
        this.maxLines = 1,
        this.overflow = TextOverflow.ellipsis,
        this.letterSpacing,
      })  : style = null,
        fontSize = 12.0,
        fontWeight = FontWeight.w400;

  @override
  Widget build(BuildContext context) {
    // Theme-based smooth dark/light transition
    final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium;

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      style: baseStyle?.copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      ),
    );
  }
}