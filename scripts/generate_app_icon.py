import math
import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def create_launcher_icon(size=1024):
    # 1. Base image with gradient background (Splash Ambient Background)
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    
    # Background gradient: 
    # (0x0F, 0x2E, 0x22) -> (0x1B, 0x43, 0x32) -> (0x2D, 0x6A, 0x4F) -> (0x08, 0x1C, 0x15)
    bg = Image.new("RGBA", (size, size))
    bg_draw = ImageDraw.Draw(bg)
    
    c1 = (15, 46, 34)
    c2 = (27, 67, 50)
    c3 = (45, 106, 79)
    c4 = (8, 28, 21)
    
    for y in range(size):
        for x in range(size):
            # Diagonal gradient factor from 0.0 to 1.0
            t = (x + y) / (2.0 * size)
            if t < 0.35:
                f = t / 0.35
                r = int(c1[0] + (c2[0] - c1[0]) * f)
                g = int(c1[1] + (c2[1] - c1[1]) * f)
                b = int(c1[2] + (c2[2] - c1[2]) * f)
            elif t < 0.70:
                f = (t - 0.35) / 0.35
                r = int(c2[0] + (c3[0] - c2[0]) * f)
                g = int(c2[1] + (c3[1] - c2[1]) * f)
                b = int(c2[2] + (c3[2] - c2[2]) * f)
            else:
                f = (t - 0.70) / 0.30
                r = int(c3[0] + (c4[0] - c3[0]) * f)
                g = int(c3[1] + (c4[1] - c3[1]) * f)
                b = int(c3[2] + (c4[2] - c3[2]) * f)
            bg.putpixel((x, y), (r, g, b, 255))
            
    img = bg
    
    # 2. Add subtle ambient glow in background
    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    # top right golden glow
    glow_draw.ellipse([size - 300, -100, size + 200, 400], fill=(221, 161, 94, 25))
    # bottom left green glow
    glow_draw.ellipse([-150, size - 400, 350, size + 100], fill=(82, 183, 136, 25))
    glow = glow.filter(ImageFilter.GaussianBlur(40))
    img = Image.alpha_composite(img, glow)
    
    # 3. Main Circular Emblem
    # Emblem diameter ~ 70% of size (716 px) so it sits inside adaptive icon safe area (66%-72%)
    center = size / 2.0
    radius = int(size * 0.36) # 368px radius -> 736px diameter
    
    # Golden glow / drop shadow behind emblem
    shadow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    s_draw = ImageDraw.Draw(shadow)
    # Dark shadow
    s_draw.ellipse([center - radius, center - radius + 16, center + radius, center + radius + 16], fill=(0, 0, 0, 110))
    # Golden halo
    s_draw.ellipse([center - radius - 8, center - radius - 8, center + radius + 8, center + radius + 8], fill=(221, 161, 94, 90))
    shadow = shadow.filter(ImageFilter.GaussianBlur(24))
    img = Image.alpha_composite(img, shadow)
    
    # Emblem circle image with gradient
    emblem = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    e_draw = ImageDraw.Draw(emblem)
    
    ec1 = (82, 183, 136) # 0xFF52B788
    ec2 = (45, 106, 79)  # 0xFF2D6A4F
    ec3 = (27, 67, 50)   # 0xFF1B4332
    
    emblem_mask = Image.new("L", (size, size), 0)
    m_draw = ImageDraw.Draw(emblem_mask)
    m_draw.ellipse([center - radius, center - radius, center + radius, center + radius], fill=255)
    
    emblem_grad = Image.new("RGBA", (size, size))
    for y in range(int(center - radius), int(center + radius) + 1):
        for x in range(int(center - radius), int(center + radius) + 1):
            t = (x - (center - radius) + y - (center - radius)) / (4.0 * radius)
            t = max(0.0, min(1.0, t))
            if t < 0.5:
                f = t / 0.5
                r = int(ec1[0] + (ec2[0] - ec1[0]) * f)
                g = int(ec1[1] + (ec2[1] - ec1[1]) * f)
                b = int(ec1[2] + (ec2[2] - ec1[2]) * f)
            else:
                f = (t - 0.5) / 0.5
                r = int(ec2[0] + (ec3[0] - ec2[0]) * f)
                g = int(ec2[1] + (ec3[1] - ec2[1]) * f)
                b = int(ec2[2] + (ec3[2] - ec2[2]) * f)
            emblem_grad.putpixel((x, y), (r, g, b, 255))
            
    emblem.paste(emblem_grad, (0, 0), emblem_mask)
    
    # Gold border
    border_width = int(size * 0.018) # ~18px
    e_draw.ellipse([center - radius, center - radius, center + radius, center + radius], outline=(221, 161, 94, 220), width=border_width)
    
    # Font for icons
    font_path = "/home/muradelhaq/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf"
    
    # Center Icon: spa_rounded (0xf01ad) in warm cream (0xFFFEFAE0)
    spa_size = int(radius * 0.98) # ~360px
    spa_font = ImageFont.truetype(font_path, spa_size)
    spa_char = chr(0xf01ad)
    
    # Get text bounding box to center perfectly
    bbox = spa_font.getbbox(spa_char)
    spa_w = bbox[2] - bbox[0]
    spa_h = bbox[3] - bbox[1]
    spa_x = center - (bbox[0] + bbox[2]) / 2.0
    spa_y = center - (bbox[1] + bbox[3]) / 2.0 - 10 # slight visual optical balance
    e_draw.text((spa_x, spa_y), spa_char, font=spa_font, fill=(254, 250, 224, 255))
    
    # Sub-badge at bottom-right:
    # Circle with warm terracotta background (0xFFBC6C25) and white border
    badge_radius = int(radius * 0.32) # ~118px radius (236px diameter)
    badge_cx = center + radius * 0.55
    badge_cy = center + radius * 0.55
    
    # Badge shadow
    b_shadow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    bs_draw = ImageDraw.Draw(b_shadow)
    bs_draw.ellipse([badge_cx - badge_radius, badge_cy - badge_radius + 8, badge_cx + badge_radius, badge_cy + badge_radius + 8], fill=(0, 0, 0, 90))
    b_shadow = b_shadow.filter(ImageFilter.GaussianBlur(10))
    emblem = Image.alpha_composite(emblem, b_shadow)
    e_draw = ImageDraw.Draw(emblem)
    
    # Badge circle
    e_draw.ellipse([badge_cx - badge_radius, badge_cy - badge_radius, badge_cx + badge_radius, badge_cy + badge_radius], fill=(188, 108, 37, 255), outline=(255, 255, 255, 255), width=int(border_width * 0.65))
    
    # Inside badge: biotech_rounded (0xf5bc) in white
    bio_size = int(badge_radius * 1.1) # ~130px
    bio_font = ImageFont.truetype(font_path, bio_size)
    bio_char = chr(0xf5bc)
    b_bbox = bio_font.getbbox(bio_char)
    bio_x = badge_cx - (b_bbox[0] + b_bbox[2]) / 2.0
    bio_y = badge_cy - (b_bbox[1] + b_bbox[3]) / 2.0
    e_draw.text((bio_x, bio_y), bio_char, font=bio_font, fill=(255, 255, 255, 255))
    
    img = Image.alpha_composite(img, emblem)
    return img

if __name__ == "__main__":
    os.makedirs("assets/images", exist_ok=True)
    out_path = "assets/images/app_icon.png"
    icon = create_launcher_icon(1024)
    icon.save(out_path, "PNG")
    print(f"Master app icon created successfully at {out_path} ({os.path.getsize(out_path)} bytes)")
