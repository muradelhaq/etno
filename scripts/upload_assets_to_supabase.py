#!/usr/bin/env python3
"""
Upload all assets from aset-sed directory to Supabase Storage and seed module_assets table.
Supports anon key (after bucket created via SQL) or service_role key (creates bucket automatically).
"""
import os
import sys
import argparse
import mimetypes
import json
import urllib.request
import urllib.error

SUPABASE_URL = "https://lumhlhxbmdtlqmlbcumc.supabase.co"
DEFAULT_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx1bWhsaHhibWR0bHFtbGJjdW1jIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODczMDA0NTMsImV4cCI6MjEwMjg3NjQ1M30.aZQKELiqElVDuRo40HNPLqvUP6Cg8PeDGQuTL9eIhiE"
BUCKET_NAME = "aset-sed"
ASSETS_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "aset-sed")

# Metadata mapping for all 28 assets
ASSET_METADATA = [
    # TEMPE (7 steps)
    {
        "filename": "kedelai-tempe.jpeg",
        "module_id": "tempe",
        "category": "process_step",
        "step_number": 1,
        "title": "Pembersihan & Seleksi Biji Kedelai",
        "description": "Biji kedelai kuning (Glycine max) berkualitas tinggi dicuci bersih dan disortir dari kotoran serta biji yang rusak.",
        "biological_context": "Biji kedelai kaya akan protein globulin (glisinin & konglisinin) dan lipid sebagai substrat utama kapang Rhizopus.",
    },
    {
        "filename": "perendaman-tempe.jpeg",
        "module_id": "tempe",
        "category": "process_step",
        "step_number": 2,
        "title": "Perendaman Biji Kedelai",
        "description": "Kedelai direndam dalam air bersih selama 12–24 jam pada suhu ruang.",
        "biological_context": "Terjadi fermentasi asam laktat spontan alami yang menurunkan pH menjadi 4.5–5.0, menghambat bakteri pembusuk patogen.",
    },
    {
        "filename": "perebusan-tempe.jpeg",
        "module_id": "tempe",
        "category": "process_step",
        "step_number": 3,
        "title": "Perebusan & Pengupasan Kulit Ari",
        "description": "Kedelai direbus hingga matang melunak, lalu kulit ari dikupas dengan cara diremas.",
        "biological_context": "Suhu tinggi mendenaturasi zat antigizi antitripsin dan melunakkan struktur biji agar mudah ditembus hifa kapang.",
    },
    {
        "filename": "ragi-tempe.jpeg",
        "module_id": "tempe",
        "category": "process_step",
        "step_number": 4,
        "title": "Penirisan, Pendinginan & Inokulasi Ragi",
        "description": "Kedelai ditiriskan hingga kering permukaannya dan dingin, lalu ditaburi ragi Rhizopus secara merata.",
        "biological_context": "Spora kapang Rhizopus oligosporus peka panas; inokulasi harus pada suhu kamar (28–30°C) agar spora tidak mati.",
    },
    {
        "filename": "pembungkusan-tempe.jpeg",
        "module_id": "tempe",
        "category": "process_step",
        "step_number": 5,
        "title": "Pembungkusan (Daun Pisang / Plastik Berlubang)",
        "description": "Kedelai beragi dibungkus daun pisang atau plastik yang diberi lubang-lubang ventilasi mikro.",
        "biological_context": "Rhizopus bersifat aerob obligat; stomata daun pisang atau lubang plastik menyediakan suplai oksigen mikro yang terkendali.",
    },
    {
        "filename": "proses-ferm-tempe.jpeg",
        "module_id": "tempe",
        "category": "process_step",
        "step_number": 6,
        "title": "Inkubasi & Fermentasi Ruang (36–48 Jam)",
        "description": "Bungkusan tempe diperam di tempat tenang dan gelap pada suhu 28–32°C selama 36–48 jam.",
        "biological_context": "Miselium kapang tumbuh lebat merajut biji kedelai menjadi satu kesatuan padat sambil menyekresikan enzim protease ekstraseluler.",
    },
    {
        "filename": "jadi-tempe.jpeg",
        "module_id": "tempe",
        "category": "process_step",
        "step_number": 7,
        "title": "Tempe Matang Siap Konsumsi",
        "description": "Tempe matang sempurna dengan miselium putih kompak, beraroma khas segar, dan bertekstur padat.",
        "biological_context": "Protein kedelai terhidrolisis menjadi asam amino bebas dan peptida sederhana sehingga daya cerna meningkat hingga >85% dan kaya vitamin B12.",
    },

    # TAPE SINGKONG (5 steps + variations)
    {
        "filename": "pase-1-singkong.jpeg",
        "module_id": "tape",
        "category": "process_step",
        "step_number": 1,
        "title": "Pengupasan & Pengerikan Singkong (Fase 1)",
        "description": "Singkong kuning mentega dikupas kulit luarnya dan dikerik lendir kulit arinya hingga bersih.",
        "biological_context": "Pengerikan lendir menghilangkan getah dan mikroba liar tanah yang dapat memicu fermentasi asam tidak terkendali.",
    },
    {
        "filename": "tapesing-fase1.jpeg",
        "module_id": "tape",
        "category": "process_step",
        "step_number": 1,
        "title": "Pemotongan & Persiapan Singkong (Variasi 1)",
        "description": "Singkong dipotong rapi sesuai ukuran standar fermentasi peuyeum tradisional.",
        "biological_context": "Ukuran seragam memastikan pemanasan uap merata saat proses gelatinisasi pengukusan.",
    },
    {
        "filename": "fase-2-singkong.jpeg",
        "module_id": "tape",
        "category": "process_step",
        "step_number": 2,
        "title": "Pencucian & Pembilasan Singkong (Fase 2)",
        "description": "Singkong dicuci bersih berkali-kali dengan air mengalir hingga lendir getah hilang total.",
        "biological_context": "Meminimalkan populasi bakteri kontaminan alami pada permukaan umbi singkong.",
    },
    {
        "filename": "tapesing-fase-2.jpeg",
        "module_id": "tape",
        "category": "process_step",
        "step_number": 2,
        "title": "Pencucian Air Mengalir (Variasi 2)",
        "description": "Pembersihan intensif singkong di wadah beralas bersih sebelum pengukusan.",
        "biological_context": "Menghilangkan residu tanah dan mikroba pembusuk anaerob.",
    },
    {
        "filename": "fase-3-singkong.jpeg",
        "module_id": "tape",
        "category": "process_step",
        "step_number": 3,
        "title": "Pengukusan Singkong (Fase 3 - Gelatinisasi)",
        "description": "Singkong dikukus selama 25–30 menit hingga matang empuk (3/4 matang).",
        "biological_context": "Gelatinisasi pati amilosa & amilopektin melonggarkan ikatan polisakarida agar mudah dihidrolisis enzim amilase ragi.",
    },
    {
        "filename": "tapesing-fase-3.jpeg",
        "module_id": "tape",
        "category": "process_step",
        "step_number": 3,
        "title": "Pengukusan Dandang Tradisional (Variasi 3)",
        "description": "Proses kukus menggunakan dandang uap air mendidih untuk sterilisasi termal substrat.",
        "biological_context": "Pemanasan membunuh mikroba liar dan mengubah struktur kristalin granula pati.",
    },
    {
        "filename": "fase-4-singkong.jpeg",
        "module_id": "tape",
        "category": "process_step",
        "step_number": 4,
        "title": "Pendinginan & Inokulasi Ragi Tape (Fase 4)",
        "description": "Singkong dihamparkan di tampah beralas daun pisang hingga dingin sempurna, lalu ditaburi ragi tape halus.",
        "biological_context": "Suhu di atas 40°C dapat mematikan khamir Saccharomyces cerevisiae; penaburan wajib pada suhu kamar.",
    },
    {
        "filename": "tapesing-fase-4.jpeg",
        "module_id": "tape",
        "category": "process_step",
        "step_number": 4,
        "title": "Inokulasi Ragi Rata (Variasi 4)",
        "description": "Penaburan ragi konsentrasi 1% (b/b) secara merata ke seluruh permukaan singkong.",
        "biological_context": "Kombinasi Amylomyces rouxii dan Saccharomyces cerevisiae untuk sakarifikasi dan fermentasi alkohol.",
    },
    {
        "filename": "fase-5-singkong.jpeg",
        "module_id": "tape",
        "category": "process_step",
        "step_number": 5,
        "title": "Pemeraman Anaerob Daun Pisang (Fase 5)",
        "description": "Singkong beragi ditutup rapat dengan daun pisang dan disimpan selama 2–3 hari.",
        "biological_context": "Kondisi mikroaerofilik mengoptimalkan sintesis glukosa (puncak 51,61% hari ke-2) dan aroma etanol aromatik.",
    },
    {
        "filename": "tapesing-fase-5.jpeg",
        "module_id": "tape",
        "category": "process_step",
        "step_number": 5,
        "title": "Pemeraman Wadah Tertutup (Variasi 5)",
        "description": "Wadah inkubasi disimpan di tempat hangat dan gelap tanpa goncangan.",
        "biological_context": "Menjaga suhu stabil 28–30°C bagi pertumbuhan khamir fermentatif.",
    },
    {
        "filename": "fermentasi-tapesing.jpeg",
        "module_id": "tape",
        "category": "final_product",
        "step_number": 6,
        "title": "Hasil Fermentasi Tape Singkong Manis Legit",
        "description": "Tape singkong matang berair manis legit dengan aroma khas harum alkoholik.",
        "biological_context": "Kandungan glukosa tinggi hasil hidrolisis pati amilum oleh enzim glukoamilase.",
    },
    {
        "filename": "tape-singkong-fermentasi.jpeg",
        "module_id": "tape",
        "category": "final_product",
        "step_number": 6,
        "title": "Tape Singkong Siap Saji",
        "description": "Tekstur lembut pulen siap dinikmati langsung atau diolah menjadi Colenak dan Es Doger.",
        "biological_context": "Kaya akan probiotik alami dan asam organik hasil fermentasi khamir.",
    },

    # TAUCO & OLAHAN TRADISIONAL (9 assets)
    {
        "filename": "ferm-tauco-1.jpeg",
        "module_id": "tauco",
        "category": "process_step",
        "step_number": 1,
        "title": "Perebusan & Pengupasan Kedelai Tauco",
        "description": "Kedelai kuning direbus hingga empuk, ditiriskan, dan dikupas kulit arinya.",
        "biological_context": "Denaturasi protein kedelai mempermudah penetrasi hifa kapang Aspergillus oryzae.",
    },
    {
        "filename": "ferm-tauco-2.jpeg",
        "module_id": "tauco",
        "category": "process_step",
        "step_number": 2,
        "title": "Penirisan & Inokulasi Kapang Koji",
        "description": "Kedelai dicampur tepung beras/terigu lalu diinokulasi spora kapang koji.",
        "biological_context": "Tepung menyediakan sumber karbon awal untuk memicu pertumbuhan miselium kapang.",
    },
    {
        "filename": "ferm-tauco-3.jpeg",
        "module_id": "tauco",
        "category": "process_step",
        "step_number": 3,
        "title": "Fermentasi Padat Koji di Tampah (3–5 Hari)",
        "description": "Kedelai berkapang diinkubasi di tampah bambu hingga terbentuk miselium hijau keemasan.",
        "biological_context": "Aspergillus oryzae memproduksi enzim hidrolase ekstraseluler (protease, peptidase, amilase).",
    },
    {
        "filename": "ferm-tauco-4a.jpeg",
        "module_id": "tauco",
        "category": "process_step",
        "step_number": 4,
        "title": "Fermentasi Moromi Larutan Garam 15–20% (Fase 4A)",
        "description": "Kedelai koji dimasukkan ke dalam tempayan tanah liat berisi larutan garam 15–20%.",
        "biological_context": "Kadar garam tinggi membunuh bakteri patogen dan menyeleksi mikroba halofilik toleran garam.",
    },
    {
        "filename": "ferm-tauco--4.jpeg",
        "module_id": "tauco",
        "category": "process_step",
        "step_number": 4,
        "title": "Penjemuran Tempayan di Bawah Matahari (Fase 4B)",
        "description": "Tempayan moromi dijemur di halaman terbuka selama 2–8 minggu di bawah terik matahari.",
        "biological_context": "Energi termal matahari (35–40°C) merangsang aktivitas bakteri Tetragenococcus halophilus.",
    },
    {
        "filename": "ferm-tauco-5.jpeg",
        "module_id": "tauco",
        "category": "process_step",
        "step_number": 5,
        "title": "Pemasakan Tauco dengan Gula Aren & Rempah (Fase 5A)",
        "description": "Pasta moromi dimasak bersama gula aren, daun salam, lengkuas, dan serai hingga harum kental.",
        "biological_context": "Reaksi Maillard antara asam amino bebas (asam glutamat) dan gula kelapa menghasilkan rasa umami gurih alami.",
    },
    {
        "filename": "ferm-tauco-5a.jpeg",
        "module_id": "tauco",
        "category": "process_step",
        "step_number": 5,
        "title": "Pengadukan & Karamelisasi Tauco (Fase 5B)",
        "description": "Pemasakan perlahan menghasilkan tekstur kental berkilau dan aroma khas tauco Cianjur.",
        "biological_context": "Karamelisasi dan pembentukan senyawa volatil pirazina penghasil aroma gurih.",
    },
    {
        "filename": "sayur-ikan-tauco.jpeg",
        "module_id": "tauco",
        "category": "traditional_food",
        "step_number": 6,
        "title": "Sayur Ikan Tauco Khas Cianjur",
        "description": "Hidangan tradisional ikan kuah santan dengan paduan tauco gurih aromatik nusantara.",
        "biological_context": "Asam glutamat alami dalam tauco bertindak sebagai flavor enhancer alami kaya nutrisi.",
    },
    {
        "filename": "fermentasi-taucoikan.jpeg",
        "module_id": "tauco",
        "category": "traditional_food",
        "step_number": 6,
        "title": "Olahan Ikan Tauco Tradisional",
        "description": "Sajian kuliner warisan etnosains pesisir Jawa Barat berpadu bumbu rempah lokal.",
        "biological_context": "Kombinasi protein hewani dan asam amino nabati terfermentasi meningkatkan bioavailabilitas nutrisi.",
    }
]

