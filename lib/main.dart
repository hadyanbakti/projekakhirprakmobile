import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:provider/provider.dart';
// import 'package:projekakhirprak/screens/home_screen.dart'; // No longer the initial screen
import 'package:projekakhirprak/screens/login_screen.dart'; // Import LoginScreen
import 'package:projekakhirprak/services/car_state_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a more professional color scheme
    const primaryColor = Color(0xFF00796B); // Deep Teal
    const accentColor = Color(0xFFFFC107);  // Amber/Gold
    final lightGrey = Colors.grey[100];
    final darkText = Colors.grey[800];

    // Define TextTheme
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.montserrat(fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5, color: darkText),
      displayMedium: GoogleFonts.montserrat(fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5, color: darkText),
      displaySmall: GoogleFonts.montserrat(fontSize: 48, fontWeight: FontWeight.w400, color: darkText),
      headlineMedium: GoogleFonts.montserrat(fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: darkText),
      headlineSmall: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w400, color: darkText),
      titleLarge: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: darkText),
      titleMedium: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: darkText),
      titleSmall: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: darkText),
      bodyLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: darkText),
      bodyMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: darkText),
      labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25, color: Colors.white), // For buttons
      bodySmall: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: Colors.grey[700]),
      labelSmall: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5, color: Colors.grey[700]),
    );

    return ChangeNotifierProvider(
      create: (context) => CarStateService(),
      child: MaterialApp(
        title: 'Pameran Mobil',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: primaryColor,
          // primarySwatch is not needed if primaryColor is set, but can be generated from primaryColor
          // For simplicity, we'll use primaryColor directly in most places.
          // If you need a full swatch, you can generate one.
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: MaterialColor(primaryColor.value, {
              50: primaryColor.withOpacity(0.1),
              100: primaryColor.withOpacity(0.2),
              200: primaryColor.withOpacity(0.3),
              300: primaryColor.withOpacity(0.4),
              400: primaryColor.withOpacity(0.5),
              500: primaryColor.withOpacity(0.6),
              600: primaryColor.withOpacity(0.7),
              700: primaryColor.withOpacity(0.8),
              800: primaryColor.withOpacity(0.9),
              900: primaryColor.withOpacity(1.0),
            }),
            accentColor: accentColor,
            brightness: Brightness.light,
          ).copyWith(secondary: accentColor), // ensure accentColor is secondary
          scaffoldBackgroundColor: lightGrey,
          textTheme: textTheme,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            color: Colors.white, // Or primaryColor for a colored AppBar
            elevation: 1.0,
            iconTheme: IconThemeData(color: primaryColor), // Icons on AppBar
            titleTextStyle: textTheme.titleLarge?.copyWith(color: darkText), // AppBar title
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey[500],
            selectedLabelStyle: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            unselectedLabelStyle: textTheme.bodySmall,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor, // background (button) color
              foregroundColor: Colors.white, // foreground (text) color
              textStyle: textTheme.labelLarge,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: primaryColor, // text color
              textStyle: textTheme.labelLarge?.copyWith(color: primaryColor),
            )
          ),
          cardTheme: CardTheme(
            elevation: 2.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          ),
           dialogTheme: DialogTheme(
            backgroundColor: Colors.white,
            titleTextStyle: textTheme.titleLarge?.copyWith(color: darkText),
            contentTextStyle: textTheme.bodyMedium?.copyWith(color: darkText),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: primaryColor, width: 2.0),
            ),
            labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
          progressIndicatorTheme: ProgressIndicatorThemeData(
            color: primaryColor,
          )
        ),
        home: const LoginScreen(), // Set LoginScreen as the initial route
        debugShowCheckedModeBanner: false,
      ),
    );
  }
} 