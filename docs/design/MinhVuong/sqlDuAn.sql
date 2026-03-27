-- =============================================
-- DỮ LIỆU MẪU MỚI - E-commerce Thực phẩm + AI Chatbot
-- PostgreSQL 18
-- =============================================

-- 1. USER
INSERT INTO "user" (name, email, password_hash, phone, role) VALUES
('Nguyễn Văn An', 'an.nguyen@gmail.com', '$2b$12$demoHash1234567890abcdef', '0912345678', 'customer'),
('Trần Thị Mai', 'mai.tran@gmail.com', '$2b$12$demoHash1234567890abcdef', '0987654321', 'customer'),
('Lê Hoàng Nam', 'nam.le@gmail.com', '$2b$12$demoHash1234567890abcdef', '0934567890', 'admin'),
('Phạm Thị Lan', 'lan.pham@gmail.com', '$2b$12$demoHash1234567890abcdef', '0978123456', 'customer')
ON CONFLICT (email) DO NOTHING;

-- 2. CATEGORY (Danh mục + danh mục con)
INSERT INTO category (name, slug, is_active, parent_id) VALUES
('Rau củ quả', 'rau-cu-qua', true, NULL),
('Thịt & Hải sản', 'thit-hai-san', true, NULL),
('Trái cây tươi', 'trai-cay-tuoi', true, NULL),
('Sữa & Sản phẩm từ sữa', 'sua-san-pham-tu-sua', true, NULL),
('Đồ khô & Gia vị', 'do-kho-gia-vi', true, NULL),

-- Danh mục con
('Rau lá xanh', 'rau-la-xanh', true, (SELECT id FROM category WHERE slug = 'rau-cu-qua')),
('Củ quả', 'cu-qua', true, (SELECT id FROM category WHERE slug = 'rau-cu-qua')),
('Thịt heo', 'thit-heo', true, (SELECT id FROM category WHERE slug = 'thit-hai-san')),
('Cá tươi', 'ca-tuoi', true, (SELECT id FROM category WHERE slug = 'thit-hai-san')),
('Trái cây miền Nam', 'trai-cay-mien-nam', true, (SELECT id FROM category WHERE slug = 'trai-cay-tuoi')),
('Sữa tươi', 'sua-tuoi', true, (SELECT id FROM category WHERE slug = 'sua-san-pham-tu-sua'))
ON CONFLICT (slug) DO NOTHING;

-- 3. PRODUCT (Sản phẩm thực phẩm)
INSERT INTO product (category_id, name, slug, description, unit, is_active) VALUES
((SELECT id FROM category WHERE slug = 'rau-la-xanh'), 'Rau bina hữu cơ', 'rau-bina-huu-co', 'Rau bina tươi sạch, trồng theo tiêu chuẩn hữu cơ tại Lâm Đồng', 'bó 300g', true),
((SELECT id FROM category WHERE slug = 'cu-qua'), 'Cà rốt Đà Lạt loại 1', 'ca-rot-da-lat', 'Cà rốt ngọt, giòn, không thuốc trừ sâu', 'kg', true),
((SELECT id FROM category WHERE slug = 'thit-heo'), 'Thịt heo ba chỉ sạch', 'thit-heo-ba-chi-sach', 'Thịt heo ba chỉ tươi, nuôi sạch', 'kg', true),
((SELECT id FROM category WHERE slug = 'ca-tuoi'), 'Cá basa fillet tươi', 'ca-basa-fillet-tuoi', 'Cá basa fillet cắt sẵn, không xương', 'kg', true),
((SELECT id FROM category WHERE slug = 'trai-cay-mien-nam'), 'Chuối già hương Việt Nam', 'chuoi-gia-huong', 'Chuối già hương chín tự nhiên, ngọt thơm', 'nải', true),
((SELECT id FROM category WHERE slug = 'sua-tuoi'), 'Sữa tươi không đường Vinamilk', 'sua-tuoi-vinamilk', 'Sữa tươi tiệt trùng không đường hộp 1 lít', 'hộp', true),
((SELECT id FROM category WHERE slug = 'rau-la-xanh'), 'Rau muống nước', 'rau-muong-nuoc', 'Rau muống tươi ngon, sạch', 'kg', true),
((SELECT id FROM category WHERE slug = 'trai-cay-mien-nam'), 'Xoài cát Hòa Lộc', 'xoai-cat-hoa-loc', 'Xoài cát Hòa Lộc ngọt, thơm, ít xơ', 'kg', true)
ON CONFLICT (slug) DO NOTHING;