def create_storage_bucket(auth_key):
    """Attempt to create public storage bucket using provided key"""
    url = f"{SUPABASE_URL}/storage/v1/bucket"
    payload = {
        "id": BUCKET_NAME,
        "name": BUCKET_NAME,
        "public": True,
        "file_size_limit": 52428800,
        "allowed_mime_types": ["image/jpeg", "image/png", "image/webp", "image/svg+xml"]
    }
    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "apikey": auth_key,
            "Authorization": f"Bearer {auth_key}",
            "Content-Type": "application/json"
        },
        method="POST"
    )
    try:
        with urllib.request.urlopen(req) as resp:
            print(f"✅ Storage bucket '{BUCKET_NAME}' created successfully!")
            return True
    except urllib.error.HTTPError as e:
        msg = e.read().decode()
        if "already exists" in msg.lower() or "duplicate" in msg.lower():
            print(f"ℹ️ Bucket '{BUCKET_NAME}' already exists.")
            return True
        print(f"⚠️ Could not create bucket via API: HTTP {e.code} - {msg}")
        return False
    except Exception as e:
        print(f"⚠️ Bucket create exception: {e}")
        return False

def upload_file(file_path, filename, auth_key):
    mime_type, _ = mimetypes.guess_type(file_path)
    if not mime_type:
        mime_type = "image/jpeg"
    
    with open(file_path, "rb") as f:
        file_bytes = f.read()

    url = f"{SUPABASE_URL}/storage/v1/object/{BUCKET_NAME}/{filename}"
    req = urllib.request.Request(
        url,
        data=file_bytes,
        headers={
            "apikey": auth_key,
            "Authorization": f"Bearer {auth_key}",
            "Content-Type": mime_type,
            "x-upsert": "true",
        },
        method="POST"
    )

    try:
        with urllib.request.urlopen(req) as resp:
            return True, f"{SUPABASE_URL}/storage/v1/object/public/{BUCKET_NAME}/{filename}"
    except urllib.error.HTTPError as e:
        return False, f"HTTP {e.code}: {e.read().decode()}"
    except Exception as e:
        return False, str(e)

