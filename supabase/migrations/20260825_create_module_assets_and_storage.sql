-- ============================================================================
-- MIGRATION: 20260825_create_module_assets_and_storage.sql
-- DESCRIPTION: Setup storage bucket 'aset-sed', RLS policies, and 'module_assets' table.
-- ============================================================================

-- 1. SETUP STORAGE BUCKET 'aset-sed'
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'aset-sed',
  'aset-sed',
  true,
  52428800, -- 50MB per file limit
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/svg+xml']
)
ON CONFLICT (id) DO UPDATE SET
  public = true,
  file_size_limit = 52428800,
  allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/svg+xml'];

-- 2. STORAGE ROW LEVEL SECURITY (RLS) POLICIES FOR 'aset-sed'
-- Public read access
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'objects' AND schemaname = 'storage' AND policyname = 'Public Access for aset-sed'
  ) THEN
    CREATE POLICY "Public Access for aset-sed"
    ON storage.objects FOR SELECT
    TO public
    USING (bucket_id = 'aset-sed');
  END IF;
END $$;

-- Public insert / upload access
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'objects' AND schemaname = 'storage' AND policyname = 'Public Insert for aset-sed'
  ) THEN
    CREATE POLICY "Public Insert for aset-sed"
    ON storage.objects FOR INSERT
    TO public
    WITH CHECK (bucket_id = 'aset-sed');
  END IF;
END $$;

-- Public update / overwrite access
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'objects' AND schemaname = 'storage' AND policyname = 'Public Update for aset-sed'
  ) THEN
    CREATE POLICY "Public Update for aset-sed"
    ON storage.objects FOR UPDATE
    TO public
    USING (bucket_id = 'aset-sed')
    WITH CHECK (bucket_id = 'aset-sed');
  END IF;
END $$;

-- 3. CREATE TABLE 'public.module_assets'
CREATE TABLE IF NOT EXISTS public.module_assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  module_id TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'process_step',
  step_number INT,
  title TEXT NOT NULL,
  filename TEXT NOT NULL UNIQUE,
  storage_path TEXT NOT NULL,
  public_url TEXT NOT NULL,
  description TEXT,
  biological_context TEXT,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- Enable RLS on module_assets
ALTER TABLE public.module_assets ENABLE ROW LEVEL SECURITY;

-- Policies for public.module_assets
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'module_assets' AND schemaname = 'public' AND policyname = 'Allow public read on module_assets'
  ) THEN
    CREATE POLICY "Allow public read on module_assets"
    ON public.module_assets FOR SELECT
    TO public
    USING (true);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'module_assets' AND schemaname = 'public' AND policyname = 'Allow public insert on module_assets'
  ) THEN
    CREATE POLICY "Allow public insert on module_assets"
    ON public.module_assets FOR INSERT
    TO public
    WITH CHECK (true);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'module_assets' AND schemaname = 'public' AND policyname = 'Allow public update on module_assets'
  ) THEN
    CREATE POLICY "Allow public update on module_assets"
    ON public.module_assets FOR UPDATE
    TO public
    USING (true)
    WITH CHECK (true);
  END IF;
END $$;

-- Indexes
CREATE INDEX IF NOT EXISTS idx_module_assets_module_id ON public.module_assets (module_id);
CREATE INDEX IF NOT EXISTS idx_module_assets_category ON public.module_assets (category);
CREATE INDEX IF NOT EXISTS idx_module_assets_step_number ON public.module_assets (module_id, step_number);

