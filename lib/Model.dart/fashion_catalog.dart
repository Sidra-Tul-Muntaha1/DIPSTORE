

import 'package:DIPSTORE/Model.dart/Productmodel.dart';

class FashionCatalog {
  static final List<Product> curatedClothing = [
    // ==========================================
    // --- 1. ZARA ---
    // ==========================================
    Product(
      id: 501,
      title: "Elbow Patch Woolen Blazer",
      price: "\$149.00",
      oldPrice: "\$189.00",
      image: "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&q=80",
      category: "jackets",
      brand: "Zara",
      rating: 4.8,
      description:
          "Classic tailored blazer featuring elbow patch details, notched lapels, and premium wool blend fabric. Perfect for both formal and elevated casual wear.",
    ),
    Product(
      id: 502,
      title: "Corduroy Overshirt",
      price: "\$49.99",
      oldPrice: "\$69.99",
      image: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&q=80",
      category: "shirts",
      brand: "Zara",
      rating: 4.6,
      description:
          "Textured cotton corduroy overshirt with front button fastening and flap chest pockets. Comfortable relaxed fit for effortless layering.",
    ),
    Product(
      id: 503,
      title: "Mid-Length Woolen Coat",
      price: "\$89.00",
      oldPrice: "\$129.00",
      image: "https://images.unsplash.com/photo-1539533018447-63fcce667823?w=800&q=80",
      category: "jackets",
      brand: "Zara",
      rating: 4.9,
      description:
          "Elegant mid-length coat crafted from a warm wool blend. Features a structured silhouette, lapel collar, and matching button front.",
    ),
    Product(
      id: 504,
      title: "Pleated Satin Midi Dress",
      price: "\$59.90",
      oldPrice: "\$79.90",
      image: "https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800&q=80",
      category: "dresses",
      brand: "Zara",
      rating: 4.5,
      description:
          "Fluid satin midi dress with delicate pleating throughout, V-neckline, and an elasticated waistline for a flattering fit.",
    ),
    Product(
      id: 505,
      title: "Wide-Leg Tailored Trousers",
      price: "\$69.90",
      oldPrice: "\$89.90",
      image: "https://images.unsplash.com/photo-1509551388413-e18d0ac5d495?w=800&q=80",
      category: "trousers",
      brand: "Zara",
      rating: 4.7,
      description:
          "High-waisted flowing trousers with front pleats, side slash pockets, and a clean wide-leg cut.",
    ),
    Product(
      id: 506,
      title: "Double-Breasted Classic Trench Coat",
      price: "\$139.00",
      oldPrice: "\$179.00",
      image: "https://images.unsplash.com/photo-1544441893-675973e31985?w=800&q=80",
      category: "jackets",
      brand: "Zara",
      rating: 4.8,
      description:
          "Water-repellent cotton blend trench coat with storm flap, waist belt, buckled cuffs, and tortoiseshell buttons.",
    ),
    Product(
      id: 507,
      title: "Chunky Ribbed Knit Turtleneck",
      price: "\$59.00",
      oldPrice: "\$75.00",
      image: "https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=800&q=80",
      category: "knitwear",
      brand: "Zara",
      rating: 4.6,
      description:
          "Cozy heavy-knit sweater crafted from spun yarn with dropped shoulders, ribbed cuffs, and fold-over turtleneck collar.",
    ),

    // ==========================================
    // --- 2. NIKE ---
    // ==========================================
    Product(
      id: 511,
      title: "Club Fleece Pullover Hoodie",
      price: "\$65.00",
      oldPrice: "\$75.00",
      image: "https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&q=80",
      category: "hoodies",
      brand: "Nike",
      rating: 4.9,
      description:
          "Club fleece hoodie providing classic comfort with brushed fleece softness. Features an adjustable hood and kangaroo pocket.",
    ),
    Product(
      id: 512,
      title: "Sportswear Essential T-Shirt",
      price: "\$35.00",
      oldPrice: "\$42.00",
      image: "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&q=80",
      category: "t-shirts",
      brand: "Nike",
      rating: 4.6,
      description:
          "Soft everyday cotton T-shirt cut with a relaxed fit and embroidered Nike swoosh logo on the chest.",
    ),
    Product(
      id: 513,
      title: "Windrunner Full-Zip Jacket",
      price: "\$110.00",
      oldPrice: "\$130.00",
      image: "https://images.unsplash.com/photo-1606902965551-dce093cda6e7?w=800&q=80",
      category: "jackets",
      brand: "Nike",
      rating: 4.8,
      description:
          "Iconic chevron design running jacket made with lightweight, water-repellent woven fabric and breathable mesh lining.",
    ),
    Product(
      id: 514,
      title: "Sportswear Club Fleece Trousers",
      price: "\$60.00",
      oldPrice: "\$70.00",
      image: "https://images.unsplash.com/photo-1552902865-b72c031ac5ea?w=800&q=80",
      category: "trousers",
      brand: "Nike",
      rating: 4.7,
      description:
          "Comfortable fleece joggers with ribbed cuffs, elastic waistband with drawcord, and classic athletic styling.",
    ),
    Product(
      id: 515,
      title: "Sportswear Tech Fleece Full-Zip",
      price: "\$140.00",
      oldPrice: "\$160.00",
      image: "https://images.unsplash.com/photo-1578768079052-aa76e520036c?w=800&q=80",
      category: "hoodies",
      brand: "Nike",
      rating: 4.9,
      description:
          "Smooth on both sides, lightweight warmth premium Tech Fleece jacket with signature taped chevron chest pocket.",
    ),
    Product(
      id: 516,
      title: "Dri-FIT Academy Track Jacket",
      price: "\$70.00",
      oldPrice: "\$85.00",
      image: "https://images.unsplash.com/photo-1517438476312-10d79c077509?w=800&q=80",
      category: "jackets",
      brand: "Nike",
      rating: 4.7,
      description:
          "Sweat-wicking track jacket designed with mesh panels at chest and sides for optimal airflow during training sessions.",
    ),
    Product(
      id: 517,
      title: "Nike Air French Terry Crew Sweatshirt",
      price: "\$75.00",
      oldPrice: "\$90.00",
      image: "https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=800&q=80",
      category: "hoodies",
      brand: "Nike",
      rating: 4.8,
      description:
          "Midweight French terry crewneck with classic ribbed trims and bold satin-stitch Nike Air graphic across the chest.",
    ),

    // ==========================================
    // --- 3. H&M ---
    // ==========================================
    Product(
      id: 521,
      title: "Relaxed Fit Denim Overshirt",
      price: "\$39.99",
      oldPrice: "\$49.99",
      image: "https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=800&q=80",
      category: "shirts",
      brand: "H&M",
      rating: 4.5,
      description:
          "Overshirt in sturdy washed cotton denim with a collar, buttons down the front, and chest pockets with flaps.",
    ),
    Product(
      id: 522,
      title: "Slim Fit Washed Jeans",
      price: "\$49.99",
      oldPrice: "\$59.99",
      image: "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&q=80",
      category: "jeans",
      brand: "H&M",
      rating: 4.4,
      description:
          "Classic 5-pocket jeans in slightly stretchy denim with a regular waist, zip fly, and slim legs.",
    ),
    Product(
      id: 523,
      title: "Ribbed Knit Turtleneck Sweater",
      price: "\$29.99",
      oldPrice: "\$39.99",
      image: "https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=800&q=80",
      category: "knitwear",
      brand: "H&M",
      rating: 4.6,
      description:
          "Soft, fine-knit sweater in a warm ribbed texture with a stand-up collar and long sleeves.",
    ),
    Product(
      id: 524,
      title: "Cotton Poplin Shirt Dress",
      price: "\$44.99",
      oldPrice: "\$54.99",
      image: "https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=800&q=80",
      category: "dresses",
      brand: "H&M",
      rating: 4.3,
      description:
          "Knee-length dress in crisp cotton poplin with a collar, buttons down the front, and a detachable tie belt.",
    ),
    Product(
      id: 525,
      title: "Wool-Blend Overcoat",
      price: "\$99.00",
      oldPrice: "\$129.00",
      image: "https://images.unsplash.com/photo-1539533118447-63fcce667823?w=800&q=80",
      category: "jackets",
      brand: "H&M",
      rating: 4.6,
      description:
          "Knee-length coat in woven, felted wool blend with notch lapels, diagonal side welt pockets, and back vent.",
    ),
    Product(
      id: 526,
      title: "Regular Fit Linen-Blend Shirt",
      price: "\$34.99",
      oldPrice: "\$44.99",
      image: "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=800&q=80",
      category: "shirts",
      brand: "H&M",
      rating: 4.5,
      description:
          "Airy cotton and linen blend shirt with a turn-down collar, classic front placket, and curved hem.",
    ),
    Product(
      id: 527,
      title: "Relaxed Fit Cotton Cargo Pants",
      price: "\$49.99",
      oldPrice: "\$59.99",
      image: "https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=800&q=80",
      category: "trousers",
      brand: "H&M",
      rating: 4.5,
      description:
          "Cotton twill utility cargo pants featuring side flap pockets, relaxed leg cut, and drawstring ankle cuffs.",
    ),

    // ==========================================
    // --- 4. GUCCI ---
    // ==========================================
    Product(
      id: 531,
      title: "GG Jacquard Knit Cardigan",
      price: "\$1,450.00",
      oldPrice: "\$1,650.00",
      image: "https://images.unsplash.com/photo-1516762689617-e1cffcef479d?w=800&q=80",
      category: "knitwear",
      brand: "Gucci",
      rating: 4.9,
      description:
          "Luxurious wool cardigan knitted with the iconic GG pattern. Finished with enameled crest buttons and ribbed trims.",
    ),
    Product(
      id: 532,
      title: "Web Stripe Cotton Polo Shirt",
      price: "\$680.00",
      oldPrice: "\$780.00",
      image: "https://images.unsplash.com/photo-1625910513413-5fc4f3bc420f?w=800&q=80",
      category: "shirts",
      brand: "Gucci",
      rating: 4.8,
      description:
          "Crafted from fine cotton piquet with Gucci's signature green and red Web collar detail.",
    ),
    Product(
      id: 533,
      title: "Silk Twill Floral Midi Dress",
      price: "\$2,100.00",
      oldPrice: "\$2,400.00",
      image: "https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=800&q=80",
      category: "dresses",
      brand: "Gucci",
      rating: 5.0,
      description:
          "Exquisite Italian silk dress printed with a vintage botanical floral motif. Flowing silhouette with mother-of-pearl buttons.",
    ),
    Product(
      id: 534,
      title: "Technical Jersey Zip Hoodie",
      price: "\$1,250.00",
      oldPrice: "\$1,400.00",
      image: "https://images.unsplash.com/photo-1509967419530-da38b4704bc6?w=800&q=80",
      category: "hoodies",
      brand: "Gucci",
      rating: 4.7,
      description:
          "Retro-sportswear inspired zip jacket in technical jersey with contrast sleeve tape detailing.",
    ),
    Product(
      id: 535,
      title: "Tailored Velvet Evening Blazer",
      price: "\$2,850.00",
      oldPrice: "\$3,200.00",
      image: "https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800&q=80",
      category: "jackets",
      brand: "Gucci",
      rating: 5.0,
      description:
          "Sumptuous deep black cotton velvet tailored jacket with silk grosgrain peak lapels and jacquard lining.",
    ),
    Product(
      id: 536,
      title: "Interlocking G Heavy Cotton Sweatshirt",
      price: "\$980.00",
      oldPrice: "\$1,100.00",
      image: "https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&q=80",
      category: "hoodies",
      brand: "Gucci",
      rating: 4.8,
      description:
          "Oversized sweatshirt crafted in felted organic cotton jersey with distressed vintage Interlocking G print.",
    ),
    Product(
      id: 537,
      title: "Pleated Silk-Blend Wide Trousers",
      price: "\$1,150.00",
      oldPrice: "\$1,300.00",
      image: "https://images.unsplash.com/photo-1509551388413-e18d0ac5d495?w=800&q=80",
      category: "trousers",
      brand: "Gucci",
      rating: 4.9,
      description:
          "High-rise fluid trousers in silk-wool cady with double front pleats and horn buttons.",
    ),

    // ==========================================
    // --- 5. DIOR ---
    // ==========================================
    Product(
      id: 541,
      title: "Dior Oblique Hooded Sweatshirt",
      price: "\$1,650.00",
      oldPrice: "\$1,850.00",
      image: "https://images.unsplash.com/photo-1508427953056-b00b8d78ebf5?w=800&q=80",
      category: "hoodies",
      brand: "Dior",
      rating: 4.9,
      description:
          "Relaxed-fit hoodie in double-sided cotton fleece adorned with the all-over tone-on-tone Dior Oblique motif.",
    ),
    Product(
      id: 542,
      title: "Tailored Wool Twill Jacket",
      price: "\$2,800.00",
      oldPrice: "\$3,100.00",
      image: "https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&q=80",
      category: "jackets",
      brand: "Dior",
      rating: 5.0,
      description:
          "Exceptional Christian Dior tailored jacket crafted in black super-120s virgin wool twill with satin-covered peak lapels.",
    ),
    Product(
      id: 543,
      title: "Pleated Mid-Length Shirt Dress",
      price: "\$3,200.00",
      oldPrice: "\$3,500.00",
      image: "https://images.unsplash.com/photo-1568252542512-9fe8fe9c87bb?w=800&q=80",
      category: "dresses",
      brand: "Dior",
      rating: 4.9,
      description:
          "Iconic Dior silhouette shirt dress featuring a fitted waistline and Sunray-pleated skirt in cotton poplin.",
    ),
    Product(
      id: 544,
      title: "Straight-Cut Raw Denim Trousers",
      price: "\$1,150.00",
      oldPrice: "\$1,300.00",
      image: "https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=800&q=80",
      category: "jeans",
      brand: "Dior",
      rating: 4.8,
      description:
          "Japanese raw selvedge denim jeans featuring the signature Dior back pocket stitching and leather jacron label.",
    ),
    Product(
      id: 545,
      title: "Cashmere Double-Face Stand Collar Coat",
      price: "\$3,900.00",
      oldPrice: "\$4,300.00",
      image: "https://images.unsplash.com/photo-1539533018447-63fcce667823?w=800&q=80",
      category: "jackets",
      brand: "Dior",
      rating: 5.0,
      description:
          "Handcrafted double-faced cashmere overcoat featuring a minimalist stand collar and horn buttons.",
    ),
    Product(
      id: 546,
      title: "Christian Dior Bee Embroidered Shirt",
      price: "\$850.00",
      oldPrice: "\$950.00",
      image: "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=800&q=80",
      category: "shirts",
      brand: "Dior",
      rating: 4.8,
      description:
          "Crisp cotton poplin dress shirt tailored with a small collar and subtle silver-embroidered Dior bee emblem.",
    ),
    Product(
      id: 547,
      title: "Cannage Quilted Zip Vest",
      price: "\$1,950.00",
      oldPrice: "\$2,200.00",
      image: "https://images.unsplash.com/photo-1544441893-675973e31985?w=800&q=80",
      category: "jackets",
      brand: "Dior",
      rating: 4.9,
      description:
          "Lightweight down-filled gilet showcasing the hallmark Cannage quilting in technical micro-twill.",
    ),

    // ==========================================
    // --- 6. ADIDAS ---
    // ==========================================
    Product(
      id: 551,
      title: "Adicolor Classics Firebird Track Top",
      price: "\$80.00",
      oldPrice: "\$95.00",
      image: "https://images.unsplash.com/photo-1517438476312-10d79c077509?w=800&q=80",
      category: "jackets",
      brand: "Adidas",
      rating: 4.8,
      description:
          "The legendary Firebird tracksuit top in shiny recycled tricot. Features the stand-up collar, full zip, and iconic 3-Stripes down each sleeve.",
    ),
    Product(
      id: 552,
      title: "Originals Trefoil Fleece Hoodie",
      price: "\$70.00",
      oldPrice: "\$80.00",
      image: "https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&q=80",
      category: "hoodies",
      brand: "Adidas",
      rating: 4.7,
      description:
          "Heavyweight French terry pullover with a prominent rubberized Trefoil logo front and center. Ribbed hem and cuffs for casual comfort.",
    ),
    Product(
      id: 553,
      title: "3-Stripes Classic Cotton Tee",
      price: "\$35.00",
      oldPrice: "\$42.00",
      image: "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&q=80",
      category: "t-shirts",
      brand: "Adidas",
      rating: 4.6,
      description:
          "Heritage cotton jersey ringer tee with contrast ribbed crewneck and cuffs, finished with stitched 3-Stripes.",
    ),
    Product(
      id: 554,
      title: "Tiro 24 Training Windbreaker",
      price: "\$75.00",
      oldPrice: "\$90.00",
      image: "https://images.unsplash.com/photo-1606902965551-dce093cda6e7?w=800&q=80",
      category: "jackets",
      brand: "Adidas",
      rating: 4.7,
      description:
          "AEROREADY wind-resistant lightweight jacket engineered for wet, breezy days on the pitch or street.",
    ),
    Product(
      id: 555,
      title: "Adicolor Classics Firebird Track Pants",
      price: "\$70.00",
      oldPrice: "\$85.00",
      image: "https://images.unsplash.com/photo-1552902865-b72c031ac5ea?w=800&q=80",
      category: "trousers",
      brand: "Adidas",
      rating: 4.8,
      description:
          "Relaxed-fit track pants in smooth tricot fabric with zippered ankle cuffs, elastic waistband, and side zip pockets.",
    ),
    Product(
      id: 556,
      title: "Puffer Down Athletic Winter Jacket",
      price: "\$160.00",
      oldPrice: "\$190.00",
      image: "https://images.unsplash.com/photo-1544441893-675973e31985?w=800&q=80",
      category: "jackets",
      brand: "Adidas",
      rating: 4.9,
      description:
          "Warm insulated winter puffer coat with duck down fill, water-repellent shell, and high protective collar.",
    ),
    Product(
      id: 557,
      title: "Torsion Tech Zip Running Top",
      price: "\$65.00",
      oldPrice: "\$80.00",
      image: "https://images.unsplash.com/photo-1578768079052-aa76e520036c?w=800&q=80",
      category: "sportswear",
      brand: "Adidas",
      rating: 4.7,
      description:
          "Half-zip thermal training top with thumbhole sleeves and reflective accents for morning and evening runs.",
    ),

    // ==========================================
    // --- 7. LEVI'S ---
    // ==========================================
    Product(
      id: 561,
      title: "Original Trucker Denim Jacket",
      price: "\$98.00",
      oldPrice: "\$118.00",
      image: "https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=800&q=80",
      category: "jackets",
      brand: "Levi's",
      rating: 4.9,
      description:
          "The definitive denim jacket since 1967. 100% non-stretch cotton denim with pointed collar, button flap chest pockets, and side hem adjusters.",
    ),
    Product(
      id: 562,
      title: "501 Original Fit Straight Jeans",
      price: "\$79.50",
      oldPrice: "\$98.00",
      image: "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&q=80",
      category: "jeans",
      brand: "Levi's",
      rating: 4.9,
      description:
          "The blueprint for every pair of jeans in existence. Classic straight leg, iconic button fly, and signature leather patch.",
    ),
    Product(
      id: 563,
      title: "Sherpa-Lined Corduroy Trucker",
      price: "\$128.00",
      oldPrice: "\$148.00",
      image: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&q=80",
      category: "jackets",
      brand: "Levi's",
      rating: 4.8,
      description:
          "Vintage-inspired wide-wale corduroy jacket insulated with plush faux sherpa lining along the collar and body.",
    ),
    Product(
      id: 564,
      title: "Classic Barstow Western Denim Shirt",
      price: "\$69.50",
      oldPrice: "\$85.00",
      image: "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=800&q=80",
      category: "shirts",
      brand: "Levi's",
      rating: 4.7,
      description:
          "Authentic western shirt featuring peaked front and back yokes, snap-flap pockets, and pearlized snap buttons.",
    ),
    Product(
      id: 565,
      title: "511 Slim Fit Flex Jeans",
      price: "\$69.50",
      oldPrice: "\$89.50",
      image: "https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=800&q=80",
      category: "jeans",
      brand: "Levi's",
      rating: 4.6,
      description:
          "Modern slim-cut jeans with room to move. Woven with Levi's Flex stretch technology for maximum comfort.",
    ),
    Product(
      id: 566,
      title: "Sunset 1-Pocket Plaid Flannel",
      price: "\$59.50",
      oldPrice: "\$75.00",
      image: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&q=80",
      category: "shirts",
      brand: "Levi's",
      rating: 4.7,
      description:
          "Heavy brushed cotton flannel shirt in traditional buffalo check with a single chest pocket and button cuffs.",
    ),
    Product(
      id: 567,
      title: "Standard Graphic Crewneck Sweatshirt",
      price: "\$55.00",
      oldPrice: "\$68.00",
      image: "https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=800&q=80",
      category: "hoodies",
      brand: "Levi's",
      rating: 4.6,
      description:
          "Essential casual fleece crew sweatshirt stamped with the iconic Levi's red batwing logo across the chest.",
    ),

    // ==========================================
    // --- 8. UNIQLO ---
    // ==========================================
    Product(
      id: 571,
      title: "Ultra Light Down Seamless Parka",
      price: "\$89.90",
      oldPrice: "\$109.90",
      image: "https://images.unsplash.com/photo-1544441893-675973e31985?w=800&q=80",
      category: "jackets",
      brand: "Uniqlo",
      rating: 4.9,
      description:
          "Incredibly lightweight yet exceptionally warm down jacket with seamless windproof construction and water-repellent coating.",
    ),
    Product(
      id: 572,
      title: "Souffle Yarn Mock Neck Knit Sweater",
      price: "\$39.90",
      oldPrice: "\$49.90",
      image: "https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=800&q=80",
      category: "knitwear",
      brand: "Uniqlo",
      rating: 4.8,
      description:
          "Non-itchy souffle yarn knit featuring a cloud-soft, airy texture with a refined mock neckline and relaxed fit.",
    ),
    Product(
      id: 573,
      title: "AIRism Cotton Oversized Crewneck Tee",
      price: "\$24.90",
      oldPrice: "\$29.90",
      image: "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&q=80",
      category: "t-shirts",
      brand: "Uniqlo",
      rating: 4.9,
      description:
          "Double-face fabric combines soft cotton exterior with silky AIRism moisture-wicking interior. Modern drop-shoulder boxy cut.",
    ),
    Product(
      id: 574,
      title: "Fluffy Yarn Fleece Full-Zip Jacket",
      price: "\$39.90",
      oldPrice: "\$49.90",
      image: "https://images.unsplash.com/photo-1508427953056-b00b8d78ebf5?w=800&q=80",
      category: "jackets",
      brand: "Uniqlo",
      rating: 4.7,
      description:
          "Long-pile plush fleece jacket with a high wind-blocking stand collar, deep side pockets, and lightweight thermal insulation.",
    ),
    Product(
      id: 575,
      title: "Smart 2-Way Stretch Ankle Trousers",
      price: "\$49.90",
      oldPrice: "\$59.90",
      image: "https://images.unsplash.com/photo-1509551388413-e18d0ac5d495?w=800&q=80",
      category: "trousers",
      brand: "Uniqlo",
      rating: 4.8,
      description:
          "Tailored look with sweatpants comfort. High-performance two-way stretch fabric with center crease and elastic inner waist.",
    ),
    Product(
      id: 576,
      title: "Extra Fine Merino Wool Crew Sweater",
      price: "\$49.90",
      oldPrice: "\$59.90",
      image: "https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=800&q=80",
      category: "knitwear",
      brand: "Uniqlo",
      rating: 4.7,
      description:
          "Crafted from 100% 19.5-micron ultra-fine merino wool with an elegant lustrous sheen. Machine washable.",
    ),
    Product(
      id: 577,
      title: "Pleated Wide-Leg Drape Pants",
      price: "\$49.90",
      oldPrice: "\$59.90",
      image: "https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=800&q=80",
      category: "trousers",
      brand: "Uniqlo",
      rating: 4.6,
      description:
          "Effortless wide-leg trousers cut in a wrinkle-resistant drape fabric with comfortable elastic back waistband.",
    ),

    // ==========================================
    // --- 9. PUMA ---
    // ==========================================
    Product(
      id: 581,
      title: "T7 Iconic Track Full-Zip Jacket",
      price: "\$75.00",
      oldPrice: "\$85.00",
      image: "https://images.unsplash.com/photo-1517438476312-10d79c077509?w=800&q=80",
      category: "jackets",
      brand: "Puma",
      rating: 4.7,
      description:
          "Heritage athletic track jacket featuring Puma's signature 7cm contrast shoulder stripes and rubberized Archive No. 1 logo.",
    ),
    Product(
      id: 582,
      title: "Classics Colorblock Fleece Hoodie",
      price: "\$60.00",
      oldPrice: "\$70.00",
      image: "https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&q=80",
      category: "hoodies",
      brand: "Puma",
      rating: 4.6,
      description:
          "Bold retro colorblocked hoodie lined with brushed fleece. Roomy kangaroo pouch pocket and adjustable jersey-lined hood.",
    ),
    Product(
      id: 583,
      title: "Motorsport Street Windbreaker",
      price: "\$110.00",
      oldPrice: "\$130.00",
      image: "https://images.unsplash.com/photo-1606902965551-dce093cda6e7?w=800&q=80",
      category: "jackets",
      brand: "Puma",
      rating: 4.8,
      description:
          "Sleek motorsport-inspired water-resistant outer jacket featuring articulated sleeves and contrast ergonomic zip pulls.",
    ),
    Product(
      id: 584,
      title: "ESS Small Logo Athletic Sweatshirt",
      price: "\$50.00",
      oldPrice: "\$60.00",
      image: "https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=800&q=80",
      category: "hoodies",
      brand: "Puma",
      rating: 4.5,
      description:
          "Clean minimalist crewneck sweatshirt crafted from BCI sustainable cotton fleece with subtle embroidered cat logo.",
    ),
    Product(
      id: 585,
      title: "Iconic T7 Slim Fit Joggers",
      price: "\$65.00",
      oldPrice: "\$75.00",
      image: "https://images.unsplash.com/photo-1552902865-b72c031ac5ea?w=800&q=80",
      category: "trousers",
      brand: "Puma",
      rating: 4.7,
      description:
          "Slim athletic joggers with tapered ribbed cuffs, contrast side panel inserts, and deep zipped hand pockets.",
    ),
    Product(
      id: 586,
      title: "WarmCELL Puffer Hooded Coat",
      price: "\$130.00",
      oldPrice: "\$155.00",
      image: "https://images.unsplash.com/photo-1544441893-675973e31985?w=800&q=80",
      category: "jackets",
      brand: "Puma",
      rating: 4.8,
      description:
          "Thermal warmCELL insulated winter jacket engineered to trap heat close to the body for superior cold-weather protection.",
    ),
    Product(
      id: 587,
      title: "Performance Training Half-Zip Top",
      price: "\$55.00",
      oldPrice: "\$65.00",
      image: "https://images.unsplash.com/photo-1578768079052-aa76e520036c?w=800&q=80",
      category: "sportswear",
      brand: "Puma",
      rating: 4.6,
      description:
          "dryCELL moisture-management lightweight mid-layer top with ergonomic raglan sleeves and stand collar.",
    ),

    // ==========================================
    // --- 10. MANGO ---
    // ==========================================
    Product(
      id: 591,
      title: "Handmade Wool-Blend Wrap Coat",
      price: "\$199.99",
      oldPrice: "\$249.99",
      image: "https://images.unsplash.com/photo-1539533018447-63fcce667823?w=800&q=80",
      category: "jackets",
      brand: "Mango",
      rating: 4.9,
      description:
          "Luxurious artisan-finished wrap coat crafted from soft virgin wool blend with a generous shawl lapel and self-tie waist belt.",
    ),
    Product(
      id: 592,
      title: "Structured Herringbone Blazer",
      price: "\$129.99",
      oldPrice: "\$159.99",
      image: "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&q=80",
      category: "jackets",
      brand: "Mango",
      rating: 4.7,
      description:
          "Tailored blazer in classic herringbone pattern with pronounced shoulder pads, ticket pocket, and inner lining.",
    ),
    Product(
      id: 593,
      title: "Flowy Belted Satin Midi Dress",
      price: "\$89.99",
      oldPrice: "\$119.99",
      image: "https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800&q=80",
      category: "dresses",
      brand: "Mango",
      rating: 4.8,
      description:
          "Sophisticated evening midi dress in lustrous champagne satin with draped cowl neckline and side slit hem.",
    ),
    Product(
      id: 594,
      title: "100% French Linen Classic Shirt",
      price: "\$59.99",
      oldPrice: "\$79.99",
      image: "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=800&q=80",
      category: "shirts",
      brand: "Mango",
      rating: 4.6,
      description:
          "Breezy relaxed-cut shirt woven entirely from premium French flax linen with mother-of-pearl buttons.",
    ),
    Product(
      id: 595,
      title: "Wide-Leg High-Waist Suit Trousers",
      price: "\$79.99",
      oldPrice: "\$99.99",
      image: "https://images.unsplash.com/photo-1509551388413-e18d0ac5d495?w=800&q=80",
      category: "trousers",
      brand: "Mango",
      rating: 4.7,
      description:
          "High-rise structured trousers with sharp pressed creases, hook-and-eye bar closure, and elongating straight leg cut.",
    ),
    Product(
      id: 596,
      title: "Cable-Knit Turtleneck Wool Sweater",
      price: "\$69.99",
      oldPrice: "\$89.99",
      image: "https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=800&q=80",
      category: "knitwear",
      brand: "Mango",
      rating: 4.8,
      description:
          "Heritage diamond cable-knit jumper crafted with warm wool blend, ribbed trims, and snug roll collar.",
    ),
    Product(
      id: 597,
      title: "Belted Trench Coat with Horn Buttons",
      price: "\$159.99",
      oldPrice: "\$199.99",
      image: "https://images.unsplash.com/photo-1544441893-675973e31985?w=800&q=80",
      category: "jackets",
      brand: "Mango",
      rating: 4.8,
      description:
          "Timeless double-breasted trench in camel gabardine featuring gun flap, removable waist belt, and storm collar.",
    ),
  ];
}
