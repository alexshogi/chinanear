/*
  Warnings:

  - You are about to drop the column `category1` on the `Product` table. All the data in the column will be lost.
  - You are about to drop the column `category2` on the `Product` table. All the data in the column will be lost.
  - You are about to drop the column `category3` on the `Product` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Product" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "titleRu" TEXT NOT NULL DEFAULT '',
    "titleEn" TEXT NOT NULL DEFAULT '',
    "titleCh" TEXT NOT NULL DEFAULT '',
    "captionRu" TEXT NOT NULL DEFAULT '',
    "captionEn" TEXT NOT NULL DEFAULT '',
    "captionCh" TEXT NOT NULL DEFAULT '',
    "descriptionRu" TEXT NOT NULL DEFAULT '',
    "descriptionEn" TEXT NOT NULL DEFAULT '',
    "descriptionCh" TEXT NOT NULL DEFAULT '',
    "balance" INTEGER,
    "category" TEXT,
    "subCategory" TEXT,
    "subSubCategory" TEXT,
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
    CONSTRAINT "Product_category_fkey" FOREIGN KEY ("category") REFERENCES "Category" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Product_subCategory_fkey" FOREIGN KEY ("subCategory") REFERENCES "SubCategory" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Product_subSubCategory_fkey" FOREIGN KEY ("subSubCategory") REFERENCES "SubSubCategory" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Product_author_fkey" FOREIGN KEY ("author") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Product_seller_fkey" FOREIGN KEY ("seller") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_Product" ("author", "balance", "captionCh", "captionEn", "captionRu", "createdAt", "descriptionCh", "descriptionEn", "descriptionRu", "id", "image_extension", "image_filesize", "image_height", "image_id", "image_width", "intervals", "isActive", "seller", "titleCh", "titleEn", "titleRu", "updatedAt") SELECT "author", "balance", "captionCh", "captionEn", "captionRu", "createdAt", "descriptionCh", "descriptionEn", "descriptionRu", "id", "image_extension", "image_filesize", "image_height", "image_id", "image_width", "intervals", "isActive", "seller", "titleCh", "titleEn", "titleRu", "updatedAt" FROM "Product";
DROP TABLE "Product";
ALTER TABLE "new_Product" RENAME TO "Product";
CREATE INDEX "Product_category_idx" ON "Product"("category");
CREATE INDEX "Product_subCategory_idx" ON "Product"("subCategory");
CREATE INDEX "Product_subSubCategory_idx" ON "Product"("subSubCategory");
CREATE INDEX "Product_author_idx" ON "Product"("author");
CREATE INDEX "Product_seller_idx" ON "Product"("seller");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
