#!/usr/bin/env python3
"""
clean_image.py - Detección y recorte automático de bordes oscuros en capturas técnicas.
Curso: Sistemas Operativos - Facultad de Ingeniería, UNAM.

Propósito:
    Inspecciona las cuatro orillas periféricas (superior, inferior, izquierda, derecha)
    de una imagen para detectar artefactos de captura como bordes negros, grises o marcos
    provenientes de herramientas de captura en modo oscuro, visores de PDF o navegadores.
    Si detecta bordes no blancos, recorta esas filas o columnas periféricas hasta alcanzar
    el fondo blanco uniforme del documento.

Uso:
    python3 clean_image.py <ruta_imagen_o_directorio> [--threshold 245] [--max-crop 25] [--check-only]

Ejemplos:
    python3 clean_image.py media/t08/estructurasControlAcceso.png
    python3 clean_image.py media/t08/ --threshold 240
    python3 clean_image.py media/t08/*.png --check-only
"""

import sys
import argparse
from pathlib import Path
from PIL import Image

def is_line_border(pixels, coords, threshold=245, dark_pixel_limit=180, dark_ratio_threshold=0.03):
    """
    Determina si una fila o columna perimétrica contiene un borde oscuro.
    Una línea se clasifica como borde si:
      1. Su luminosidad promedio está por debajo de `threshold` (ej. < 245), o
      2. Más de un porcentaje mínimo de sus píxeles (`dark_ratio_threshold`) son oscuros (< 180).
    """
    total_lum = 0.0
    dark_count = 0
    n = len(coords)
    if n == 0:
        return False

    for x, y in coords:
        p = pixels[x, y]
        r, g, b = p[0], p[1], p[2]
        # Luminancia percibida ITU-R BT.601
        lum = 0.299 * r + 0.587 * g + 0.114 * b
        total_lum += lum
        if lum < dark_pixel_limit:
            dark_count += 1

    avg_lum = total_lum / n
    dark_ratio = dark_count / n

    return (avg_lum < threshold) or (dark_ratio > dark_ratio_threshold)

def inspect_and_clean_image(img_path: Path, threshold: int = 245, max_crop: int = 25, in_place: bool = True):
    """
    Analiza y opcionalmente recorta los bordes oscuros de una imagen.
    Retorna: (modificada: bool, mensaje: str)
    """
    try:
        with Image.open(img_path) as img:
            rgb_img = img.convert('RGB')
            w, h = img.size
            pixels = rgb_img.load()

            top = 0
            while top < max_crop and top < h // 4:
                coords = [(x, top) for x in range(w)]
                if is_line_border(pixels, coords, threshold):
                    top += 1
                else:
                    break

            bottom = 0
            while bottom < max_crop and bottom < h // 4:
                coords = [(x, h - 1 - bottom) for x in range(w)]
                if is_line_border(pixels, coords, threshold):
                    bottom += 1
                else:
                    break

            left = 0
            while left < max_crop and left < w // 4:
                coords = [(left, y) for y in range(h)]
                if is_line_border(pixels, coords, threshold):
                    left += 1
                else:
                    break

            right = 0
            while right < max_crop and right < w // 4:
                coords = [(w - 1 - right, y) for y in range(h)]
                if is_line_border(pixels, coords, threshold):
                    right += 1
                else:
                    break

            if top == 0 and bottom == 0 and left == 0 and right == 0:
                return False, f"[OK] {img_path}: bordes limpios ({w}x{h} px)"

            new_w = w - left - right
            new_h = h - top - bottom

            if in_place:
                box = (left, top, w - right, h - bottom)
                cropped = img.crop(box)
                cropped.save(img_path)
                return True, (f"[RECORTADO] {img_path}: borde oscuro eliminado "
                              f"(T={top}px, B={bottom}px, L={left}px, R={right}px) | "
                              f"{w}x{h} -> {new_w}x{new_h} px")
            else:
                return True, (f"[DETECTADO] {img_path}: requiere recorte "
                              f"(T={top}px, B={bottom}px, L={left}px, R={right}px) | "
                              f"{w}x{h} -> {new_w}x{new_h} px")

    except Exception as e:
        return False, f"[ERROR] No se pudo procesar {img_path}: {e}"

def main():
    parser = argparse.ArgumentParser(
        description="Detección y eliminación automática de bordes oscuros en capturas."
    )
    parser.add_argument("paths", nargs="+", help="Ruta de imagen(es) o directorio(s) a procesar")
    parser.add_argument("--threshold", type=int, default=245,
                        help="Umbral de luminosidad para considerar fondo blanco (default: 245)")
    parser.add_argument("--max-crop", type=int, default=25,
                        help="Máximo de píxeles a recortar por lado (default: 25)")
    parser.add_argument("--check-only", action="store_true",
                        help="Solo verificar sin sobrescribir la imagen")

    args = parser.parse_args()

    target_files = []
    valid_exts = {".png", ".jpg", ".jpeg", ".webp", ".bmp", ".tiff"}

    for p_str in args.paths:
        p = Path(p_str)
        if p.is_dir():
            for f in p.iterdir():
                if f.suffix.lower() in valid_exts and f.name != "example_figure.png":
                    target_files.append(f)
        elif p.is_file():
            if p.suffix.lower() in valid_exts:
                target_files.append(p)
        else:
            # Handle globs if passed unexpanded
            parent = p.parent if str(p.parent) != "" else Path(".")
            pattern = p.name
            for f in parent.glob(pattern):
                if f.is_file() and f.suffix.lower() in valid_exts:
                    target_files.append(f)

    if not target_files:
        print("[AVISO] No se encontraron archivos de imagen válidos.")
        sys.exit(0)

    any_modified = False
    for img_path in sorted(set(target_files)):
        modified, msg = inspect_and_clean_image(
            img_path,
            threshold=args.threshold,
            max_crop=args.max_crop,
            in_place=not args.check_only
        )
        print(msg)
        if modified:
            any_modified = True

if __name__ == "__main__":
    main()
