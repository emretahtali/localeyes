import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarouselPlaceCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const CarouselPlaceCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.85,
      height: 600,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Görsel Alanı - Flex değerini artırdım
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Görsel üzerinde gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 100, // Gradient yüksekliğini artırdım
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Başlık
                  Positioned(
                    bottom: 16, // Alt boşluğu artırdım
                    left: 16, // Sol boşluğu artırdım
                    child: AutoSizeText(
                      title,
                      presetFontSizes: [
                        24,
                        20,
                        16
                      ], // Font boyutlarını artırdım
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // İçerik Alanı
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(20), // Padding'i artırdım
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    maxLines: 7, // Satır sayısını artırdım
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.black87,
                      fontSize: 16, // Font boyutunu artırdım
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  // Alt Kısım
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.location_on_outlined,
                          size: 20, // Icon boyutunu artırdım
                        ),
                        label: Text(
                          'See location',
                          style: GoogleFonts.inter(
                            fontSize: 15, // Font boyutunu artırdım
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12, // Padding'i artırdım
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