def insert_database_row(item, auth_key):
    url = f"{SUPABASE_URL}/rest/v1/module_assets"
    payload = {
        "module_id": item["module_id"],
        "category": item["category"],
        "step_number": item["step_number"],
        "title": item["title"],
        "filename": item["filename"],
        "storage_path": f"{BUCKET_NAME}/{item['filename']}",
        "public_url": f"{SUPABASE_URL}/storage/v1/object/public/{BUCKET_NAME}/{item['filename']}",
        "description": item["description"],
        "biological_context": item["biological_context"],
    }

    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "apikey": auth_key,
            "Authorization": f"Bearer {auth_key}",
            "Content-Type": "application/json",
            "Prefer": "resolution=merge-duplicates",
        },
        method="POST"
    )

    try:
        with urllib.request.urlopen(req) as resp:
            return True, "Success"
    except urllib.error.HTTPError as e:
        return False, f"HTTP {e.code}: {e.read().decode()}"
    except Exception as e:
        return False, str(e)

def main():
    parser = argparse.ArgumentParser(description="Upload asset-sed files to Supabase Storage & Database")
    parser.add_argument("--service-key", help="Supabase service_role key", default=os.getenv("SUPABASE_SERVICE_ROLE_KEY"))
    parser.add_argument("--anon-key", help="Supabase anon key", default=DEFAULT_ANON_KEY)
    args = parser.parse_args()

    auth_key = args.service_key or args.anon_key
    print("================================================================")
    print(" 🚀 SUPABASE ASSET-SED UPLOADER & SEED TOOL")
    print(f" URL: {SUPABASE_URL}")
    print(f" Bucket: {BUCKET_NAME}")
    print(f" Source: {ASSETS_DIR}")
    print(f" Key Mode: {'SERVICE ROLE KEY' if args.service_key else 'ANON KEY'}")
    print("================================================================")

    if args.service_key:
        print("\n[Step 1] Creating/verifying bucket with service key...")
        create_storage_bucket(args.service_key)

    total = len(ASSET_METADATA)
    success_uploads = 0
    success_seeds = 0

    print(f"\n[Step 2] Uploading {total} assets to Storage & Seeding Database...")
    for idx, item in enumerate(ASSET_METADATA, 1):
        filename = item["filename"]
        file_path = os.path.join(ASSETS_DIR, filename)

        if not os.path.exists(file_path):
            print(f"[{idx}/{total}] ⚠️ File not found: {filename}")
            continue

        size_mb = os.path.getsize(file_path) / (1024 * 1024)
        print(f"[{idx:02d}/{total:02d}] ({size_mb:.2f} MB) {filename:30} ... ", end="", flush=True)

        up_ok, up_msg = upload_file(file_path, filename, auth_key)
        if up_ok:
            success_uploads += 1
            db_ok, db_msg = insert_database_row(item, auth_key)
            if db_ok:
                success_seeds += 1
                print("✅ Storage OK + DB Seed OK")
            else:
                print(f"✅ Storage OK | ⚠️ DB error: {db_msg}")
        else:
            print(f"❌ Storage Failed: {up_msg}")

    print("\n================================================================")
    print(f" 📊 SUMMARY: {success_uploads}/{total} uploaded, {success_seeds}/{total} DB seeded")
    print("================================================================")

    if success_uploads < total:
        print("\n💡 PETUNJUK:")
        print("Jika Storage gagal karena 'Bucket not found' atau 'AccessDenied':")
        print("1. Buka Supabase Dashboard: https://supabase.com/dashboard/project/lumhlhxbmdtlqmlbcumc")
        print("2. Buka menu SQL Editor, lalu jalankan file SQL yang sudah disiapkan:")
        print("   supabase/migrations/20260825_create_module_assets_and_storage.sql")
        print("3. Setelah itu, jalankan kembali script ini: python3 scripts/upload_assets_to_supabase.py")

if __name__ == "__main__":
    main()