-- 4. PRODUCT_PRICE
INSERT INTO product_price (product_id, price, sale_price, effective_from) VALUES
((SELECT id FROM product WHERE slug = 'rau-bina-huu-co'), 28000, 25000, NOW()),
((SELECT id FROM product WHERE slug = 'ca-rot-da-lat'), 22000, NULL, NOW()),
((SELECT id FROM product WHERE slug = 'thit-heo-ba-chi-sach'), 158000, 148000, NOW()),
((SELECT id FROM product WHERE slug = 'ca-basa-fillet-tuoi'), 105000, 95000, NOW()),
((SELECT id FROM product WHERE slug = 'chuoi-gia-huong'), 42000, NULL, NOW()),
((SELECT id FROM product WHERE slug = 'sua-tuoi-vinamilk'), 32000, 29000, NOW()),
((SELECT id FROM product WHERE slug = 'rau-muong-nuoc'), 18000, NULL, NOW()),
((SELECT id FROM product WHERE slug = 'xoai-cat-hoa-loc'), 65000, 59000, NOW());

-- 5. PRODUCT_IMAGE
INSERT INTO product_image (product_id, url, is_primary, sort_order) VALUES
((SELECT id FROM product WHERE slug = 'rau-bina-huu-co'), 'https://picsum.photos/id/1015/600/400', true, 1),
((SELECT id FROM product WHERE slug = 'ca-rot-da-lat'), 'https://picsum.photos/id/106/600/400', true, 1),
((SELECT id FROM product WHERE slug = 'thit-heo-ba-chi-sach'), 'https://picsum.photos/id/292/600/400', true, 1),
((SELECT id FROM product WHERE slug = 'ca-basa-fillet-tuoi'), 'https://picsum.photos/id/431/600/400', true, 1),
((SELECT id FROM product WHERE slug = 'chuoi-gia-huong'), 'https://picsum.photos/id/669/600/400', true, 1),
((SELECT id FROM product WHERE slug = 'sua-tuoi-vinamilk'), 'https://picsum.photos/id/870/600/400', true, 1);

-- 6. INVENTORY (Tồn kho)
INSERT INTO inventory (product_id, stock, reserved) VALUES
((SELECT id FROM product WHERE slug = 'rau-bina-huu-co'), 245, 10),
((SELECT id FROM product WHERE slug = 'ca-rot-da-lat'), 180, 25),
((SELECT id FROM product WHERE slug = 'thit-heo-ba-chi-sach'), 65, 8),
((SELECT id FROM product WHERE slug = 'ca-basa-fillet-tuoi'), 132, 15),
((SELECT id FROM product WHERE slug = 'chuoi-gia-huong'), 87, 0),
((SELECT id FROM product WHERE slug = 'sua-tuoi-vinamilk'), 420, 30),
((SELECT id FROM product WHERE slug = 'rau-muong-nuoc'), 310, 5),
((SELECT id FROM product WHERE slug = 'xoai-cat-hoa-loc'), 95, 12);

-- 7. ADDRESS (Địa chỉ)
INSERT INTO address (user_id, street, district, city, province, is_default) VALUES
((SELECT id FROM "user" WHERE email = 'an.nguyen@gmail.com'), '123 Nguyễn Thị Minh Khai', 'Quận 1', 'TP. Hồ Chí Minh', 'Hồ Chí Minh', true),
((SELECT id FROM "user" WHERE email = 'mai.tran@gmail.com'), '45 Lê Lợi', 'Quận 3', 'TP. Hồ Chí Minh', 'Hồ Chí Minh', true),
((SELECT id FROM "user" WHERE email = 'lan.pham@gmail.com'), '67 Đường số 8', 'Quận 7', 'TP. Hồ Chí Minh', 'Hồ Chí Minh', true);

-- 8. CART & CART_ITEM
INSERT INTO cart (user_id) 
SELECT id FROM "user" WHERE email = 'an.nguyen@gmail.com'
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO cart_item (cart_id, product_id, quantity) VALUES
((SELECT id FROM cart WHERE user_id = (SELECT id FROM "user" WHERE email = 'an.nguyen@gmail.com')),
 (SELECT id FROM product WHERE slug = 'rau-bina-huu-co'), 3),
((SELECT id FROM cart WHERE user_id = (SELECT id FROM "user" WHERE email = 'an.nguyen@gmail.com')),
 (SELECT id FROM product WHERE slug = 'thit-heo-ba-chi-sach'), 2);
