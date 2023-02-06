-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL DEFAULT '',
    "surname" TEXT NOT NULL DEFAULT '',
    "email" TEXT NOT NULL DEFAULT '',
    "companyName" TEXT NOT NULL DEFAULT '',
    "companyMarketNameRu" TEXT NOT NULL DEFAULT '',
    "companyMarketNameEn" TEXT NOT NULL DEFAULT '',
    "postcode" TEXT NOT NULL DEFAULT '',
    "country" TEXT NOT NULL DEFAULT '',
    "city" TEXT NOT NULL DEFAULT '',
    "street" TEXT NOT NULL DEFAULT '',
    "house" TEXT NOT NULL DEFAULT '',
    "building" TEXT NOT NULL DEFAULT '',
    "password" TEXT NOT NULL,
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "Product" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "title" TEXT NOT NULL DEFAULT '',
    "caption" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '[{"type":"paragraph","children":[{"text":""}]}]',
    "balance" INTEGER,
    "category1" TEXT NOT NULL DEFAULT '',
    "category2" TEXT NOT NULL DEFAULT '',
    "category3" TEXT NOT NULL DEFAULT '',
    "intervals" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "image_filesize" INTEGER,
    "image_extension" TEXT,
    "image_width" INTEGER,
    "image_height" INTEGER,
    "image_id" TEXT,
    "author" TEXT,
    "seller" TEXT,
    CONSTRAINT "Product_author_fkey" FOREIGN KEY ("author") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Product_seller_fkey" FOREIGN KEY ("seller") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL DEFAULT ''
);

-- CreateTable
CREATE TABLE "Category" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "code" TEXT NOT NULL DEFAULT '',
    "titleRu" TEXT NOT NULL DEFAULT '',
    "titleEn" TEXT NOT NULL DEFAULT '',
    "titleCh" TEXT NOT NULL DEFAULT '',
    "isActive" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "Cart" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "user" TEXT,
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Cart_user_fkey" FOREIGN KEY ("user") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "OrderStatus" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "code" TEXT NOT NULL DEFAULT '',
    "color" TEXT NOT NULL DEFAULT '',
    "titleRu" TEXT NOT NULL DEFAULT '',
    "titleEn" TEXT NOT NULL DEFAULT '',
    "titleCh" TEXT NOT NULL DEFAULT '',
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "Order" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "products" TEXT,
    "user" TEXT,
    "seller" TEXT,
    "status" TEXT,
    "address" TEXT NOT NULL DEFAULT '',
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "confirmedAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "paidAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Order_user_fkey" FOREIGN KEY ("user") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Order_seller_fkey" FOREIGN KEY ("seller") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Order_status_fkey" FOREIGN KEY ("status") REFERENCES "OrderStatus" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_Product_tags" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_Product_tags_A_fkey" FOREIGN KEY ("A") REFERENCES "Product" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_Product_tags_B_fkey" FOREIGN KEY ("B") REFERENCES "Tag" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_Category_children" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_Category_children_A_fkey" FOREIGN KEY ("A") REFERENCES "Category" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_Category_children_B_fkey" FOREIGN KEY ("B") REFERENCES "Category" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_Cart_products" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_Cart_products_A_fkey" FOREIGN KEY ("A") REFERENCES "Cart" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_Cart_products_B_fkey" FOREIGN KEY ("B") REFERENCES "Product" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "Product_author_idx" ON "Product"("author");

-- CreateIndex
CREATE INDEX "Product_seller_idx" ON "Product"("seller");

-- CreateIndex
CREATE INDEX "Cart_user_idx" ON "Cart"("user");

-- CreateIndex
CREATE INDEX "Order_user_idx" ON "Order"("user");

-- CreateIndex
CREATE INDEX "Order_seller_idx" ON "Order"("seller");

-- CreateIndex
CREATE INDEX "Order_status_idx" ON "Order"("status");

-- CreateIndex
CREATE UNIQUE INDEX "_Product_tags_AB_unique" ON "_Product_tags"("A", "B");

-- CreateIndex
CREATE INDEX "_Product_tags_B_index" ON "_Product_tags"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_Category_children_AB_unique" ON "_Category_children"("A", "B");

-- CreateIndex
CREATE INDEX "_Category_children_B_index" ON "_Category_children"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_Cart_products_AB_unique" ON "_Cart_products"("A", "B");

-- CreateIndex
CREATE INDEX "_Cart_products_B_index" ON "_Cart_products"("B");