-- 4. SEED DATA FOR ALL 28 ASSETS
INSERT INTO public.module_assets (module_id, category, step_number, title, filename, storage_path, public_url, description, biological_context)
VALUES
  -- TEMPE (7 Langkah Proses)
  (
    'tempe',
    'process_step',
    1,
    'Pembersihan & Seleksi Biji Kedelai',
    'kedelai-tempe.jpeg',
    'aset-sed/kedelai-tempe.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/kedelai-tempe.jpeg',
    'Biji kedelai kuning (Glycine max) berkualitas tinggi dicuci bersih dan disortir dari kotoran serta biji yang rusak.',
    'Biji kedelai kaya akan protein globulin (glisinin & konglisinin) dan lipid sebagai substrat utama kapang Rhizopus.'
  ),
  (
    'tempe',
    'process_step',
    2,
    'Perendaman Biji Kedelai',
    'perendaman-tempe.jpeg',
    'aset-sed/perendaman-tempe.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/perendaman-tempe.jpeg',
    'Kedelai direndam dalam air bersih selama 12–24 jam pada suhu ruang.',
    'Terjadi fermentasi asam laktat spontan alami yang menurunkan pH menjadi 4.5–5.0, menghambat bakteri pembusuk patogen.'
  ),
  (
    'tempe',
    'process_step',
    3,
    'Perebusan & Pengupasan Kulit Ari',
    'perebusan-tempe.jpeg',
    'aset-sed/perebusan-tempe.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/perebusan-tempe.jpeg',
    'Kedelai direbus hingga matang melunak, lalu kulit ari dikupas dengan cara diremas.',
    'Suhu tinggi mendenaturasi zat antigizi antitripsin dan melunakkan struktur biji agar mudah ditembus hifa kapang.'
  ),
  (
    'tempe',
    'process_step',
    4,
    'Penirisan, Pendinginan & Inokulasi Ragi',
    'ragi-tempe.jpeg',
    'aset-sed/ragi-tempe.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/ragi-tempe.jpeg',
    'Kedelai ditiriskan hingga kering permukaannya dan dingin, lalu ditaburi ragi Rhizopus secara merata.',
    'Spora kapang Rhizopus oligosporus peka panas; inokulasi harus pada suhu kamar (28–30°C) agar spora tidak mati.'
  ),
  (
    'tempe',
    'process_step',
    5,
    'Pembungkusan (Daun Pisang / Plastik Berlubang)',
    'pembungkusan-tempe.jpeg',
    'aset-sed/pembungkusan-tempe.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/pembungkusan-tempe.jpeg',
    'Kedelai beragi dibungkus daun pisang atau plastik yang diberi lubang-lubang ventilasi mikro.',
    'Rhizopus bersifat aerob obligat; stomata daun pisang atau lubang plastik menyediakan suplai oksigen mikro yang terkendali.'
  ),
  (
    'tempe',
    'process_step',
    6,
    'Inkubasi & Fermentasi Ruang (36–48 Jam)',
    'proses-ferm-tempe.jpeg',
    'aset-sed/proses-ferm-tempe.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/proses-ferm-tempe.jpeg',
    'Bungkusan tempe diperam di tempat tenang dan gelap pada suhu 28–32°C selama 36–48 jam.',
    'Miselium kapang tumbuh lebat merajut biji kedelai menjadi satu kesatuan padat sambil menyekresikan enzim protease ekstraseluler.'
  ),
  (
    'tempe',
    'process_step',
    7,
    'Tempe Matang Siap Konsumsi',
    'jadi-tempe.jpeg',
    'aset-sed/jadi-tempe.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/jadi-tempe.jpeg',
    'Tempe matang sempurna dengan miselium putih kompak, beraroma khas segar, dan bertekstur padat.',
    'Protein kedelai terhidrolisis menjadi asam amino bebas dan peptida sederhana sehingga daya cerna meningkat hingga >85% dan kaya vitamin B12.'
  ),

  -- TAPE SINGKONG (Fase 1–5 & Produk Jadi)
  (
    'tape',
    'process_step',
    1,
    'Pengupasan & Pengerikan Singkong (Fase 1)',
    'pase-1-singkong.jpeg',
    'aset-sed/pase-1-singkong.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/pase-1-singkong.jpeg',
    'Singkong kuning mentega dikupas kulit luarnya dan dikerik lendir kulit arinya hingga bersih.',
    'Pengerikan lendir menghilangkan getah dan mikroba liar tanah yang dapat memicu fermentasi asam tidak terkendali.'
  ),
  (
    'tape',
    'process_step',
    1,
    'Pemotongan & Persiapan Singkong (Variasi 1)',
    'tapesing-fase1.jpeg',
    'aset-sed/tapesing-fase1.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/tapesing-fase1.jpeg',
    'Singkong dipotong rapi sesuai ukuran standar fermentasi peuyeum tradisional.',
    'Ukuran seragam memastikan pemanasan uap merata saat proses gelatinisasi pengukusan.'
  ),
  (
    'tape',
    'process_step',
    2,
    'Pencucian & Pembilasan Singkong (Fase 2)',
    'fase-2-singkong.jpeg',
    'aset-sed/fase-2-singkong.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/fase-2-singkong.jpeg',
    'Singkong dicuci bersih berkali-kali dengan air mengalir hingga lendir getah hilang total.',
    'Meminimalkan populasi bakteri kontaminan alami pada permukaan umbi singkong.'
  ),
  (
    'tape',
    'process_step',
    2,
    'Pencucian Air Mengalir (Variasi 2)',
    'tapesing-fase-2.jpeg',
    'aset-sed/tapesing-fase-2.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/tapesing-fase-2.jpeg',
    'Pembersihan intensif singkong di wadah beralas bersih sebelum pengukusan.',
    'Menghilangkan residu tanah dan mikroba pembusuk anaerob.'
  ),
  (
    'tape',
    'process_step',
    3,
    'Pengukusan Singkong (Fase 3 - Gelatinisasi)',
    'fase-3-singkong.jpeg',
    'aset-sed/fase-3-singkong.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/fase-3-singkong.jpeg',
    'Singkong dikukus selama 25–30 menit hingga matang empuk (3/4 matang).',
    'Gelatinisasi pati amilosa & amilopektin melonggarkan ikatan polisakarida agar mudah dihidrolisis enzim amilase ragi.'
  ),
  (
    'tape',
    'process_step',
    3,
    'Pengukusan Dandang Tradisional (Variasi 3)',
    'tapesing-fase-3.jpeg',
    'aset-sed/tapesing-fase-3.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/tapesing-fase-3.jpeg',
    'Proses kukus menggunakan dandang uap air mendidih untuk sterilisasi termal substrat.',
    'Pemanasan membunuh mikroba liar dan mengubah struktur kristalin granula pati.'
  ),
  (
    'tape',
    'process_step',
    4,
    'Pendinginan & Inokulasi Ragi Tape (Fase 4)',
    'fase-4-singkong.jpeg',
    'aset-sed/fase-4-singkong.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/fase-4-singkong.jpeg',
    'Singkong dihamparkan di tampah beralas daun pisang hingga dingin sempurna, lalu ditaburi ragi tape halus.',
    'Suhu di atas 40°C dapat mematikan khamir Saccharomyces cerevisiae; penaburan wajib pada suhu kamar.'
  ),
  (
    'tape',
    'process_step',
    4,
    'Inokulasi Ragi Rata (Variasi 4)',
    'tapesing-fase-4.jpeg',
    'aset-sed/tapesing-fase-4.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/tapesing-fase-4.jpeg',
    'Penaburan ragi konsentrasi 1% (b/b) secara merata ke seluruh permukaan singkong.',
    'Kombinasi Amylomyces rouxii dan Saccharomyces cerevisiae untuk sakarifikasi dan fermentasi alkohol.'
  ),
  (
    'tape',
    'process_step',
    5,
    'Pemeraman Anaerob Daun Pisang (Fase 5)',
    'fase-5-singkong.jpeg',
    'aset-sed/fase-5-singkong.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/fase-5-singkong.jpeg',
    'Singkong beragi ditutup rapat dengan daun pisang dan disimpan selama 2–3 hari.',
    'Kondisi mikroaerofilik mengoptimalkan sintesis glukosa (puncak 51,61% hari ke-2) dan aroma etanol aromatik.'
  ),
  (
    'tape',
    'process_step',
    5,
    'Pemeraman Wadah Tertutup (Variasi 5)',
    'tapesing-fase-5.jpeg',
    'aset-sed/tapesing-fase-5.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/tapesing-fase-5.jpeg',
    'Wadah inkubasi disimpan di tempat hangat dan gelap tanpa goncangan.',
    'Menjaga suhu stabil 28–30°C bagi pertumbuhan khamir fermentatif.'
  ),
  (
    'tape',
    'final_product',
    6,
    'Hasil Fermentasi Tape Singkong Manis Legit',
    'fermentasi-tapesing.jpeg',
    'aset-sed/fermentasi-tapesing.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/fermentasi-tapesing.jpeg',
    'Tape singkong matang berair manis legit dengan aroma khas harum alkoholik.',
    'Kandungan glukosa tinggi hasil hidrolisis pati amilum oleh enzim glukoamilase.'
  ),
  (
    'tape',
    'final_product',
    6,
    'Tape Singkong Siap Saji',
    'tape-singkong-fermentasi.jpeg',
    'aset-sed/tape-singkong-fermentasi.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/tape-singkong-fermentasi.jpeg',
    'Tekstur lembut pulen siap dinikmati langsung atau diolah menjadi Colenak dan Es Doger.',
    'Kaya akan probiotik alami dan asam organik hasil fermentasi khamir.'
  ),

  -- TAUCO & OLAHAN TRADISIONAL (9 Assets)
  (
    'tauco',
    'process_step',
    1,
    'Perebusan & Pengupasan Kedelai Tauco',
    'ferm-tauco-1.jpeg',
    'aset-sed/ferm-tauco-1.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/ferm-tauco-1.jpeg',
    'Kedelai kuning direbus hingga empuk, ditiriskan, dan dikupas kulit arinya.',
    'Denaturasi protein kedelai mempermudah penetrasi hifa kapang Aspergillus oryzae.'
  ),
  (
    'tauco',
    'process_step',
    2,
    'Penirisan & Inokulasi Kapang Koji',
    'ferm-tauco-2.jpeg',
    'aset-sed/ferm-tauco-2.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/ferm-tauco-2.jpeg',
    'Kedelai dicampur tepung beras/terigu lalu diinokulasi spora kapang koji.',
    'Tepung menyediakan sumber karbon awal untuk memicu pertumbuhan miselium kapang.'
  ),
  (
    'tauco',
    'process_step',
    3,
    'Fermentasi Padat Koji di Tampah (3–5 Hari)',
    'ferm-tauco-3.jpeg',
    'aset-sed/ferm-tauco-3.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/ferm-tauco-3.jpeg',
    'Kedelai berkapang diinkubasi di tampah bambu hingga terbentuk miselium hijau keemasan.',
    'Aspergillus oryzae memproduksi enzim hidrolase ekstraseluler (protease, peptidase, amilase).'
  ),
  (
    'tauco',
    'process_step',
    4,
    'Fermentasi Moromi Larutan Garam 15–20% (Fase 4A)',
    'ferm-tauco-4a.jpeg',
    'aset-sed/ferm-tauco-4a.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/ferm-tauco-4a.jpeg',
    'Kedelai koji dimasukkan ke dalam tempayan tanah liat berisi larutan garam 15–20%.',
    'Kadar garam tinggi membunuh bakteri patogen dan menyeleksi mikroba halofilik toleran garam.'
  ),
  (
    'tauco',
    'process_step',
    4,
    'Penjemuran Tempayan di Bawah Matahari (Fase 4B)',
    'ferm-tauco--4.jpeg',
    'aset-sed/ferm-tauco--4.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/ferm-tauco--4.jpeg',
    'Tempayan moromi dijemur di halaman terbuka selama 2–8 minggu di bawah terik matahari.',
    'Energi termal matahari (35–40°C) merangsang aktivitas bakteri Tetragenococcus halophilus.'
  ),
  (
    'tauco',
    'process_step',
    5,
    'Pemasakan Tauco dengan Gula Aren & Rempah (Fase 5A)',
    'ferm-tauco-5.jpeg',
    'aset-sed/ferm-tauco-5.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/ferm-tauco-5.jpeg',
    'Pasta moromi dimasak bersama gula aren, daun salam, lengkuas, dan serai hingga harum kental.',
    'Reaksi Maillard antara asam amino bebas (asam glutamat) dan gula kelapa menghasilkan rasa umami gurih alami.'
  ),
  (
    'tauco',
    'process_step',
    5,
    'Pengadukan & Karamelisasi Tauco (Fase 5B)',
    'ferm-tauco-5a.jpeg',
    'aset-sed/ferm-tauco-5a.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/ferm-tauco-5a.jpeg',
    'Pemasakan perlahan menghasilkan tekstur kental berkilau dan aroma khas tauco Cianjur.',
    'Karamelisasi dan pembentukan senyawa volatil pirazina penghasil aroma gurih.'
  ),
  (
    'tauco',
    'traditional_food',
    6,
    'Sayur Ikan Tauco Khas Cianjur',
    'sayur-ikan-tauco.jpeg',
    'aset-sed/sayur-ikan-tauco.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/sayur-ikan-tauco.jpeg',
    'Hidangan tradisional ikan kuah santan dengan paduan tauco gurih aromatik nusantara.',
    'Asam glutamat alami dalam tauco bertindak sebagai flavor enhancer alami kaya nutrisi.'
  ),
  (
    'tauco',
    'traditional_food',
    6,
    'Olahan Ikan Tauco Tradisional',
    'fermentasi-taucoikan.jpeg',
    'aset-sed/fermentasi-taucoikan.jpeg',
    'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/aset-sed/fermentasi-taucoikan.jpeg',
    'Sajian kuliner warisan etnosains pesisir Jawa Barat berpadu bumbu rempah lokal.',
    'Kombinasi protein hewani dan asam amino nabati terfermentasi meningkatkan bioavailabilitas nutrisi.'
  )
ON CONFLICT (filename) DO UPDATE SET
  module_id = EXCLUDED.module_id,
  category = EXCLUDED.category,
  step_number = EXCLUDED.step_number,
  title = EXCLUDED.title,
  storage_path = EXCLUDED.storage_path,
  public_url = EXCLUDED.public_url,
  description = EXCLUDED.description,
  biological_context = EXCLUDED.biological_context;
